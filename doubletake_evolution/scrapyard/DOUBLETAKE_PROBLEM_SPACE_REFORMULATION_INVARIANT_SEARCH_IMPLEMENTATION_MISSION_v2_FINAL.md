# DOUBLETAKE — Native Problem-Space Reformulation + Invariant-Guided Search
## Implementation mission, production integration, executable acceptance gates — v2 FINAL (2026-10-06)

> **Review status:** Iteratively hardened against the actual v1 directive and inspected DoubleTake architecture. This is a specification for coding agents, **not evidence that the upgrade has already been implemented or validated**. Report any unmet requirement rather than asserting completeness.

> **Execute this mission in the existing DoubleTake repository. This is a coding-agent instruction, not a research proposal.** Discover the live code, make the smallest coherent production changes, run the actual tests, and leave an auditable result. The goal is a material improvement in DoubleTake's ability to solve real tasks with less search, not a second reasoning engine or a demonstration that exists only in tests.

### 0. Authority, inputs, and non-negotiables

- **Authoritative repository:** `https://github.com/olejardamir/DT.git`, branch **`main`**. Work from the *live checked-out state*, not the commit described in this prompt. At the time of prompt preparation the inspected `main` tree was `0ea6cb271c16b417d3b8cbabdc7403e8f425382c`; that SHA is context, **not** a fixed target or permission to rewind.
- Follow the current `AGENTS.md`, `README.md`, `DOUBLETAKE_THESIS.md`, project architecture constraints, feature-governance contracts, and live CI/test collection rules. Where this document conflicts with an enforced rule, **the enforced rule wins**; document the conflict and continue with an authorized implementation.
- **Conceptual source:** Allen Newell and Herbert A. Simon, *Human Problem Solving* (1972), **the supplied 51-page excerpt only**. The excerpt contains the introduction and Chapter 3, “Task Environments,” particularly the number-scrabble/tic-tac-toe recoding example (printed pp. 60–71), problem-space representations and search alternatives (pp. 72–77), task invariants (pp. 80–83), and simplification of search spaces (pp. 83–85). It **does not** contain the later chapters, so do not claim their mechanisms were extracted from this excerpt.
- Source-derived principle: *The same task may admit different internal problem representations; the choice of representation, applicable operations, goal tests, and invariant features can drastically change how much search is required.* The architecture, contracts, proof protocol, code design, and benchmarks below are **engineering requirements for DoubleTake**, not quotations or established algorithms from Newell and Simon.
- No new LLM engine, scheduler, worker registry, authority plane, independent policy system, ungoverned execution path, global mutable planning singleton, always-on reasoning tax, or simulation of physical/biological cognition.
- Respect the L0/L1/L2 separation, enterprise/security boundaries, scope/tenant isolation, evidence ledger, operator gates, resource accounting, cancellation, timeouts, rollback, and postcondition validation. Never allow a reformulation to grant permission or turn untrusted model output into an execution authorization.
- **Do not disturb ongoing E17 enterprise-security closure or the Copilot-port readiness work.** Do not weaken tests, certificates, CI gates, reporting, or shipping-source bindings to make this mission pass. Treat a changed security surface as an explicit reviewed dependency, not an incidental refactor.
- Multiple other coding agents may be modifying `main`. Record starting HEAD and **base blob IDs for every file to be edited**, inspect `git status`, and compare those paths with their current blobs immediately before each edit/commit. Stage **only explicitly owned paths** (never `git add -A` over a shared tree), re-run impacted tests on the post-update state, and use the existing safe source-binding/push procedure. Do not clobber uncommitted work or force-push/rebase/reset/squash shared history. If a path has changed concurrently, merge deliberately or report `BLOCKED_CONCURRENT_CHANGE` with specifics. Do not claim that tests run against one HEAD validate a later HEAD whose measured imports changed.
- Prefer the existing local tests and adapters. Do not acquire paid services, send private data externally, or assume that an LLM/embedding provider is available. Any optional model-assisted candidate generation must flow through existing approved provider/security/inference controls; deterministic offline behavior must remain functional.

### 1. Mission objective — what must exist when finished

Implement **one native, bounded, operator-safe problem reformulation mechanism** that:

