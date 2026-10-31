# Remaining Task 05 — Integrate R0-R6, Champion/Challenger, Canary, Rollback

Put evaluation and promotion into the existing reality-kernel/stabilization/promotion authority.

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

- `harvest_reality_kernel.py`
- `learning/stabilization/promotion.py`
- `promotion/promotion_gate.py`, `promotion_dispatcher.py`, `gate_decision.py`, `release_candidate.py`
- donor evaluation/champion/canary/wiring

## Required work

Map R0 structural and R1 anti-slop into pre-expensive gates; R2 independent invariant/property/adversarial/differential testing; R3 benchmark; R4 real integration; R5 current-champion comparison; R6 shadow/canary. REPLACE rewires/removes incumbent. COMPLEMENT needs proven specialization routing. Shadow has no authoritative side effects; canary is persisted, abortable, restart-safe, rollback-tested.

## Exact completion gates

One final promotion path only. Donor registry cannot declare champion. Hard invariant cannot be averaged away. Final promotion rechecks champion/baseline freshness.

## Tests / evidence

Placeholder fails R1; R4 catches integration breakage; high absolute score but worse champion fails R5; guardrail breach rolls back; restart preserves bounded canary; replacement leaves no unintended active old path.

## Cleanup / replacement

Delete or reduce donor evaluation/champion/canary modules to helpers called by canonical promotion; no independent promotion state.

## Completion record

Record starting/ending HEAD, semantic delta/reconciliation, owners changed, donor symbols consumed, donor files deleted/retained and why, production call paths, exact test commands/results, rollback point, and all failures/UNKNOWNs.
