# MAIN — Agent_X Harvest Remaining Work Executor

## Purpose

This is a correction/integration pack, not a rebuild. It assumes the implementation wave audited at `874bbe4268aca0539cbf8476f62444d704f2d555` already exists.

Read first:
1. `CURRENT_STATE_AUDIT.md`
2. `DONOR_MODULE_DISPOSITION_MATRIX.md`

Then run Tasks 01–11 in order.

## Core migration loop

```text
donor idea/code
  -> identify real canonical owner
  -> proposed semantic delta
  -> migrate/merge into owner
  -> wire real production caller/UI/state
  -> rewrite tests against production path
  -> delete/deactivate redundant donor
  -> verify semantic/source/runtime reconciliation
```

Do not solve a parallel-stack problem by adding a third adapter stack.

## First commands

```bash
git status --short
git branch --show-current
git rev-parse HEAD
git log -1 --oneline
```

Revalidate paths because main may have advanced beyond `874bbe4268aca0539cbf8476f62444d704f2d555`.

## Order

1. `01_revalidate_and_disposition.md`
2. `02_gate_b_contract_integration.md`
3. `03_semantic_embedding_grounding.md`
4. `04_generation_scheduler_integration.md`
5. `05_evaluation_promotion_integration.md`
6. `06_persistence_migration_recovery.md`
7. `07_real_api_ui_inventory.md`
8. `08_benchmark_holdout.md`
9. `09_strict_e2e_ci.md`
10. [Canonical historical Task 10 — parallel-stack cleanup](DISTILLED_KNOWLEDGE.md#d01-canonical-closure-harvest-cleanup-and-final-audit-2026-11-01)
11. [Canonical historical Task 11 — final hard-gate audit](DISTILLED_KNOWLEDGE.md#d01-canonical-closure-harvest-cleanup-and-final-audit-2026-11-01)

## New-file gate

A new source file is permitted only if: existing owner cannot absorb without harming cohesion; responsibility is distinct; a real production caller is wired now; authoritative state/lifecycle/recovery are explicit; tests exercise the caller; and the old/donor path being replaced is named. Otherwise modify the existing owner.

## Definition of done

The repository must not merely contain the Harvest design; the real system must operate through it: real UI/API semantic inventory search, canonical Gate B before code, canonical semantic services, canonical scheduler/evidence flow, canonical promotion/R0-R6/canary/rollback, persistent restart-safe state, strict production E2E, donor cleanup, and holdout-based search-policy qualification. If the new search policy does not beat the incumbent, retaining the incumbent is the correct evidence-based result.