1. Accepts a **canonical task/problem from an existing DoubleTake owner** (never a new independent mission authority).
2. Describes its existing representation, allowable operations, goal conditions, protected constraints, and evidence provenance in a **typed, revision-bound problem view**.
3. Generates one or more **alternative internal representations** of the *same* task, supporting **(A) real structural recoding** and **(B) invariant/quotient-based search reduction** wherever the verified task domain permits them. Both mechanisms are required for full mission closure; they need not operate on the same task domain, but neither may exist only as a synthetic test.
4. Proves, through a **domain-appropriate machine-checkable certificate**, that the candidate reformulation preserves the required task semantics. A model's confidence statement is *not* a proof.
5. Derives **sound invariants** from owner facts and certified domain rules to eliminate impossible, redundant, or provably dominated search states/operators **before costly expansion or dispatch** (with only minimal successor metadata constructed for a valid pruning decision).
6. Evaluates the benefit against the ordinary baseline under **equivalent task inputs, authorization, candidate universe, budgets, and goal validation**.
7. Selects a proven beneficial reformulation for the existing planning/control owner; the **canonical owner still executes, validates effects, and decides final completion**.
8. Records typed evidence for proposed/refused/selected reformulations, proof attempts, pruning decisions, costs, benchmark outcomes, and the final owner verdict.
9. Uses **stage-correct baseline fallback** on unsupported domains, unprovable equivalence, missing owner facts or provider failure *before effects*. For revision/security changes, cancelled work and in-flight effects, obey canonical owner refusal/reconciliation rather than blindly restarting.
10. Demonstrably reduces real exploration/deliberation work on at least one **production-reachable DoubleTake workload**, including all optimizer overhead, while maintaining accepted outcomes and governance. **Prove real native use for both structural recoding and invariant-based pruning** (in one integrated path when sound, or in two independently real paths). A toy game can establish a proof technique but **does not close the mission**.

**Definition of value:** reduced *total* measured work (candidate expansions, operator/plan checks, model calls, and/or elapsed time including optimization overhead) at unchanged task correctness, authorization, and admissible solution coverage. An attractive new module, internal score, shorter proposed plan, or passing mock by itself is not value. Distinguish **correctness of the transformation** (a proof obligation), **production reachability** (a call-graph/receipt obligation), and **economic value** (a matched-measurement obligation): none implies either of the others.

### 2. Inventory existing owners before implementation (bounded reconnaissance)

Spend only enough time to identify an actual executable seam; do not turn this into open-ended archaeology. Inspect at minimum, adapting paths if moved:

| Existing surface | Why it matters | Expected integration role |
|---|---|---|
| `tools/doubletake_evolve/collective_core/capability_router.py` | Semantic candidate routing, bounded capability composition (`_find_composition`), typed `RouteResult` | **Leading candidate**: reformulate a capability-composition search without altering routing eligibility/authority |
| `tools/doubletake_evolve/collective_core/capability_semantic_ir.py` | Typed, provider-independent intent/contract matching | Reuse *already-authoritative* typed goals and constraints; do not introduce a competing semantic vocabulary |
| `tools/doubletake_evolve/collective_core/capability_execution.py` | Existing schema revalidation, governance, postconditions, receipts, bounded composed execution | Preserve execution authority; verify the selected plan runs through the same boundary |
| `tools/doubletake_evolve/cognitive_control/{goal_context.py,impasse.py,chunks.py,resolve.py,wiring.py}` | Goal-revision visibility, typed impasses, verified prepared knowledge, owner-driven resolutions | Secondary host for verified representation hints; **not** a place to create a second decision authority |
| `tools/doubletake_evolve/meta_reasoning/{stages.py,production.py,experiment.py}` | Governed assess/propose/evaluate, budgets, existing DIRECT-vs-META experiment | Optional controlled deliberation/measurement bridge; do not charge trivial tasks merely to consider reformulation |
| `tools/doubletake_evolve/collective_core/hypothesis_search.py` | Existing validation and selection of hypotheses | Possible alternative if this contains a real, countable search with stable domain equivalences |
| `tools/doubletake_evolve/frontier_discovery/{representation_invariance.py,representation_evidence.py,operators.py}` | Representation robustness / qualified relation operators | **Not** proof of planning equivalence. Reuse infrastructure only where semantics actually match |
| `tools/doubletake_evolve/enterprise/policy/*` and repository evidence/closure machinery | Enterprise controls and release evidence | Do not bypass; demonstrate no changes in authority and safe data handling |
| `pytest.ini`, CI workflows, `Makefile`, `AGENTS.md` | Current collection, verification, concurrency conventions | Ensure every added certifier is collected and every stated check is actually executable |

**Required reconnaissance output:** a compact `existing → gap → owner → production caller → proposed modification` map, with actual paths, symbols and call sites. Verify with grep/imports/tests. If the target is already implemented *with passing production evidence*, do not duplicate it; change scope to its measured missing piece. Do **not** stop at an architecture report unless there is a documented hard blocker.

**Preferred first owner:** a real bounded compositional planner inside the capability-routing path, *if* that planner exposes enumerable candidate expansions and sound independence/constraint facts. Do not force that choice merely because its name looks right. When the safe owner is another real solver, select it and explain why. A host that only re-ranks or retrieves candidates without real search is **not** sufficient for the search-reduction claim. **Before designing code, inspect the real call graph of `_find_composition` (if still present), its fixed depth/branching and actual source of candidate options**: an already-small or schema-constrained search may leave no meaningful exploitable redundancy. If so, choose a different proven owner; do not manufacture a costly baseline.

### 3. Semantics: distinguish equivalence, sound refinement, and heuristic approximation

A reformulation is not simply a rewording. Define these terms as typed states and enforce them:

