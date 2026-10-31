# Remaining Task 03 — Use Canonical Embedding, Corpus, Retrieval, and Grounding

Make Harvest use Agent_X governed semantic embedding/index/retrieval rather than donor mini-services.

## Baseline and rules

Repository: `Astrocytech/Agent_X`  
Audited `main` when this pack was generated: `874bbe4268aca0539cbf8476f62444d704f2d555`.  
The implementation wave began after `3887efe448edd223a00f94db324786d6a47a2d3b`.

Before work, re-check current local `main` and the working tree. Never reset newer work to this baseline.

Hard rules:
1. The recently added `harvest_*.py` files are **donor code**, not presumed canonical owners.
2. Merge useful logic into the existing subsystem that already owns the responsibility unless a new owner is independently justified.
3. Do not create a second/third Harvest stack, scheduler, persistence layer, embedding route, Gate B, promotion path, or UI.
4. Semantic proposed state precedes behavior-changing code; verified semantic state follows tests/runtime reconciliation.
5. Replace/merge before add. Once donor logic is absorbed, delete/deactivate the redundant donor path.
6. Tests must exercise production paths, not only isolated donor classes.
7. Any hard gate failure or hard UNKNOWN blocks PASS.
8. UI never authorizes implementation; server-side Gate B/governance does.
9. Do not keep code because effort was spent on it; keep it only if it has a justified owner, consumer, and value.

## Primary existing targets

- canonical `semantic/embedding_route.py`, `semantic_retrieval.py`, `semantic_index.py`
- semantic execution/service integration
- `_hp_mining.py`, `_hp_evidence.py`
- donor `harvest_embedding.py`, `harvest_corpus.py`, `harvest_grounding.py`

## Required work

Use canonical provider/router and chunking/index. Bind evidence to embedding spec + corpus/index/scope. Missing scope fails closed. Ground findings in real retrieved chunks/source. Synthetic probes stay proposals. Deduplicate rediscoveries into existing logical inventory. Expose semantic inventory search through the same canonical route.

## Exact completion gates

No separate provider abstraction/index/cache. Reject dimension/nonfinite/spec/role mismatch, missing scope, incompatible index, ungrounded probe, duplicate finding. No arbitrary vector-to-text decoding.

## Tests / evidence

Prove Harvest calls the governed provider; drift invalidates incompatible cache; missing scope rejects; source provenance resolves; semantic wording retrieves known inventory item; duplicate rediscovery merges evidence.

## Cleanup / replacement

Delete donor embedding/corpus/grounding production paths once absorbed. No duplicate semantic index/cache.

## Completion record

Record starting/ending HEAD, semantic delta/reconciliation, owners changed, donor symbols consumed, donor files deleted/retained and why, production call paths, exact test commands/results, rollback point, and all failures/UNKNOWNs.
