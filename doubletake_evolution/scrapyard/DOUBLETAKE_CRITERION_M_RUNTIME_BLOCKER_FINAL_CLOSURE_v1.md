# Criterion M — historical native structured-output blocker and acceptance contract

**Provenance:** Distilled in place from 2026-10-05 runtime-blocker mission v1 (original Git blob `f3ff218055dce37ce746811e9419ba4f7874ba10`; recover complete operator text through Git history). Historical DT main at authorship: `ccbe14e1b47a6c298ab60f45a638c754bed8d0e6`. This document is **historical evidence, not a current runtime verdict or an instruction to execute**. Claims of implemented features, M OPEN, G PASS and test results require fresh verification.

## Reported baseline and failure
- Historical convergence owner: `tools/doubletake_evolve/tests/test_capability_participation_convergence_table.py`; negative M property: `tools/doubletake_evolve/collective_core/test_capability_nameless_reach.py`; live artifact: `reports/capability_semantic_live/evidence.json`.
- Historical verdict `STRUCTURED_REQUEST_REFUSED`: active OpenCode runtime raised `InvalidRequestError: Missing key ["text"]` for the native semantic request containing model/tools/format/system/parts; no usable native JSON-schema output on that path. Semantic evidence was therefore inadmissible, deterministic fallback applied, and M remained OPEN. This was a runtime-side hypothesis, not proof about today's runtime.
- At authorship the non-vacuity mechanism reportedly recorded 13/13; the number is not a current acceptance target.

## Reported DT-side architecture (retest, do not assume current)
1. Governed `effects["semantic_profile"]`: typed validation, digest binding, migrations/reconciliation, de-identified vocabulary; legacy lexical isolation.
2. Closed typed Semantic Intent IR: resolved/partial/unresolved, canonical atom IDs, strict validation, no capability ID/name/expected target in first compiler call, no chain-of-thought dependence.
3. Deterministic structural operation/subject/property/output matcher; no name lookup, floating threshold, provider-dependent routing or weakened G coincidence gate.
4. Deferred nameless task-begin participation: pending round, no premature execution, same-round finalization, deterministic fallback; explicit-name fast path uses zero LLM calls.
5. Provider-free `CapabilityRouter` and `rank_candidates`; semantic evidence may bypass only lexical relevance failure, never permission, binding, conflict, composition or safety authority.
6. Same already-active OpenCode provider/model/variant; fresh isolated semantic session, no main-chat history, ordinary tools denied, served-model provenance, session cleanup; no auxiliary LLM/embedding provider or server acquisition.
7. Governed live proof: held-out and fresh held-out M rows, G coincidence and unrelated negative controls, source/profile/vocabulary digests, transport verdict, evidence verifier and non-vacuity.

## Hard security and negative controls
- Native runtime-enforced schema-constrained structured object required. Free-form JSON, markdown fence stripping, substring/regex parsing, retry-until-valid, or post-hoc schema checking of prose are **not** equivalent. A different native endpoint is acceptable only if the same authority and output guarantees hold.
- No second model/provider, SentenceTransformer, MiniLM/BGE/E5, remote embedding API, model switching, or new server to make the benchmark pass.
- No lowering lexical/coincidence gates, single-atom admission, hand-written synonyms, capability aliases, expected-answer leakage, or probe-specific vocabulary.
- First compiler call sees only current request, de-identified vocabulary and compiler protocol; model supplies semantic evidence, not final capability selection. DT retains routing, admission, safety, conflicts, binding, composition, permissions and execution.
- Preserve Criterion N history isolation; same permitted semantic input for the same request/vocabulary. Zero calls on explicit-name path, one normal nameless compilation, at most two for genuine ambiguity; no best-of-N or repeated sampling.
- Refusal/unavailability must produce no admitted semantic evidence, safe deterministic revalidation, no crash, no auxiliary model, and intact G controls.

## Falsifiable current verification contract
1. Re-read current DT source, convergence row, active OpenCode API and live evidence before asserting a blocker or implementation completeness. Historical relevant surfaces: `tools/doubletake_evolve/providers/opencode_provider.py`, `runtime/capability_semantic_bridge.py`, `runtime/capability_semantic_live_proof.py`, `runtime/test_capability_semantic_live_proof.py` under `tools/doubletake_evolve/`.
2. Probe the actual active service and selected providerID/modelID/variant, not a newly launched server. Check native schema reaches runtime, tools denied, wrong-model and missing-structured results rejected, prose rejected, session retired, main history untouched.
3. If refused, keep M OPEN with dated `STRUCTURED_REQUEST_REFUSED` evidence; no transport-only PASS. If supported, execute real governed M proof against current inventory and profiles, with held-out/fresh held-out cases, no fixture answer leakage and actual route/execution results.
4. **M positive property:** zero valid capability losses caused solely by removing internal capability names (not merely percentage improvement). G coincidence/unrelated controls must remain refused; N isolation, provider authority, zero auxiliary models and semantic call budget must hold.
5. Regenerate `reports/capability_semantic_live/evidence.json` from execution, not by hand. Bind source surface, fixture/profile/vocabulary digests, IR schema version and exact served provider/model. Verifier rejects stale or forged aggregates, missing rows, wrong model, G regression, auxiliary model or excess calls.
6. Non-vacuity: all intended mutations FIRED; BLIND=0 and NOOP=0, with current suite count re-derived. Structured transport alone never closes M; a model unable to compile the governed population leaves M OPEN with exact failures.
7. After genuinely passing live and deterministic gates, update the convergence row/negative property and run `test_no_criterion_is_open()` without special-casing M; preserve historical refusal in Git history. Execute focused tests for nameless reach, semantic IR/matcher, bridge/live runner, convergence, provider-independent routing/wiring, interpretation confidence, profiles/migrations and no-aux-model; then repository-default broader tests, distinguishing new regressions from pre-existing failures.

## Historical change boundary and outcome classification
A changed native OpenCode API could justify a **narrow** transport-adapter/test adjustment; changing profiles, IR, router or G gates requires fresh executable defect evidence. At authorship this was an operator constraint, **not current authorization to modify private DT**.

Classify **PASS** only with current source-bound native transport, real model/compiler/route proof, zero M losses, G/N/provider controls, verified evidence, non-vacuity and broader regression results. Otherwise **OPEN** with the exact measured transport/model blocker and evidence timestamp. Do not present the old assertion “DT implementation COMPLETE” as independently established today.

**Current status:** Not evaluated in this scrapyard dissection; no DT host, private implementation, active OpenCode model or runtime Ground was checked.