- **`PROVEN_EQUIVALENT`**: for the supported, explicitly bounded domain, an established bidirectional state/action/goal correspondence preserves all applicable constraints and the requested observable outcomes; any proposed concrete solution can be decoded and validated, and all legitimate solution classes remain representable to the extent promised by the certificate.
- **`PROVEN_SOUND_REFINEMENT`**: every decoded result of the transformed search is a valid result under the canonical problem, but the transformed search may intentionally omit some canonical solutions. This status is usable **only** where the owner can prove omission is legitimate (e.g. removes symmetrical solutions, provably dominated alternatives, or impossible states) and the task requires *one* admissible solution, not enumeration of all solutions or an exact optimum without an admissible bound.
- **`HEURISTIC_ONLY`**: potentially useful representation or hint without proof. May inform proposals or ranking under ordinary existing controls, but **must never** justify hard pruning, authority changes, proof of equivalence, or exclusion of legally/semantically viable options.
- **`UNSUPPORTED`, `UNPROVABLE`, `STALE`, `BUDGET_EXCEEDED`, `REFUSED_POLICY`**: distinct fail/skip states, recorded without treating them as success.

**Do not equate output-schema similarity, token overlap, embedding cosine similarity, same goal text, same model answer, or validation on a few examples with semantic equivalence.** Where general equivalence is undecidable or expensive, the *only* eligible automated transformations are those supported by an explicit, narrow rule/certificate. In all other cases decline optimization and proceed with the baseline.

**Optimality condition:** If original search promises minimum cost/best score, preserving feasibility alone is insufficient. Either prove optimal-cost/order preservation, give an admissible bound with the canonical owner's validation, or leave this transformation disabled for that mode.

**Explicit proof obligations (must be represented in machine-checked rule contracts):**

1. **Eligibility and identity:** original and transformed views bind the same authorized task, revision, environment snapshot, security scope, operator inventory and user-visible obligation set.
2. **Initial/goal preservation:** transformed initial conditions correspond to the canonical initial state, and transformed goal acceptance implies the canonical goal under the chosen equivalence/refinement mode. For full equivalence, prove the reverse coverage obligation too.
3. **Transition and trace preservation:** a certified encoder maps each admitted original step/plan to the claimed transformed step/plan, and a decoder reconstructs only legal canonical actions. Preserve state-dependent preconditions, bindings, observable output, **externally visible effect order**, error/timeout behavior, and mandatory receipts wherever these are part of the task semantics. Equivalence of terminal return values alone is insufficient for effectful tasks.
4. **Search coverage:** show what the transform preserves—one valid witness, every distinct solution, every observable outcome, or the optimum. A quotient may collapse only certified-indistinguishable states under the requested coverage. For one-witness tasks, prove that pruning cannot remove **all** valid witnesses.
5. **Objective preservation:** when required, preserve objective/cost ordering, incumbent bounds and tie/ordering policy. Do not infer nonnegative costs, commutativity, monotonicity or independence from names.
6. **Verification scope:** distinguish finite exhaustive proof, structural/inductive algebraic proof and runtime checked preconditions. Finite exhaustive tests prove only the enumerated bound; arbitrary empirical test success is not a general certificate. Every proof carries its exact domain, assumptions, certificate issuer, verifier implementation version and revocation inputs.

**Trusted verifier separation:** Candidate generation may be model-assisted, but certification must run through an **independent deterministic verifier or already-trusted proof backend** against canonical owner facts. A proposer cannot provide a Boolean `verified=true`, supply its own verifier implementation in the same untrusted payload, or cite its own explanation as evidence. If proof assumptions cannot be re-derived from current owner contracts, reject hard pruning.

### 4. One minimal, typed representation (adapt existing contracts)

Do not duplicate `MetaTaskView`, semantic-intent IR, `GoalFrame`, capability contracts, or owner receipts. Build a compact adapter/view across them. Field names below are **conceptual**, not mandates to create redundant classes:

```text
CanonicalProblemView
  problem_id; run_id; owner_id; task_id; task_revision
  repository/tenant/security_scope_digest; authorization_context_ref
  representation_id; domain_id; capability/contract/inventory digests
  initial_state_ref + state_projection; goal_predicate_ref; required_outputs
  operator_ids + preconditions/effects/ordering/resource constraints
  hard constraints; optimization objective; observable semantics
  allowed_budgets; evidence_refs; schema_version

ReformulationProposal
  original_view_digest; candidate_representation_id; transformation_rule_id
  forward_encoder_ref; reverse_decoder_ref; operator_correspondence_ref
  preserved_constraints; proposed_invariants; owner_scope/revision
  deterministic candidate_digest; provenance; estimated overhead

VerificationCertificate
  rule/version + source/target digests; proof_scope; proof_method
  properties/proof obligations; passed/refused obligations
  exhaustiveness claim (bounded only); admissibility/optimality coverage
  counterexamples, or verification_receipt_refs; verifier_version
  verified_at; expiration/invalidation inputs; immutable digest
  independent_verifier_id/version; assumptions_digest; proof_obligation_ids
  transition/trace/output coverage; witness_reconstruction_test_ref

PruningDecision
  state/operator/candidate identity; invariant_id; proof_ref
  precisely which owner fact excludes it; proof-scope/rejection reason
  independently observed expansion/check counts before and after
  domain/revision/scope binding; retained search completeness conditions

ReformulationSelection
  selected/refused/skipped; original and replacement representation refs
  verified mode; estimated/measured costs; restored fallback capability
  task/authority/security preflight refs; owner handoff; decision digest
```

