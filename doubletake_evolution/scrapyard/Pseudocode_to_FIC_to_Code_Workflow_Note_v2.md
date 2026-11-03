# Pseudocode → EQC-FIC → bounded code — distilled workflow (2026-05-25 v2)

**Provenance:** Surgically reduced original note at this path, blob `006727a9fbdefa798a63d81386f1689fce6015b4` (16,298 Git bytes); original detailed templates, example directory tree and prose recoverable through Git history. Historical *recommended workflow*, not current DoubleTake execution instructions, an approved FIC requirement, a coding grant, or evidence of implementation. Current canonical DT owners, exact contract syntax and actual test/consumer adoption **UNKNOWN**.

## Distinct mechanism

Separate **system intent**, **whole-system behavior**, **bounded units**, **enforceable unit contracts**, **bundle consistency**, **coding-agent context**, and **independent outcome evidence**. Proposed pipeline:

`goal → whole-system pseudocode → bounded unit pseudocode → FIC per unit → validate unit DAG/interfaces → freeze approved contract → bounded implementation packet → real implementation → tests/traceability/rollback → independent review`.

The FIC is a *proposed bridge*, not an independent approval authority. Do not generate a second FIC manager/store if existing DT governance already supplies equivalent requirements. Do not implement directly from vague pseudocode or a high-level feature prompt; do not let an agent silently invent owners, interfaces, dependencies or permissions.

## Minimal sufficient unit contract

Each unit needs a stable ID, source pseudocode reference, one responsibility and explicit non-responsibilities, public interface, inputs/outputs, state owner, allowed/forbidden dependencies, preconditions/postconditions, invariants, side-effect and idempotence classification, failure/retry behavior, tests/acceptance oracle, observability/trace requirements, exact implementation boundary, rollback/checkpoint obligations, residual risks and completion evidence.

A **shared type/interface** is defined once with fields, enums, defaults, serialization, versioning and compatibility. A **unit DAG** names dependencies and provided/consumed interfaces, prevents accidental cycles/duplicate state ownership and sets implementation order. If a cycle is necessary, it requires explicit architectural justification rather than a silent exception.

Minimum viable set: system goal; whole-system pseudocode; shared types/interfaces; traceability matrix; one FIC per unit. Larger manifests, semantic lockfiles, validation packets and risk ledgers are **optional views**, not automatically new durable owners. Prefer existing DT canonical stores and schemas.

## Bundle readiness: fail closed on actual contradictions

Before coding, validate bidirectional coverage: every pseudocode unit has a FIC, every FIC references a source unit, every required behavior has one owner, each public interface/shared type has one definition, all dependencies exist and obey the DAG, tests have independent oracles, stateful units have rollback, and implementation order is coherent. Vague acceptance, duplicate owner, missing interface, forbidden dependency, unapproved cycle, missing source, untestable contract or missing rollback yields **BLOCKED** with exact cause. Historical suggested statuses: `READY_FOR_IMPLEMENTATION`, `BLOCKED_MISSING_CONTEXT`, `BLOCKED_CONFLICTING_DOCUMENTS`, `BLOCKED_UNDEFINED_INTERFACE`, `BLOCKED_UNTESTABLE_CONTRACT`, `BLOCKED_UNSAFE_DEPENDENCY`, `BLOCKED_DUPLICATED_OWNERSHIP`. A readiness label alone does not grant permission.

For an existing repository, first inspect current source, real callers, owners, interfaces, tests and compatibility constraints; `ALREADY_PRESENT/NO_CHANGE` must remain valid outcomes. A FIC conflicting with live architecture must be reconciled by authorized change control, not treated as authority to rewrite code.

## Bounded implementation handoff

One immutable, revision-bound packet per authorized unit: FIC ID/revision and pseudocode digest, relevant source excerpt, allowed existing/new paths, interfaces/shared types, dependency rules, accepted write scope/authority, positive and negative test obligations, validation commands, resource budget, allowed terminal statuses, rollback plan and evidence schema. Do **not** ship the whole project by default; do not omit obligations and silently fall back to a one-line request on retry. A packet is not permission: existing DT tool and release policy must independently allow every effect.

Suggested order where dependencies permit: shared types → pure utilities → ports → state → governance → tool mediation → trace/checkpoints → orchestration → runtime entrypoint → integration. This is a heuristic, not a mandate to rebuild existing owners.

If an approved contract proves wrong, stop affected implementation, record a narrowly scoped delta with unit ID, reason, affected dependents, requested change and existing owner approval; do not retroactively rewrite the contract to fit accidental code. Reject out-of-scope edits, unapproved interface changes, invented dependencies, weakened tests and unverified assertions of completion.

## Evidence, negative controls and acceptance

- **Traceability:** pseudocode unit ↔ FIC ↔ source files ↔ real caller ↔ tests ↔ results ↔ completion record. An implementation file must have an owning unit, and a unit must identify the actual effect and oracle; a matrix alone is not consumption.
- **Per-unit evidence:** source/test revision, files inspected/changed, exact tests and validators *actually run*, pass/fail and negative controls, deviations, unresolved risks, rollback, authorized effect and independent verifier. Historical statuses `IMPLEMENTED | NO_CHANGE | PARTIAL | BLOCKED | REJECTED` must not be inferred from prose.
- **Tests:** normal, boundary, negative, property, integration, replay, migration, performance and security as relevant; a documentation-only unit may be exempt from executable tests with explicit rationale.
- **Negative probes:** missing FIC, source mismatch, two owners of same state, duplicate type definition, undefined/forbidden dependency, unapproved cycle, stale revision, malformed packet, missing test oracle, changed write scope, zero-effect false completion, unapproved multi-unit edit, failed rollback and forged/stale result all fail readiness/acceptance without unauthorized effects.
- **Independent acceptance:** actual changed behavior at a real consumer with effect evidence, scope compliance, tests and rollback; `ACCEPTED | REJECTED_NEEDS_FIX | REJECTED_SCOPE_DRIFT | REJECTED_TEST_INSUFFICIENT | REJECTED_TRACEABILITY_GAP | REJECTED_SECURITY_RISK` must reflect measured findings. One source commit or a populated FIC document is not Ground.

## DT gap mapping / limitations

Potentially useful for **B7** public mission→actual authorized consumer: exact revision-bound read of the mission, extracted obligations reaching the active runtime, permitted action and independently observed effect/negative controls. A FIC packet could make missing obligations falsifiable, but **existing DT mission/consumer architecture and whether this would be novel are UNKNOWN**. For **external assimilation**, add source-provenance→Gate A→owner/Gate B→bounded implementation→independent Ground and later reuse; a unit contract cannot replace any of those stages. B1 protected history requires the original owner's audited no-loss disposition, not a FIC waiver.

**Disposition:** KEEP / SURGICALLY_REDUCED_IN_PLACE / historical design. Revisit only if a present-DT source-pinned consumer shows lost mandatory obligations, duplicate owner, or false completion and an authorized bounded experiment is available; otherwise `ALREADY_PRESENT` or `NO_ELIGIBLE_FIXTURE`. No new Director proposal, private code, deployment or executed tests are justified by this document alone.