Use canonical digest routines and validated schemas already used in DoubleTake. Read-only proposal/certificate objects must not be able to mutate task identity or authority. No execution from serialized or reconstructed model text. Bound all lists, depths, serialized sizes and time/cost dimensions. Reject unknown schema/version claims. Prevent cross-task, cross-run, cross-tenant, or cross-security-scope certificate reuse. Bind caches to operator versions, task revisions, rule versions, relevant policy and capability contract digests. Reject tampered/stale records and purge/quarantine only through existing governed storage conventions.

### 5. Candidate representation generation — real transformations only

Implement an **extensible but initially small rule registry** (prefer existing capability/contract infrastructure) with two independent, non-fictional transformation families **on verified production-reachable domains**. You may use separate real native domains if their proof systems genuinely differ. **Do not substitute a toy game, model-proposed synonym change, retrieval rerank or an invented planner for either family.** If only one is soundly possible, implement it without misrepresenting the second as complete and report `PARTIAL` with a concrete blocker:

**A. Structural recoding / problem isomorphism**

- A trusted operator rule maps the current problem into an alternate, lower-cost state space and supplies a verifiable decoder.
- Illustrative source case (not a required application domain): the excerpt's number game recoded as tic-tac-toe. This illustrates that two superficially different tasks can have a shared winning structure; it does **not** imply arbitrary business tasks can be equated by an LLM.
- In DoubleTake, target typed domains where states, permitted actions, and goal tests are observable and known; reuse existing goal and operator contracts.
- Verify initial state, legal transitions, outcomes/goal predicates, safety constraints, and any required cost ordering for the chosen domain. A formal finite isomorphism or a domain-proven algebraic equivalence is eligible. A model-crafted mapping without a proof is not.

**B. Partial-order / symmetry / invariant quotienting**

- Collapse only transformations that preserve task semantics, e.g. proven commuting operations with independent effects, canonical representatives of true symmetry classes, unreachable states, impossible goal branches, constraint-implied impossibilities, or provably dominated variants.
- **Never infer commutativity from names alone.** Composition with external side effects, locking, exclusive resources, destructive writes, permission checks, deadlines, receipts or output-binding dependencies is generally order-sensitive. Require owner-certified read/write/effect independence or an explicit trusted rule.
- Keep exact argument binding, dependency edges, capability eligibility, input/output schema compatibility, user constraints, authority, provenance, and required ordering. A reduction that simply drops low-ranked candidates is **not** an invariant-based proof.
- Record canonical-state identities and collision handling; retain a reversible/decodable witness when collapsing equivalence classes. Canonicalization must not conflate distinct permission contexts, resource ownership, failure histories, operator effects, deadlines, output order or scope identities. If hashes are used, validate canonical encodings and compare necessary semantic fields on collision; a digest alone is not evidence of equality.
- **Do not overgeneralize pure read/write independence to external effects.** A read-only *planning* simulation may commute when its typed operator semantics prove it, but real executor actions must preserve the original authorization, audit, ordering and idempotence obligations.

**Candidate source policy:** Start with deterministic trusted transformations over typed owner facts. Optional LLM-assisted suggestions are untrusted *proposals* and must be run via current governed inference controls, metered, bounded, schema-validated, verified independently, and rejected if the provider is unavailable. No prompt self-certifies its output.

### 6. Mandatory invariant-guided pruning

Implement a sound `prune_if_proven`-style hook **before costly expansion/check/dispatch in the chosen owner's actual search path**. It must consume explicit, certified invariant rules, never vague relevance heuristics. It is acceptable to construct a minimal successor key needed to decide whether to prune; it is **not** acceptable to generate and check the full branch and then count it as saved work. Instrument both cases so timing and counts cannot be laundered:

1. **Reachability / feasibility**: state cannot satisfy necessary preconditions or a preserved goal invariant; requires a sound domain reason.
2. **Resource, ordering, and dependency**: operation cannot satisfy canonical constraint/resource graph; must agree with current owner authorization and execution rules.
3. **Symmetry / canonicalization**: two states/partial plans provably equivalent under a certified correspondence; keep one witness.
4. **Dominance** (where objective permits): candidate cannot improve on a verified incumbent; the dominance relation and bound must be valid for the stated objective.
5. **Impossible / contradictory goal conditions**: only from trusted typed constraints or a verified domain rule; ambiguous natural language is not a hard invariant.

**Rejection logic must be monotonic with respect to authority**: a reformulation can remove work only when proven safe; it cannot add an eligible capability, widen required effects, weaken the policy preflight, or transform denied execution into allowed execution.

**Fallback is stage-dependent, not a blind retry:**
- **Before the first owner effect:** discard the entire optimized planning frontier, invalidate stale proofs, and restart planning from the *canonical initial view* under the remaining real budget. Do not resume from a partially pruned frontier.
- **After any effect is reserved, started or may have committed:** never restart the task or replay already issued operations as a fallback. Hand off to the existing canonical effect/reconciliation owner, preserve durable receipts and idempotency keys, and report an **existing canonical partial/unknown-effect status** (for example `PARTIAL_EFFECT` / `OUTCOME_UNKNOWN` only if these are accepted vocabulary values) where the owner cannot establish terminal truth. Continue only through owner-authorized recovery, not optimizer-issued compensation.
- A fallback cannot bypass a hard security refusal, cancelled task, expired deadline or unavailable canonical identity. A refusal is not an excuse to re-run through a less strict path.

**Replanning boundary:** no alternative plan may be applied to a task revision or environment generation that changed during its proof. Recheck immediately before dispatch and on each owner-authorized replan. Stale proof means no effects from that proof.

Track `candidates_generated`, `expanded`, `checked`, `hard_pruned_by_proof`, `skipped_by_heuristic`, `unique_equivalence_classes`, `proof_failures`, `reconstruction_failures`, and `owner_final_validations`, with exact definitions and where each number is collected.

### 7. Integration: one authority and one real production path

Find a **production caller** that naturally constructs a bounded problem/plan and already carries owner identity, constraints, and approvals. Insert the smallest bridge:

```text
canonical task / current owner
  -> current semantic/capability/governance eligibility (unchanged)
  -> decide whether a search optimization is appropriate (cheap deterministic check)
  -> capture canonical typed problem view
  -> generate trusted candidate reformulations (bounded)
  -> prove equivalence or permitted sound refinement (no proof => no hard prune)
  -> search with certified invariant pruning, using the owner's existing planner
  -> decode to canonical plan/operator identities
  -> canonical owner revalidates contracts, budget, authority and current revision
  -> canonical execution boundary and postcondition verification (unchanged)
  -> durable decision/proof/effect-receipt/benefit evidence
  -> reverify source and contract binding before claiming promotion
```

Actual ordering may differ by owner: do not run eligibility or security checks *after* a transformation that might silently delete their inputs. Never bypass existing semantic admission guards, verified chunk reuse gates, or meta-control activation policy. No new API ingress if the existing one already serves the task. No start-up scan of the whole capability registry or history when the user did not ask for a hard problem. Preserve direct/cheap path performance.

**Non-vacuity requirement:** Show end-to-end production-reachable integration tests starting at normal DoubleTake task/intent entry, traversing **both family A and family B**, reaching the new proof/pruning branches where applicable, handing decoded canonical plans to the existing owner, and receiving its ordinary canonical execution/validation receipt. One shared real path can cover both families if applicable; otherwise show separate native paths. The test must use actual canonical authority and receipt code, with isolated/test-safe operators where real external effects would be hazardous. Unit calls directly into the new optimizer or synthetic-only harnesses do not qualify. Also show a real task that *does not* activate the optimizer, remaining unchanged.

**Activation is automatic when proved beneficial:** For an eligible supported task, the production owner should automatically consider the verified feature without users knowing rule names or setting bespoke prompts. A static disabled flag is acceptable during validation; **after all promotion gates pass, enable it only for the certified, beneficial domain scope** using the existing configuration/governance path. Unsupported or insufficiently proved domains remain baseline. Provide an explicit disable/rollback switch; do not silently ship a permanently unused feature.

### 8. Boundedness, cancellation, failure, and multi-agent operation

- Give this feature a finite exploration budget (candidate count, maximal depth/edges, CPU/wall-clock duration, memory, optional inference use and ledger storage). Never run an unbounded “try representations until good” loop.
- If activation overhead exceeds its allowance, skip it and run the baseline path; never burn more work than the claimed saving by silently hiding generation/proof cost. **Expected benefit estimates must derive from pre-existing measurements or explicit deterministic bounds**, not a constant supplied by the proposing model. A cheap deterministic applicability check can reject low-opportunity tasks before proof attempts.
- Honor the enclosing task's cancellation, pause, deadline, revision changes, process restart and version migration semantics. The reformulator has no independent ability to create or restart execution attempts.
- Persist certificates/receipts through existing canonical storage and tamper-evident mechanisms where durable state is necessary; never introduce a second competing run-state root. Cache only sufficiently scoped, verified immutable decisions; use atomic writes and concurrency-safe idempotence. Do not execute a task twice after restart or issue effects speculatively during representation search.
- **Persistence and reuse must not cross trust boundaries:** include effective policy digest, transformation/verifier versions, task revision, capability/provider inventories when semantically relevant, security classification and execution context in invalidation checks. Record an explicit cache `HIT_VALIDATED`, `MISS`, `STALE` or `REFUSED` state; count cache verification cost. Do not cache secrets, unredacted prompts, cross-tenant plans, or a proof whose assumptions depend on non-reconstructable ephemeral facts.
- Bind all proposed operations to current canonical executor authority; unknown owner or missing identity should yield `UNAVAILABLE`/baseline, not a fabricated owner or unauthorized work.
- Multiple agent processes/machines: identical input/rule/scope should lead to stable proposal identities. Competing writes cannot promote unverified records; honor existing coordination and fencing. Security-sensitive facts must not leak into a lower-scoped agent's candidate data or logs.
- Handle partial planning, malformed proposals, broken decoders, failed goals, policy disagreement, missing proof backend, corrupted cache, stale contracts, missing model provider and exhausted budgets explicitly. No `except Exception: pass` that conceals a safety-critical fault or creates fake success.

### 9. Test and falsification matrix (not only happy-path tests)

Implement tests in the actual collected package(s). Tests should be deterministic and offline wherever possible. **Write failing tests first when modifying an existing real search algorithm.** At least:

**Formal domain/representation validity**

- Two non-identical representations of one supported finite task, with explicit mappings and verified state/action/goal preservation.
- Forward/backward mapping round trips for every reachable state in a small exhaustive domain; admissibility and terminal-state preservation, including counterexamples if the mapping is altered.
- Parameterized transformations over a larger domain where proof validity follows from a trusted algebraic rule; no pretending exhaustive small-scale checks prove an unbounded domain.
- Exact-goal, optional-goal, all-solutions and optimal-cost modes: recognize when a sound but non-complete refinement cannot be used.
- Negative examples: same-looking prose but different goal, shifted contract, side-effectful noncommuting actions, asymmetric resource constraints, stale version, wrong security scope, altered operator semantics, adversarial LLM proposal, incomplete decoder.

**Invariant pruning**

- Exhaustively compare baseline reachable solutions with optimized reachable/decoded solutions on small finite supported tasks; require strict result preservation per chosen equivalence/refinement status.
- Deliberately wrong invariant must produce a checked refusal/counterexample, **not** a fast green run.
- Symmetry canonicalization must preserve distinct outputs when the caller requests enumeration or output ordering.
- Dependency conflict, time-sensitive/precondition-sensitive operations, exclusive resources, negative constraints, and permission changes must not be reordered/pruned.
- Prune **at candidate generation/search time**, not merely suppress output of an already-enumerated frontier; assert instrumented owner expansion counts.

**Actual production and security**

- Normal canonical entry to bounded search to verified transformation to real owner execution and receipt.
- Ordinary cheap task, unsupported domain and missing proof: no extra provider call; same behavior/receipt validity as before.
- Goal/task revision, owner stop, cancellation, deadline, stale capability inventory, scope change: reject old proof, do not issue new effects; fallback/reconcile through canonical owner.
- Tampered certificate, cached proof from other run/tenant/security scope, unauthorized proposed operation: refused.
- Crash/restart after search but before effect, and after effect but before receipt reconciliation: no double execution; evidence accurately indicates uncertainty if necessary. Attempt identifiers, fences and receipts are issued by the **existing** owner; optimized planner has no side-effect idempotency authority.
- Inject cancellation and scope changes **between** proof, decode, final revalidation and owner effect reservation; no stale transformation may commit.
- Bounded stress across concurrent workers, duplicate certificate proposals and reordered evidence writes; no cross-scope leakage, lost proof revocation, or duplicate owner effects.
- Existing capability-selection, cognitive-control, meta-reasoning, inference, enterprise-security, and L0 boundary tests still pass on the relevant affected surfaces.

**Non-vacuity sabotage tests**

- Switch off the reformulation entrypoint: the end-to-end proof MUST fail.
- Break the decoder: the transformed plan MUST be rejected.
- Swap in an unsafe equivalence/invariant: the verifier MUST refuse and/or find a counterexample.
- Disable pruning while preserving records: the “search-reduction” proof MUST fail (a record alone is not savings).
- Bypass the canonical executor/governance: the test MUST fail.
- Stale/alter the source file(s) or recorded proof root: evidence verification MUST fail when rerun.

### 10. Real matched measurements and promotion gates

Build a repeatable **baseline vs optimized** experiment using the same native task inputs and *the actual owner path*. Follow the honesty principles already implemented in `meta_reasoning/experiment.py` where reusable, but do not fake an identical experiment if the semantics differ.

Predeclare a representative case set **before choosing/tuning transformations**: easy cases (activation off), moderately difficult cases, candidate-rich composition/search cases, conflict/negative controls, and real task families with an admissible transformation. Partition cases into **development** (diagnose and tune) and **held-out validation** (one-time final claim); group correlated cases by task family or provenance to prevent leakage. Preserve task/contract/authority revisions, allowed operators, environmental snapshots, provider configuration, caching policy, stop conditions, deadlines, and repeat seeds across arms. Distinguish measured costs from estimates/unknowns. Include the overhead of candidate construction, proof, decoding, storage, revalidation and fallback. Run **cold-cache and warm-cache comparisons separately**, never giving only one arm a warmed result. Use safe deterministic/recorded execution where real mutations would be unsafe, while keeping actual native routing, governance and receipt machinery.

**Choose and freeze success thresholds before held-out evaluation.** State: primary cost metric and exact instrumentation; required search-work reduction on eligible cases; maximum tolerable extra wall time, model spend and cheap-task overhead; minimum sample/repeat counts appropriate to deterministic or stochastic work; correctness/coverage constraints; and the rule for excluding an unmeasurable comparison. Do not tune thresholds or select showcase tasks *after* inspecting held-out results. If the first held-out comparison fails, mark it failed, revise only using the development set and retest on a fresh held-out set with provenance of the revision. Never state a percentage unsupported by actual measurements.

Report for every case:

- baseline/optimized final owner outcome and canonical deliverable identity (or valid semantic equivalence witness);
- explored/expanded states, candidates rejected by proof, validity checks, actual owner dispatches/effects;
- solver steps, full model calls/tokens if known, provider wall time if known, optimization overhead, total wall time if measured, peak memory if measured;
- cache state, successful/failed proof count, verification and revalidation cost, reason for skipped/failed candidates;
- comparison with baseline, confidence/repeatability information when meaningful, cases where optimization was worse, and any unmeasured dimensions explicitly `UNAVAILABLE` rather than zero.

**Promotion gates (all mandatory):**

1. **Correctness:** all transformed outputs satisfy the canonical owner's task, policy and postconditions; no validated counterexample to claimed equivalence/refinement remains.
2. **Security:** no bypass or degradation of authorization, tenant data isolation, receipt integrity, evidence provenance, resource accounting, or enterprise policies.
3. **Proven reduction:** both transformation families reach real owner search (one shared or two genuine domains); at least one real production-reachable eligible workload shows a reproducible decrease in **actual owner** expansions/checks or another predeclared meaningful search-work measure, with net overhead reported. A pruning counter without fewer real expansions does not count. A single cherry-picked benchmark is insufficient for promotion.
4. **Net cost:** the predeclared held-out eligible workload set meets its **frozen quantitative acceptance rule** in at least one measured end-to-end resource dimension (including optimization overhead), while meeting its other predeclared regression guardrails; show repeatability, outliers, unchanged/negative cases, and cold/warm cache strata. If measurements are insufficient, status is `NOT_PROVEN`, not inferred success. Do not claim 10/10 or any percent without observed data.
5. **Default safety:** the extra feature is absent or negligible for ineligible cheap tasks, and a disabled-feature baseline remains available.
6. **Reachability:** normal task ingress triggers and completes the integration, evidenced by traced, collected tests and ordinary owner receipts.
7. **Maintenance:** no duplicate owner/runtime or broad unneeded scaffolding; current test suite and source/evidence bind checks are collectable and pass.

If any gate cannot be proven, finish honest code/evidence and report `NOT_PROVEN`, `PARTIAL` or `BLOCKED` with exact missing artifacts. **Do not promote a speculative optimization as a completed improvement.** A correct, disabled, explicitly unpromoted path is preferable to claiming an unsafe success.

### 11. Implementation phases — execute, do not merely describe

**Phase A — Reality check and falsifiable plan (short):** inspect current `main`, trace production search, list existing equivalence/invariant features and gaps, determine eligible owner, record a *minimal set of files*. Set acceptance probes for baseline correctness and baseline search work. Refuse needless parallel copies.

**Phase B — Native contracts:** add the smallest problem-view/proposal/proof/pruning/selection representation in a suitable existing package; scoped digests, strict enums, bounded schemas, nonforgeable provenance, stale handling.

**Phase C — Verified transformations:** add one meaningful executable structural recoding **and** one meaningful certified invariant/quotient rule on actual production-reachable domains (either one host or two). A rule not supportable by the available owner semantics must not be invented merely to satisfy the checklist; record it as the exact missing requirement and keep overall closure `PARTIAL`. Never invent an artificial general-purpose equivalence checker.

**Phase D — True early pruning:** instrument the actual search frontier, prove and prune impossible/equivalent states/operations *before* expensive expansion, record decisions and witnesses, preserve execution order where effects matter.

**Phase E — Production bridge:** integrate with actual existing owner at the correct point; feature is off for cheap/unsupported paths, calls canonical execution, is fenced by authorization and task revision, and writes auditable outcome records.

**Phase F — Adversarial verification:** property tests, finite exhaustive equivalence tests, scope/revision tests, sabotage proofs, real entrypoint acceptance; confirm tests are collected with normal project invocation.

**Phase G — Real benchmark:** run predeclared, held-out matched baseline-vs-optimized tasks, including cold/warm strata; optimize real bottlenecks only on development cases while retaining every proof. If there is no net benefit, diagnose on development evidence and rerun on fresh held-out tasks if any are available; otherwise leave disabled with `NOT_PROVEN` rather than declare success. Never repeatedly retest the same holdout until a favorable result appears.

**Phase H — Closure:** rerun the relevant full suites and governance/security gates, regenerate only correctly source-bound evidence, audit code, produce final report. Do not claim current E17/security release closure if a separate workstream owns it.

At every phase, **first check whether the capability already exists**, then modify only a demonstrated missing part. Keep iterating while an observed correctness, reachability, security, or demonstrated-value gap remains and an actionable bounded fix exists. Stop when all gates pass, or when the remaining obstacle is proven external/unfixable within this mission. Never loop merely to reach an arbitrary score.

### 12. Required deliverables in the repository

1. **Production source changes:** typed and governed native feature, **both transformation families**, actual owner search integration, decoder, certified invariants, stage-correct fallback; no dead entrypoints.
2. **Focused tests:** path-by-path unit, property, adversarial, sabotage, concurrency and native-entry E2E tests, actually collected by the project's test invocation.
3. **Measurements:** durable machine-readable matched comparison package with configuration, source bindings, cost counters, outcomes and negative cases. A concise human-readable summary may point to it.
4. **Proof/certifier:** an executable command that recomputes source/contract/evidence binding and refuses tampering, stale HEAD-measured content or uncollected test scope. Include independent coverage for both families, path-specific refusal and negative controls. Use existing evidence machinery rather than inventing a competing release certifier; if no exact existing package applies, add a small focused certifier. Source binding must measure the **complete imported dependency surface** used by the proof and target, not only the top-level test file. A change after proof generation must invalidate a closure claim until regenerated against current code.
5. **Operational control:** a documented safe default/enable/disable mechanism appropriate to existing DoubleTake settings; no always-on model calls. Explain when the feature activates and why. After full promotion, ensure it is actually **reachable and automatically enabled for the certified eligible scope**; before full promotion it remains gated off. Include an operator-safe disable switch and observe-only evidence mode if already supported.
6. **Final handoff:** actual changes, test commands and results, recorded before/after costs, proof-scope limitations, active vs gated-off status, evidence paths, canonical owner integration path, and any unresolved blockers.

Avoid an additional standalone strategy guide or redesign document in lieu of source changes. Keep documentation only where needed to operate, review and verify the completed mechanism.

### 13. Final report format (mandatory; no placeholders)

```text
DOUBLETAKE PROBLEM-SPACE REFORMULATION — FINAL EXECUTION REPORT

Starting main SHA:
Ending main SHA (or uncommitted diff declaration):
Current git worktree / concurrency status:

Existing feature inventory (reused vs extended):
Owner and production entrypoint (actual symbols):
Files changed (with reason):
Formal transformation domain(s) and exact proof scope:
Family A structural recoding: actual caller | transform | independent proof | native receipt
Family B invariant quotient/pruning: actual caller | invariant | early prune | native receipt
Equivalence/refinement certificate rules and refusal cases:
Invariant classes applied and exact pruning point:
Canonical executor/governance path preserved:

Verification:
  Focused tests: command | collected | passed | failed
  Production E2E: command | real receipt/evidence
  Finite exhaustive/property tests: command | verified scope
  Sabotage tests: command | expected refusal/failure observed
  Adjacent regression/security tests: command | results
  Source binding/certifier command | result

Matched performance:
  Baseline and optimized cases, per-case outcomes, work counters and total cost
  Cache/worker/provider/authority parity
  Measurements unavailable and why
  Counterexamples / cases without benefit
  Held-out sample provenance; predeclared thresholds; cold/warm separation
  Real owner expansions saved vs optimization proof/decoding overhead

Promotion gates 1–7: PASS / FAIL / NOT_PROVEN with evidence
Decision: IMPLEMENTED_AND_PROVEN | IMPLEMENTED_NOT_PROMOTED | PARTIAL | BLOCKED
Remaining issues (only real, actionable items):
```

### 14. Stop conditions and prohibitions

- **Success:** all seven promotion gates pass, **both transformation families have native production reachability and sound proofs**, measurable net value exists on the predeclared real workload set, and the full trace ends in canonical governed execution with honest evidence. Stop; do not keep broadening scope.
- **Correct partial completion:** underlying correct code exists, but one family is absent, no real proven net benefit is established, only synthetic proof exists, or equivalence is missing; leave unproved domains gated off, report `PARTIAL` or `IMPLEMENTED_NOT_PROMOTED` with a per-family status, and stop instead of changing definitions of done.
- **Block:** no actual search/planning owner permits a sound non-trivial reformulation, or unsafe ambiguity cannot be resolved from available facts. Report the concrete blocker, not fictional source changes.
- Never weaken enterprise/CI constraints, relax safety gates to pass tests, omit optimization overhead, edit historical results, silently reinterpret heuristic matches as proofs, fabricate citations or completed tests, or claim an irreversible action has been undone when it has not.

## Execute now

Start from **live `main`**. Identify genuine searchable owner(s), inspect actual tests and callers, implement **both** the smallest sound structural reformulation **and** certified early invariant-pruning mechanism, connect them to canonical execution, run independent proofs, failure-injection tests and predeclared matched held-out measurements, then produce the final report. **The deliverable is a working, measured native DoubleTake upgrade—not a proposal.** If reality prevents either mechanism, report that precise blocker and do not claim full closure.
