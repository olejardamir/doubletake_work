# Agent_X Assimilator — Remaining Atomic Implementation Backlog

**Repository:** `Astrocytech/Agent_X`  
**Audited branch:** `main`  
**Audited HEAD:** `4cf96b4081714fad7ee7adab3c6040c8325c2a7d`  
**Previous backlog baseline:** `47dcde3ffc0d97fabd501875cb97e597a708a063`  
**Original atomic tasks:** 105  
**Tasks removed as fully implemented:** 29  
**Tasks remaining:** 54

This file supersedes `AGENT_X_ASSIMILATOR_ATOMIC_TASKS.md`.

The removal rule is strict: a task is removed only when the current repository
contains the required implementation **and** enough wiring/tests to satisfy that
task's original definition of done. A file, helper, comment, or commit title by
itself is not enough.

## Completed work removed from this backlog

The following atomic tasks are already implemented on the audited `main` and
must **not** be redone:

```text
A01 A02

C01 C02 C03 C04 C05 C06 C07 C08

K01 K02 K03 K04 K05

F01 F02 F03 F04 F05 F06 F07

P01 P02 P03 P04

E01 E02 E03
```

In practical terms, the repository now already has:

- the mixed assimilation fixture and Acceptance-A classification coverage;
- the six-class source taxonomy and admission decisions;
- callable/public-symbol filtering and admission wiring into discovery;
- observable authority-sync failures;
- `ExecutionMode` and `FidelityState`;
- canonical intent/example/policy/fidelity/verification metadata;
- canonical binding representation via `CapabilityBinding` / `primary_binding`;
- placeholder detection, structured fidelity evidence, deterministic fidelity
  assignment, PARTIAL rules, reference-behavior checking, and a live promotion
  fidelity gate;
- `promote_to_contract()` and canonical publication from integrated/synthesized
  promotion paths;
- the explicit architectural rule that `CapabilityAuthority`, not the legacy
  registry or synthesized manifest, is semantic/executable authority;
- a canonical execution binding resolver plus pre-execution contract and input
  revalidation.

## Important current-main gaps found during this audit

Do not mistake partially implemented files for completed phases:

1. `CapabilityContract.is_routable` is still too weak: ROUTABLE + binding only.
2. Contract validation/migration still needs hardening.
3. Canonical publication failure is counted but is not yet fully fail-closed.
4. `capability_semantic.py` currently implements its own TF-IDF-like primary
   matching instead of indexing/retrieving through the existing `SemanticService`.
5. `capability_router.py` currently allows non-capability source classes in its
   candidate filter and lacks schema binding, explicit missing-input semantics,
   bounded composition, and reliability-aware ranking.
6. `capability_execution.py` has E01–E03 but still lacks output validation,
   postcondition verification, reliability evidence, fallback, and composed-plan
   execution; its governance layer must be connected to existing Agent_X
   governance rather than remain a parallel local policy.
7. normal MCP `tools/list` still grows with synthesized per-module tools and
   there is no stable `borg_execute_intent`.
8. no complete atomic capability-publication transaction exists across runtime,
   manifest, authority, and semantic state.
9. full inventory migration/permanent hygiene remains.

## Execution rules

- Work from the current repository state. Do not reset/revert unrelated work.
- Extend current implementations; do not create parallel replacements.
- Reuse `CapabilityAuthority`, `SemanticService`, existing semantic index,
  existing governance, synthesized runtime, and hardened transaction primitives
  where their contracts actually fit.
- Keep discovery, fidelity, publication, routing, and execution as separate
  responsibilities.
- Do not make untrusted prose executable instructions.
- Never delete original external/user source material.
- Keep loops, retries, retrieval, composition, and cleanup bounded.
- Preserve original task IDs below; do not renumber them.



# PHASE A — Remaining guardrail work

## A03 — Audit reusable transaction primitives before designing publication — **DONE**

Historical DONE claim (not independently verified against current DT). **Current `main` audit note:** Current-main note: gap-filling transaction hardening exists, but no Assimilator-specific publication transaction currently coordinates runtime, manifest, canonical authority, and semantic-index state. Audit reuse; do not treat `GapApplyTransaction` as Task T. **RESOLVED:** Added a detailed "A03 — Reusable transaction-primitive audit" note to the `assimilation_publication.py` module docstring covering all 9 required items and the decision not to import `GapApplyTran

# PHASE C — Source classification and admission


# PHASE K — Finish the canonical capability contract

## K06 — Add contract validation helpers

**Current `main` audit note:** Current-main note: `CapabilityContract.validation_errors()` already exists, but it currently checks only a subset of the required routability fields. Extend that method; do not add a second validator.

**Depends on:** none (all listed prerequisites are already complete on current `main`)

**Where**

```text
tools/agentx_evolve/collective_core/capability_contract.py
```

**What**

Make contract completeness explicit.

**How**

Add a method such as:

```python
def validation_errors(self) -> tuple[str, ...]:
    ...
```

For a routable capability check at least:

```text
name
non-empty intents
input schema is an object/dict
output schema is a dict or explicitly unconstrained
binding exists
execution_mode valid
fidelity_state valid
effects present
safety present
verification present
provenance present
active status
source_class=capability
```

Keep validation deterministic and side-effect free.

**Definition of done**

Malformed contracts produce specific validation errors rather than merely becoming mysterious routing failures.

---

## K07 — Strengthen `is_routable`

**Current `main` audit note:** Current-main note: `CapabilityContract.is_routable` is still only `status == ROUTABLE and bindings >= 1`. Strengthen this existing property.

**Depends on:** K06

**Where**

```text
tools/agentx_evolve/collective_core/capability_contract.py
```

**What**

Replace the current minimal rule:

```text
CAPABILITY + ACTIVE + binding
```

with a safe completeness/fidelity rule.

**How**

Conceptually:

```python
@property
def is_routable(self) -> bool:
    return (
        self.source_class == SourceClass.CAPABILITY.value
        and self.status == CapabilityStatus.ACTIVE.value
        and bool(self.bindings)
        and bool(self.intents)
        and self.execution_mode in ExecutionMode.values()
        and self.fidelity_state in {
            FidelityState.VERIFIED.value,
            FidelityState.PARTIAL.value,
        }
        and bool(self.verification)
        and not self.validation_errors()
    )
```

If `PARTIAL` is routable, its contract must explicitly describe the supported subset.

**Definition of done**

- UNKNOWN/PLACEHOLDER/FAILED contracts are not routable.
- Incomplete active contracts are not routable.
- A complete verified fixture is routable.

---

## K08 — Make persisted authority migration backward-compatible and fail-safe

Historical DONE claim (not independently verified against current DT). **Current `main` audit note:** Current-main note: `from_dict()` has compatibility defaults, but migration still needs an explicit old-schema verification path so a legitimate old 64-character digest is not mistaken for tampering after the schema changed.

## K09 — Enrich native seed contracts

Historical DONE claim (not independently verified against current DT). **DONE (K09):** Implemented `seed_core_contracts()` in `capability_contract.py` — inserts enriched `echo`, `add`, and `blob_put` seed contracts into a `CapabilityAuthority` with intents, input/output schemas (in effects), effects, requirements, safety, `execution_mode=NATIVE`, `fidelity_state=VERIFIED`, verification, native bindings, and provenance. Idempotent (skips already-enriched contracts). 16 tests in `TestK09NativeSeedEnrichment` covering creation, routability, intents, execution_mode, fi

## K10 — Make legacy registry adaptation safe by default

Historical DONE claim (not independently verified against current DT). **DONE (K10):** Implemented `CapabilityAuthority.register_from_registry_item()` in `capability_contract.py` — safe-by-default adapter for legacy `CapabilityRegistry` items. By default: `fidelity_state=UNKNOWN`, empty `execution_mode`, no executable binding, status `CREATED` (never routable). `executable=True` retained for compatibility but requires explicit `intents` + `verification`; even then it stays `fidelity_state=UNKNOWN` so structurally bound+ROUTABLE contracts remain out of the effective

## K11 — Add bounded authority query for routable contracts

Historical DONE claim (not independently verified against current DT). **DONE (K11):** Extended `CapabilityAuthority.routable()` in `capability_contract.py` to accept a bounded `limit` parameter (0 = unbounded, backward compatible), and added `CapabilityAuthority.list_routable(limit=1000)` as the canonical bounded enumeration — the single place router/index code asks the authority for the current routing set (applies `is_routable` + `fidelity != UNKNOWN`, never duplicated). Negative limits rejected. 7 tests in `TestK11ListRoutable` (default limit, respects limit, e

## K12 — Prove Acceptance B — **DONE**

Historical DONE claim (not independently verified against current DT). 

# PHASE F — Behavioral fidelity


# PHASE P — Finish canonical publication semantics

## P05 — Make canonical publication failure observable — **DONE**

Historical DONE claim (not independently verified against current DT). **Current `main` audit note:** Current-main note: live service paths now count `canonical_failed`, but a canonical-authority failure can still occur after earlier integration work. Counting the failure is not sufficient: success/non-promotion semantics must be fail-closed. **RESOLVED:** Both the `_register_integrated_as_tools` (P03, transaction path via `publish_targets`) and `register_synthesized_modules` (P02) service paths are fail-closed — a non-COMMITTED transaction or an injected `authorit

## P06 — Prove one-authority inventory — **DONE**

Historical DONE claim (not independently verified against current DT). **Current `main` audit note:** Current-main note: native/integrated/synthesized canonical publication pieces now exist, but the one-authority invariant still needs an explicit acceptance proof after K06–K11 and P05 are complete. **RESOLVED:** `tests/test_assimilator_publication.py` (9 tests, all passing) proves native/adopted/synthesized capabilities are all queryable through a single `CapabilityAuthority`, and only COMPLETE/VERIFIED + PARTIAL fidelity states are routable (UNKNOWN excluded).

# PHASE S — Semantic capability indexing


# PHASE S — Semantic capability indexing through existing SemanticService

## S01 — Add deterministic routing-text builder — **DONE**

Historical DONE claim (not independently verified against current DT). **Current `main` audit note:** Current-main note: `capability_semantic.py` now contains a custom deterministic TF-IDF-like fingerprint implementation. The target architecture still requires the existing `SemanticService` as the primary semantic retrieval system. Reuse the current fingerprint logic only as a bounded deterministic fallback if useful.

## S02 — Add semantic index adapter for capability contracts — **DONE**

Historical DONE claim (not independently verified against current DT). **Current `main` audit note:** Current-main note: do not create another semantic database or keep the current fingerprint-only mechanism as the primary router. Adapt capability contracts into the existing `SemanticService`/semantic index.

## S03 — Index only routable contracts — **DONE**

Historical DONE claim (not independently verified against current DT). 

## S04 — Connect authority invalidation callbacks to semantic maintenance — **DONE**

Historical DONE claim (not independently verified against current DT). 

## S05 — Make indexing idempotent — **DONE**

Historical DONE claim (not independently verified against current DT). 

## S06 — Implement bounded lexical/structured fallback — **DONE**

Historical DONE claim (not independently verified against current DT). 

## S07 — Add bounded candidate retrieval API — **DONE**

Historical DONE claim (not independently verified against current DT). 

## S08 — Prove Acceptance D — **DONE**

Historical DONE claim (not independently verified against current DT). 

# PHASE R — Transparent capability routing


# PHASE R — Finish transparent capability routing

## R01 — Define router result types — **DONE**

Historical DONE claim (not independently verified against current DT). **Current `main` audit note:** Current-main note: `capability_router.py` exists with `CandidateScore` and `RoutingDecision`, but it lacks the required MATCH/NO_MATCH/MISSING_INPUT outcomes and bound execution-call plan. Refactor/extend the existing file.

## R02 — Retrieve candidates from semantic adapter only — **DONE**

Historical DONE claim (not independently verified against current DT). **Current `main` audit note:** Current-main note: the current router scans `CapabilityAuthority.routable()` and computes local fingerprints directly. Replace that primary retrieval path with the capability semantic adapter built in Phase S.

## R03 — Revalidate candidate canonical state — **DONE**

Historical DONE claim (not independently verified against current DT). **Current `main` audit note:** Current-main note: semantic-hit digest/revision revalidation is not present. Add it against the current canonical authority before selection.

## R04 — Add understandable candidate ranking — **DONE**

Historical DONE claim (not independently verified against current DT). **Current `main` audit note:** Current-main note: ranking currently uses similarity plus canonical-name tie-breaking only. Extend the existing ranking; do not create a second router.

## R05 — Implement schema-driven argument binding — **DONE**

Historical DONE claim (not independently verified against current DT). **Current `main` audit note:** Current-main note: the current router does not bind user/context values against the capability input schema. Add binding before any execution plan is emitted.

## R06 — Add explicit `NO_MATCH` — **DONE**

Historical DONE claim (not independently verified against current DT). **Current `main` audit note:** Current-main note: `selected=None` exists, but retain this task until the router has an explicit NO_MATCH outcome distinct from missing required input.

## R07 — Produce single-capability execution plans — **DONE**

Historical DONE claim (not independently verified against current DT). 

## R08 — Add bounded composition search — **DONE**

Historical DONE claim (not independently verified against current DT). **Current `main` audit note:** Current-main note: bounded composition is not present in the current router.

## R09 — Add output-to-input binding for composed plans — **DONE**

Historical DONE claim (not independently verified against current DT). **Current `main` audit note:** Current-main note: explicit cross-step output→input bindings are not present.

## R10 — Prove Acceptance E and routing core — **DONE**

Historical DONE claim (not independently verified against current DT). 

# PHASE E — Governed execution, verification, fallback, reliability


# PHASE E — Finish governed execution, verification, fallback, reliability

## E04 — Route effects through existing governance/approval

**Current `main` audit note:** Current-main note: `capability_execution.py` exists and E01–E03 are implemented. Its current governance evaluator uses a local static effect policy. This task remains until execution is actually routed through Agent_X's existing governance/approval infrastructure rather than a parallel policy substitute.

**Depends on:** none (all listed prerequisites are already complete on current `main`)

**Where**

```text
tools/agentx_evolve/collective_core/capability_execution.py
```

plus existing governance entry points only as necessary.

**What**

Assimilated capabilities must not bypass Agent_X governance.

**How**

Translate contract:

```text
effects
requirements
safety
```

into existing operation/policy/approval checks.

Do not create a special “assimilation trusted” bypass.

Read-only and side-effecting capabilities must remain distinguishable.

**Definition of done**

A fixture marked as requiring approval cannot execute without the same governed decision path expected for equivalent native behavior.

---

## E05 — Validate output schema

**Current `main` audit note:** Current-main note: current `execute_bound()` returns executor output without canonical output-schema validation.

**Depends on:** E04

**Where**

```text
tools/agentx_evolve/collective_core/capability_execution.py
```

**What**

A successful return does not automatically mean a successful capability execution.

**How**

Validate returned value against canonical `output_schema`.

Record output validation separately from invocation success.

**Definition of done**

A capability returning the wrong type/schema is marked verification failure even if no exception occurred.

---

## E06 — Implement verification strategy evaluation

**Current `main` audit note:** Current-main note: canonical postcondition/verification evaluation is not yet part of the execution boundary.

**Depends on:** E05

**Where**

```text
tools/agentx_evolve/collective_core/capability_execution.py
```

**What**

Evaluate canonical `verification`.

**How**

Support a bounded initial set matching contract data:

```text
output_schema
expected value/reference case
predicate/invariant represented safely
postcondition checks through existing governed read operations
```

Do not eval arbitrary source strings as predicates.

**Definition of done**

A capability can fail postcondition verification after technically returning successfully.

---

## E07 — Add structured execution receipt

**Current `main` audit note:** Current-main note: `ExecutionResult` exists, but the required verification-rich execution receipt is not yet implemented.

**Depends on:** E05, E06

**Where**

```text
tools/agentx_evolve/collective_core/capability_execution.py
```

**What**

Record evidence needed by fallback and reliability.

**How**

Suggested fields:

```python
@dataclass(frozen=True)
class CapabilityExecutionReceipt:
    capability_id: str
    contract_digest: str
    invoked: bool
    invocation_success: bool
    output_valid: bool
    verification_passed: bool
    error_category: str | None
    elapsed_ms: float
    output: object | None
```

Add governance decision identifiers if existing infrastructure supplies them.

**Definition of done**

Every attempted execution returns or records a structured receipt, including failures.

---

## E08 — Add reliability evidence store/update

**Current `main` audit note:** Current-main note: persistent reliability evidence for verified executions is not yet wired.

**Depends on:** E07

**Where**

Prefer existing mutable evidence/telemetry storage.

If needed, add a small reliability record owned by capability execution rather than mutating digest-bound identity fields on every call.

**What**

Track:

```text
attempts
successful verified executions
verified failures
recent failure rate
last verified use
```

**How**

Do not force rapidly changing reliability counters into the immutable identity digest unless the current authority intentionally models them that way.

Expose a read API for ranking.

**Definition of done**

One verified success and one verified failure update evidence deterministically without creating a new capability identity.

---

## E09 — Feed reliability into router ranking

**Depends on:** E08, R04

**Where**

```text
tools/agentx_evolve/collective_core/capability_router.py
```

**What**

Use reliability as one bounded ranking signal.

**How**

Example:

```text
high verified success history -> modest bonus
recent verified failures      -> modest penalty
no history                     -> neutral
```

Do not permanently blacklist a capability from one failure unless policy/fidelity changes justify it.

**Definition of done**

Two otherwise equivalent candidates can reorder based on accumulated verified reliability evidence.

---

## E10 — Implement bounded candidate fallback

**Current `main` audit note:** Current-main note: bounded fallback across ranked candidates is not yet wired.

**Depends on:** E07, E09

**Where**

```text
tools/agentx_evolve/collective_core/capability_execution.py
```

or orchestration layer alongside router.

**What**

When the best candidate fails execution/verification, try another safe ranked candidate.

**How**

Bound attempts, e.g.:

```python
MAX_CANDIDATE_ATTEMPTS = 3
```

On each failure:

1. persist evidence;
2. verify the next candidate is still current/routable;
3. bind/execute safely;
4. stop on first verified success.

No infinite retry.

**Definition of done**

A failing first candidate can fall back to a working second candidate and total attempts cannot exceed the configured bound.

---

## E11 — Execute bounded composed plans

**Current `main` audit note:** Current-main note: composed plans are not yet executed by the current boundary.

**Depends on:** E06, R09

**Where**

```text
tools/agentx_evolve/collective_core/capability_execution.py
```

**What**

Execute router-produced multi-step plans.

**How**

For each step:

1. resolve current contract;
2. revalidate;
3. bind upstream outputs;
4. govern;
5. execute;
6. validate;
7. verify;
8. stop if required step fails.

Honor router max-step bound again at execution.

**Definition of done**

A two-step composition succeeds and a failed first step prevents unsafe downstream execution.

---

## E12 — Prove Acceptance F, H, and I

**Depends on:** E11

**Where**

```text
tests/test_assimilator_execution.py
tests/test_assimilator_end_to_end.py
```

**What**

Tests:

### F — Invisible automatic use

Request weighted-total behavior without source/module/tool name.

### H — Competition/fallback

Two candidates; better ranks first; force its verification failure; second succeeds.

### I — Composition

Two compatible fixture capabilities form and execute a two-step plan.

**Definition of done**

Acceptance F, H, and I pass.

---

# PHASE M — Bound MCP/LLM exposure


# PHASE M — Bound MCP/LLM exposure

## M01 — Add stable `borg_execute_intent` MCP tool

**Current `main` audit note:** Current-main note: `agentx_mcp_server.py` currently has no `borg_execute_intent` tool.

**Depends on:** E12

**Where**

```text
tools/agentx_evolve/collective_core/agentx_mcp_server.py
```

**What**

Expose one stable normal interface for transparent capability use.

**How**

Conceptual definition:

```python
{
    "name": "borg_execute_intent",
    "description": "Execute the best governed capability for an outcome request.",
    "inputSchema": {
        "type": "object",
        "properties": {
            "intent": {"type": "string"},
            "context": {"type": "object"},
        },
        "required": ["intent"],
        "additionalProperties": False,
    },
}
```

Keep the schema small and stable.

**Definition of done**

Normal MCP tools include `borg_execute_intent`.

---

## M02 — Dispatch `borg_execute_intent` through router + governed executor

**Depends on:** M01

**Where**

```text
tools/agentx_evolve/collective_core/agentx_mcp_server.py
```

**What**

Connect MCP call handling to the new transparent route/execute flow.

**How**

Conceptually:

```python
route = await capability_router.route(intent, context=context)
if route.status == "NO_MATCH":
    return structured_no_match()
if route.status == "MISSING_INPUT":
    return structured_missing_input(route.missing)
return await capability_executor.execute_route(route)
```

Do not translate intent into a synth module name inside MCP.

**Definition of done**

Calling one stable MCP tool can execute a newly assimilated verified ability.

---

## M03 — Stop default per-synthesized-tool enumeration

**Current `main` audit note:** Current-main note: `handle_tools_list()` still appends one `synth_<module>` definition per authored synthesized module. Remove this from normal mode.

**Depends on:** M01, M02

**Where**

```text
tools/agentx_evolve/collective_core/agentx_mcp_server.py
```

Current seam:

```text
handle_tools_list()
```

currently appends definitions returned by synthesized runtime `tool_definitions()`.

**What**

Normal MCP `tools/list` must not grow one tool per synthesized module.

**How**

Remove/guard the default loop that exposes all `synth_<module>` tools.

Normal mode:

```text
stable native tools
synth_call if retained as operator interface
borg_execute_intent
```

Per-module synthesized definitions should require explicit debug/admin compatibility mode if they must remain available at all.

**Definition of done**

Adding synthesized manifest rows does not materially increase normal `tools/list` count.

---

## M04 — Retain `synth_call` only as explicit/operator access

**Current `main` audit note:** Current-main note: `synth_call` and `synth_<module>` dispatch still coexist. Keep `synth_call` only as explicit/operator compatibility after M01–M03.

**Depends on:** M03

**Where**

```text
tools/agentx_evolve/collective_core/agentx_mcp_server.py
```

**What**

Preserve low-level invocation for diagnostics/backward compatibility without making it the normal user path.

**How**

Do not remove it if existing code/tests depend on it unless replacement compatibility is implemented.

Document it as explicit direct invocation.

**Definition of done**

Existing explicit synthesized calls remain available where required, while normal transparent execution uses `borg_execute_intent`.

---

## M05 — Make retained direct invocation contract-driven

**Depends on:** M04, K12

**Where**

```text
tools/agentx_evolve/collective_core/agentx_mcp_server.py
tools/agentx_evolve/collective_synthesized/tool_runtime.py
```

**What**

Do not trust the current generic direct schema as semantic authority.

**How**

For a direct call:

1. resolve current canonical contract;
2. validate requested function/target matches allowed binding;
3. validate params against canonical input schema;
4. reject stale/non-routable contract where direct policy requires routability;
5. execute through governance where applicable.

The manifest remains packaging/lookup.

**Definition of done**

A malformed direct call that violates canonical schema is rejected before synthesized runtime invocation.

---

## M06 — Add explicit debug-mode per-module listing only if required

**Depends on:** M03

**Where**

```text
tools/agentx_evolve/collective_core/agentx_mcp_server.py
```

**What**

Preserve troubleshooting ability without bloating normal model context.

**How**

If existing operator workflows require `synth_<module>` enumeration, guard it behind an explicit server setting/environment/configuration already consistent with project patterns.

Default must be off.

**Definition of done**

Normal mode is bounded; debug mode can opt into legacy detailed listing if required.

---

## M07 — Prove Acceptance G

**Depends on:** M01, M06

**Where**

```text
tests/test_assimilator_mcp_surface.py
```

**What**

Create 100 fake active verified canonical assimilated capabilities.

**How**

Assert:

```text
normal tools/list count before ≈ normal tools/list count after
```

Allow only a small fixed difference from introducing `borg_execute_intent`, not +100.

Then route an intent matching one of the 100 fake capabilities.

**Definition of done**

Acceptance G passes.

---

# PHASE T — Atomic, same-process capability publication


# PHASE T — Atomic, same-process capability publication

## T01 — Define Assimilator publication transaction state

**Current `main` audit note:** Current-main note: no dedicated Assimilator publication transaction currently coordinates all required live stores. Implement in the cleanest existing/new location; a filename is not itself the requirement.

**Depends on:** A03, P06, S08, M07

**Where**

Recommended:

```text
tools/agentx_evolve/collective_core/assimilation_publication.py
```

**What**

Represent one promotion transaction across runtime + manifest + authority + semantic index.

**How**

Define states such as:

```text
PREPARED
RUNTIME_PUBLISHED
MANIFEST_PUBLISHED
AUTHORITY_PUBLISHED
SEMANTIC_PUBLISHED
COMMITTED
ROLLBACK_REQUIRED
ROLLED_BACK
RECOVERY_REQUIRED
```

Names may align with existing transaction conventions.

**Definition of done**

Transaction state can represent partial publication explicitly.

---

## T02 — Define transaction manifest and ownership record

**Depends on:** T01

**Where**

```text
tools/agentx_evolve/collective_core/assimilation_publication.py
```

**What**

Record exactly what the transaction owns and what pre-existed.

**How**

Persist enough preimage data to restore:

```text
runtime module path + previous hash/mode/existence
synth manifest previous row/state
authority previous contract/state
semantic previous active record/state
candidate ID
contract digest
source provenance
```

Original external source is read-only and must never be transaction-owned.

**Definition of done**

Given only durable transaction data, code can tell which generated/live artifacts it is allowed to roll back.

---

## T03 — Stage all publication artifacts before live mutation

**Depends on:** T02

**Where**

```text
tools/agentx_evolve/collective_core/assimilation_publication.py
tools/agentx_evolve/collective_core/service.py
```

**What**

Move live publication out of ad-hoc sequential writes.

**How**

Before changing live state, prepare:

```text
generated/adopted runtime target
manifest row
complete validated canonical contract
semantic routing text/index payload
```

All must pass local validation before first live publication step.

**Definition of done**

A malformed contract or invalid runtime artifact fails before any live semantic/authority publication.

---

## T04 — Implement ordered publication with durable journaling

**Depends on:** T03

**Where**

```text
tools/agentx_evolve/collective_core/assimilation_publication.py
```

**What**

Publish each required subsystem while recording every completed effect.

**How**

A reasonable sequence is:

```text
runtime artifact
runtime manifest
canonical authority
semantic index
commit receipt
```

But choose exact order based on rollback guarantees.

After each effect, persist journal state before continuing.

Reuse hardened gap transaction primitives where safe.

**Definition of done**

Crash/failure injection can identify the exact last completed publication effect.

---

## T05 — Implement compensating rollback

**Depends on:** T04

**Where**

```text
tools/agentx_evolve/collective_core/assimilation_publication.py
```

**What**

Restore the pre-transaction view on failure.

**How**

Reverse applied effects:

```text
semantic -> tombstone/restore previous
authority -> restore previous contract or retire transaction-created contract
manifest -> restore/remove transaction row
runtime -> restore preimage or remove transaction-owned generated file
```

Never blindly delete a path without ownership/preimage evidence.

**Definition of done**

Failure after any individual publication phase restores all earlier phases to their pre-transaction state.

---

## T06 — Implement fail-closed reconciliation

**Depends on:** T05

**Where**

```text
tools/agentx_evolve/collective_core/assimilation_publication.py
```

**What**

Recover after interrupted transactions.

**How**

On startup/next maintenance pass:

- load transaction journal/receipt;
- classify each owned effect as preimage/postimage/unknown;
- if all committed postimages + valid commit receipt -> committed;
- if safely restorable known mixed state -> rollback;
- if unknown external mutation is detected -> `RECOVERY_REQUIRED`;
- never guess.

Model this after the hardened gap-filling reconciliation where appropriate.

**Definition of done**

Unknown/tampered publication state is never silently treated as committed.

---

## T07 — Wire `CollectiveService` promotion through the transaction

**Depends on:** T04, T06

**Where**

```text
tools/agentx_evolve/collective_core/service.py
```

**What**

Replace provisional separate synthesized/authority/semantic publication with the transaction.

**How**

After classification + synthesis/adoption + fidelity + complete contract:

```python
receipt = await publication.publish(candidate)
if receipt.verdict != "COMMITTED":
    do_not_report_integrated()
```

Legacy registry updates needed for compatibility should be inside or consistently derived from committed state if their divergence would affect behavior.

**Definition of done**

There is one authoritative promotion path for newly executable assimilated abilities.

---

## T08 — Invalidate same-process caches after commit

**Depends on:** T07

**Where**

```text
CapabilityAuthority invalidation callbacks
capability_semantic.py
capability_router.py
tool_runtime.py only if it caches manifest/runtime state
```

**What**

Make a newly committed capability visible immediately.

**How**

On commit:

- authority revision changes;
- semantic adapter receives/reindexes it;
- router cache, if any, invalidates by authority revision;
- synthesized runtime manifest/module cache, if any, refreshes.

Do not require MCP reconnect/restart or manual tools/list refresh.

**Definition of done**

Same process routes the new ability on the next request.

---

## T09 — Prove Acceptance J

**Depends on:** T08

**Where**

```text
tests/test_assimilator_transaction.py
tests/test_assimilator_end_to_end.py
```

**What**

Same-process hot integration.

**How**

In one test process:

1. initialize authority/semantic/router/service;
2. assimilate weighted-total fixture;
3. commit publication;
4. immediately call ordinary intent;
5. execute and verify result.

No service restart.

**Definition of done**

Acceptance J passes.

---

## T10 — Prove Acceptance K with failure injection

**Depends on:** T05, T08

**Where**

```text
tests/test_assimilator_transaction.py
```

**What**

Inject failure after each live publication stage.

**How**

Parameterized failure points:

```text
after runtime
after manifest
after authority
after semantic
before receipt/commit
```

After rollback/reconcile assert no transaction-created half-live:

```text
routable authority contract
active semantic row
manifest row
runtime module
```

remains.

**Definition of done**

Acceptance K passes for every failure point.

---

# PHASE G — Existing-inventory migration and permanent hygiene


# PHASE G — Existing-inventory migration and permanent hygiene

## G01 — Build an inventory scanner over all Assimilator-owned state

**Current `main` audit note:** Current-main note: existing orphan-cleanup behavior in `service.py` is useful foundation, but there is not yet one joined inventory/migration view across runtime, manifest, registry, authority, semantic records, and staging.

**Depends on:** T10

**Where**

Recommended:

```text
tools/agentx_evolve/collective_core/assimilation_hygiene.py
```

**What**

Produce one joined view of current generated/live Assimilator state.

**How**

Scan:

```text
collective_synthesized/
mcp_tools.manifest.json
legacy CapabilityRegistry
CapabilityAuthority
semantic capability_contract records
Assimilator staging/temp/transaction directories
```

Join by available identities:

```text
module name
capability ID
contract binding
provenance
digest
manifest source
```

Do not infer ownership merely from similar filenames.

**Definition of done**

One inventory object/report can identify cross-store references for each generated item.

---

## G02 — Add migration action enum/classification

**Depends on:** G01

**Where**

```text
tools/agentx_evolve/collective_core/assimilation_hygiene.py
```

**What**

Classify each existing item into exactly one action.

**How**

Use:

```text
KEEP_EXECUTABLE
REBUILD_EXECUTABLE
KEEP_AS_KNOWLEDGE
RETIRE
DELETE_GENERATED_ARTIFACT
```

Base decisions on:

```text
source classification
fidelity evidence
canonical dependencies
ownership/provenance
duplicate identity
```

**Definition of done**

Every scanned item has one proposed action plus a reason.

---

## G03 — Implement deterministic dry-run report

**Depends on:** G02

**Where**

```text
tools/agentx_evolve/collective_core/assimilation_hygiene.py
```

**What**

No destructive migration occurs before a reviewable plan exists.

**How**

Report fields:

```text
item
current classification
proposed action
evidence/reason
owning subsystem
affected manifest entry
affected contract
affected semantic record
affected runtime path
```

Sort deterministically.

**Definition of done**

Running dry-run twice on unchanged state produces equivalent ordered output and performs zero mutations.

---

## G04 — Implement strict generated-artifact ownership predicate

**Depends on:** G01

**Where**

```text
tools/agentx_evolve/collective_core/assimilation_hygiene.py
```

**What**

Centralize the rule for whether cleanup may delete a file.

**How**

Equivalent to:

```python
def may_delete_generated(
    path: Path,
    *,
    owned_roots: tuple[Path, ...],
    provenance_proves_owned: bool,
    active_references: set[Path],
) -> bool:
    resolved = path.resolve()
    if not any(resolved.is_relative_to(root.resolve()) for root in owned_roots):
        return False
    if not provenance_proves_owned:
        return False
    if resolved in active_references:
        return False
    return True
```

Also reject symlink/path-escape cases.

**Definition of done**

Original imported/external source cannot pass the deletion predicate.

---

## G05 — Detect proven duplicates

**Depends on:** G01, G04

**Where**

```text
tools/agentx_evolve/collective_core/assimilation_hygiene.py
```

**What**

Identify `_2`, `_3`, etc. copies only when evidence proves equivalence.

**How**

Filename suffix is only a clue.

Require one or more strong equivalence signals:

```text
same content digest
same normalized generated code digest
same source digest + behavior/reference digest
same canonical contract semantics + binding target identity
```

Do not deduplicate two different behaviors merely because their names differ by `_2`.

**Definition of done**

A true duplicate fixture is detected and two same-prefix but behaviorally different fixtures are not merged.

---

## G06 — Migrate known document/history pollution

**Depends on:** G02, G05

**Where**

Migration/hygiene code and actual generated inventory.

**What**

Ensure known regression items do not remain normal executable capabilities solely because generated wrappers exist.

Known examples from the current Assimilator audit:

```text
AGENTS
ChangeLog
ChangeLog_2
Changes
Changes_2
Howhy_PredictiveMind
```

**How**

For each actual current item:

1. trace provenance;
2. classify original source;
3. inspect fidelity/dependencies;
4. retire/remove routable canonical state;
5. tombstone semantic executable record;
6. remove manifest/runtime wrapper only if generated ownership is proven;
7. preserve useful original content as knowledge/provenance if appropriate.

**Definition of done**

None of the listed document/history/research-derived wrappers remains an ordinary routable executable solely because a wrapper exists.

---

## G07 — Evaluate `Hal` rather than blindly deleting it

**Depends on:** G02

**Where**

Current synthesized inventory + hygiene migration.

**What**

Determine whether `Hal` represents real behavior, partial behavior, placeholder behavior, or duplicate behavior.

**How**

Apply the same:

```text
classification
fidelity
dependency
ownership
duplicate
```

rules as every other item.

Do not hard-code `Hal` for deletion.

**Definition of done**

`Hal` receives an evidence-based action, and the migration code contains no name-only deletion special case.

---

## G08 — Reconcile stale runtime manifest and generated modules

**Depends on:** G01, G04, G05

**Where**

```text
tools/agentx_evolve/collective_synthesized/
tools/agentx_evolve/collective_synthesized/mcp_tools.manifest.json
tools/agentx_evolve/collective_core/assimilation_hygiene.py
```

**What**

Remove/repair cross-store orphan states.

**How**

Cases:

```text
manifest row -> missing generated module
generated module -> no committed manifest/contract
duplicate manifest rows
manifest target -> retired/non-routable contract
```

Preserve active dependencies.

**Definition of done**

Every active manifest row points to a valid intended runtime artifact and no unreferenced transaction-owned generated module remains.

---

## G09 — Reconcile stale authority and semantic records

**Depends on:** G01, S05

**Where**

```text
tools/agentx_evolve/collective_core/assimilation_hygiene.py
tools/agentx_evolve/collective_core/capability_semantic.py
```

**What**

Retire/tombstone inconsistent semantic executable state.

**How**

Examples:

```text
active semantic record + missing/non-routable contract -> tombstone semantic
active contract + missing required runtime binding -> retire/non-routable
retired contract + active semantic record -> tombstone semantic
duplicate current contracts for proven same ability -> preserve canonical, retire duplicate
```

**Definition of done**

Authority and semantic active sets agree on routable capability identity.

---

## G10 — Reuse and extend existing orphan cleanup

**Depends on:** G08, G09

**Where**

```text
tools/agentx_evolve/collective_core/service.py
```

Current seam includes existing synthesized orphan cleanup behavior.

**What**

Do not create a second unrelated cleanup pass for the same generated modules.

**How**

Either:

- call the existing cleanup from the new hygiene coordinator; or
- move shared logic into `assimilation_hygiene.py` and keep service using it.

Preserve current valid behavior.

**Definition of done**

There is one effective ownership-aware orphan cleanup path, not two conflicting ones.

---

## G11 — Clean abandoned staging/temp/failed transaction state

**Depends on:** T06, G04

**Where**

```text
tools/agentx_evolve/collective_core/assimilation_hygiene.py
```

**What**

Remove transaction-owned temporary artifacts that are no longer needed.

**How**

Only remove:

```text
staging files
temporary extraction files
generated test debris
rolled-back transaction artifacts
expired failed unpublished transaction artifacts
```

Retain enough receipts/journals for required audit/recovery according to existing project retention patterns.

Never delete a `RECOVERY_REQUIRED` transaction merely to make cleanup green.

**Definition of done**

Old safe-to-remove staging debris disappears, while unresolved recovery state remains visible.

---

## G12 — Run bounded hygiene at the end of every assimilation transaction

**Depends on:** G08, G11

**Where**

```text
tools/agentx_evolve/collective_core/service.py
tools/agentx_evolve/collective_core/assimilation_hygiene.py
```

**What**

Prevent future accumulation.

**How**

After committed or rolled-back assimilation, run bounded hygiene over transaction-owned/recently affected scope first.

Avoid an expensive full repository sweep on every small operation unless existing architecture requires it.

**Definition of done**

A failed or repeated assimilation does not leave an orphan generated module, stale manifest row, or abandoned staging directory behind.

---

## G13 — Make repeated assimilation idempotent

**Depends on:** G05, G12

**Where**

Service/promotion identity logic + tests.

**What**

Assimilating identical source twice must reuse current live identity rather than minting suffix copies.

**How**

Before generating/publishing a new module/contract, compare stable source/behavior identity and current canonical state.

If unchanged:

```text
reuse/no-op
```

If changed behavior:

```text
new revision/supersession
```

Do not generate `_2` merely because a filename already exists.

**Definition of done**

Second identical assimilation creates:

```text
0 new duplicate modules
0 duplicate active contracts
0 duplicate active semantic rows
```

---

## G14 — Prove Acceptance L

**Depends on:** G01, G13

**Where**

```text
tests/test_assimilator_hygiene.py
```

**What**

Test migration, safe cleanup, and idempotence.

**How**

Fixture state should include:

```text
document-derived fake tool
history-derived fake tool
real executable
duplicate generated copy
stale manifest row
orphan generated module
active dependency
original external source
abandoned staging artifact
```

Run dry run, apply, then run cleanup again.

Assert second apply reports zero material changes.

**Definition of done**

Acceptance L passes and original external source remains untouched.

---

# PHASE V — Final acceptance and stop condition


# PHASE V — Final acceptance and stop condition

## V01 — Run Acceptance A-C together

**Depends on:** G14

**Where**

Test suite.

**What**

Run classification, contract, fidelity acceptance tests.

**How**

Example:

```bash
pytest -q \
  tests/test_assimilator_source_classification.py \
  tests/test_assimilator_capability_contract.py \
  tests/test_assimilator_fidelity.py
```

Adjust paths if tests were placed in an existing cohesive module.

**Definition of done**

A, B, C all pass in one run.

---

## V02 — Run Acceptance D-F together

**Depends on:** V01

**What**

Run semantic, router, invisible-use tests.

**Definition of done**

D, E, F all pass in one run.

---

## V03 — Run Acceptance G-I together

**Depends on:** V02

**What**

Run bounded MCP exposure, fallback, and composition tests.

**Definition of done**

G, H, I all pass in one run.

---

## V04 — Run Acceptance J-L together

**Depends on:** V03

**What**

Run hot integration, atomic rollback, migration/hygiene tests.

**Definition of done**

J, K, L all pass in one run.

---

## V05 — Run relevant existing regressions

**Depends on:** V04

**Where**

At minimum, test areas touching:

```text
collective core
assimilation synthesis
semantic service/index
MCP server
synthesized runtime
gap-filling transaction if primitives were reused
```

**What**

Verify the new architecture did not break pre-existing behavior.

**Definition of done**

All directly affected existing tests pass without weakening old assertions.

---

## V06 — Run a live-state consistency audit

**Depends on:** V05

**What**

Inspect active state after tests/migration.

**How**

Assert:

```text
non-capability routable tools = 0
duplicate live canonical contracts = 0
duplicate active semantic rows = 0
stale synthesized manifest rows = 0
orphan generated modules = 0
abandoned safe-to-delete staging artifacts = 0
```

Do not count intentionally retained knowledge as junk.

**Definition of done**

All six counts are zero.

---

## V07 — Prove cleanup idempotence one final time

**Depends on:** V06

**What**

Run the production cleanup/hygiene command/API twice against unchanged state.

**Definition of done**

Second run has zero material mutations.

---

## V08 — Final repository-state check

**Depends on:** V07

**Where**

Repository root.

**How**

Run:

```bash
git status --short
git diff --check
```

Remove only temporary files created for this implementation.

Do not revert unrelated pre-existing user changes.

**Definition of done**

- No accidental temp/staging/test debris is left.
- Diff contains only intended implementation/test/migration changes plus deliberate cleanup.
- `git diff --check` passes.

---

# Dependency chain

The safe high-level order is:

```text
A
↓
C  Source admission
↓
K  Canonical contract
↓
F  Fidelity
↓
P  Canonical promotion
↓
S  Semantic indexing
↓
R  Transparent routing
↓
E  Governed execution / verification / fallback
↓
M  Bounded MCP surface
↓
T  Atomic + hot publication
↓
G  Migration / permanent hygiene
↓
V  Final acceptance
```

Do not perform destructive inventory migration before the new classifier, fidelity gate, and canonical routing model exist; otherwise cleanup has no reliable basis for deciding what should survive.

---

# Implementation ownership map

| Responsibility | Primary existing/new location |
|---|---|
| Canonical capability identity/state | `collective_core/capability_contract.py` |
| Discovery/legacy registry | `collective_core/capabilities.py` |
| Source admission classification | recommended `collective_core/source_classification.py` |
| Assimilation synthesis/adoption | `collective_core/assimilation_synthesis.py` |
| Main assimilation lifecycle | `collective_core/service.py` |
| Existing governed Collective execution | `collective_core/executor.py` |
| Semantic provider/index facade | `semantic/service.py` |
| Semantic record/tombstone implementation | `semantic/semantic_index.py` |
| Capability-specific semantic adapter | recommended `collective_core/capability_semantic.py` |
| Intent selection/composition | recommended `collective_core/capability_router.py` |
| Contract-driven governed invocation | recommended `collective_core/capability_execution.py` |
| Synthesized runtime packaging | `collective_synthesized/tool_runtime.py` |
| MCP exposure | `collective_core/agentx_mcp_server.py` |
| Capability publication transaction | recommended `collective_core/assimilation_publication.py` |
| Inventory migration/GC | recommended `collective_core/assimilation_hygiene.py` |
| Reusable transaction primitives | inspect `gap_filling/transaction.py`; reuse only where semantically valid |

---

# Key code skeletons

These sketches show the intended boundaries. They are not drop-in patches because exact constructor signatures should be adapted to the repository at implementation time.

## 1. Admission boundary

```python
decision = classifier.classify(
    path=source_path,
    legacy_kind=cap.kind,
    discovered_symbols=symbols,
    content_sample=sample,
)

legacy = registry.register(...)

authority.register_from_registry_item(
    legacy,
    executable=False,
    source_class=decision.source_class.value,
)
```

Important:

```text
discovered != executable
source code != verified capability
generated module != successful assimilation
```

---

## 2. Promotion boundary

```python
fidelity = evaluate_fidelity(candidate, evidence)

if fidelity.state not in {VERIFIED, PARTIAL}:
    return PromotionResult(
        promoted=False,
        reason=fidelity.reason,
    )

contract = build_promoted_contract(
    candidate=candidate,
    fidelity=fidelity,
)

contract.require_valid_routable_contract()

receipt = await publication.publish(
    runtime_candidate=candidate,
    contract=contract,
)

if not receipt.committed:
    raise PublicationError(receipt)
```

---

## 3. Semantic boundary

```python
async def synchronize_contract(contract: CapabilityContract) -> None:
    if not contract.is_routable:
        await tombstone_capability_semantic(contract.capability_id)
        return

    await semantic.index(
        object_kind="capability_contract",
        object_id=semantic_object_id(contract),
        text=build_capability_routing_text(contract),
        semantics={
            "capability_id": contract.capability_id,
            "contract_digest": contract.contract_digest,
        },
        scope=...,
        tenant=...,
    )
```

---

## 4. Routing boundary

```python
async def route(intent: str, context: dict | None = None) -> RouteResult:
    hits = await semantic_adapter.retrieve_candidates(intent, top_k=5)
    current = revalidate_against_authority(hits)
    ranked = rank_candidates(intent, current, context or {})

    for candidate in ranked:
        bound = bind_inputs(candidate.contract.input_schema, context or {})
        if bound.is_valid:
            return RouteResult(
                status="MATCH",
                plan=(BoundCapabilityCall(
                    capability_id=candidate.contract.capability_id,
                    contract_digest=candidate.contract.contract_digest,
                    arguments=bound.arguments,
                ),),
            )

    return no_match_or_missing_input(...)
```

---

## 5. Execution boundary

```python
async def execute_call(call: BoundCapabilityCall) -> CapabilityExecutionReceipt:
    contract = authority.get(call.capability_id)

    validate_current_contract(contract, call.contract_digest)
    validate_input(contract.input_schema, call.arguments)
    await enforce_governance(contract, call.arguments)

    started = monotonic()
    try:
        output = await invoke_binding(contract, call.arguments)
    except Exception as exc:
        return failure_receipt(...)

    output_valid = validate_output(contract.output_schema, output)
    verified = (
        output_valid
        and await verify_postconditions(contract.verification, output)
    )

    return CapabilityExecutionReceipt(
        capability_id=contract.capability_id,
        contract_digest=contract.contract_digest,
        invoked=True,
        invocation_success=True,
        output_valid=output_valid,
        verification_passed=verified,
        error_category=None if verified else "VERIFICATION_FAILED",
        elapsed_ms=(monotonic() - started) * 1000,
        output=output,
    )
```

---

## 6. Stable MCP surface

```python
# Normal tools/list
tools = [
    ...existing stable native tools...,
    synth_call,          # optional explicit/operator compatibility
    borg_execute_intent,
]

# Do NOT do this in normal mode:
# tools.extend(synthesized_runtime.tool_definitions())
```

---

## 7. Capability publication transaction

```python
async def publish(self, candidate, contract):
    tx = self.prepare(candidate, contract)

    try:
        self.publish_runtime(tx)
        self.journal(tx, "runtime")

        self.publish_runtime_manifest(tx)
        self.journal(tx, "manifest")

        self.publish_authority(tx)
        self.journal(tx, "authority")

        await self.publish_semantic(tx)
        self.journal(tx, "semantic")

        return self.commit(tx)

    except Exception:
        await self.rollback_to_preimages(tx)
        raise
```

Rollback must restore preimages and respect ownership; it is not simply a sequence of `unlink()` calls.

---

# Definitions that must remain distinct

Do not conflate these concepts:

```text
DISCOVERED
    Source material was found.

CLASSIFIED CAPABILITY
    Source appears to contain executable user-facing behavior.

GENERATED/ADOPTED
    Agent_X has an implementation candidate.

FIDELITY VERIFIED
    Evidence shows the candidate performs supported behavior.

PUBLISHED
    Runtime, canonical authority, and semantic state are live consistently.

ROUTABLE
    Current canonical contract is active, complete, safe enough, and verified.

EXECUTED
    A governed invocation occurred.

VERIFIED EXECUTION
    Output/postconditions satisfied the contract.

ASSIMILATION COMPLETE
    The new ability is transparently discoverable, executable, verified,
    rollback-safe, and leaves no stale generated state.
```

---

# Final binary completion condition

The entire backlog is finished only when all of the following are true:

```text
[ ] Acceptance A passes.
[ ] Acceptance B passes.
[ ] Acceptance C passes.
[ ] Acceptance D passes.
[ ] Acceptance E passes.
[ ] Acceptance F passes.
[ ] Acceptance G passes.
[ ] Acceptance H passes.
[ ] Acceptance I passes.
[ ] Acceptance J passes.
[ ] Acceptance K passes.
[ ] Acceptance L passes.

[ ] Documents/history/metadata/assets/noise cannot become tools by accident.
[ ] Native, adopted, and synthesized abilities share CapabilityAuthority.
[ ] Every routable contract has semantic intent, schemas, effects/safety,
    execution mode, fidelity, verification, provenance, and a real binding.
[ ] Placeholder/unknown/failed implementations are not normally routable.
[ ] Semantic retrieval uses existing SemanticService.
[ ] Semantic failure has bounded deterministic fallback.
[ ] NO_MATCH is safe.
[ ] Missing required arguments are not invented.
[ ] Composition is bounded and acyclic.
[ ] Execution uses Agent_X governance.
[ ] Outputs/postconditions are verified.
[ ] Candidate fallback is bounded.
[ ] Reliability evidence is recorded.
[ ] Normal MCP exposure stays essentially constant as inventory grows.
[ ] Newly assimilated ability is usable in the same running process.
[ ] Publication is atomic or fully rolled back/recovery-blocked.
[ ] Existing polluted synthesized inventory has been migrated.
[ ] Cleanup never removes original external/user source material.
[ ] Repeated assimilation is idempotent.
[ ] Repeated cleanup is idempotent.
[ ] No stale/duplicate/orphan Assimilator-owned live artifacts remain.
```

Only then report:

```text
ASSIMILATOR COMPLETION: PASS
```


# Updated dependency chain

The completed classification and fidelity foundations are prerequisites, not
remaining work. The safe remaining implementation order is:

```text
A03 transaction-reuse audit
↓
K06-K12 canonical contract hardening
↓
P05-P06 fail-closed canonical publication proof
↓
S01-S08 SemanticService-backed capability indexing/retrieval
↓
R01-R10 transparent routing/binding/composition
↓
E04-E12 governance + verification + fallback + reliability + composed execution
↓
M01-M07 bounded MCP surface
↓
T01-T10 atomic + same-process capability publication
↓
G01-G14 migration + permanent hygiene
↓
V01-V08 final acceptance/regression/state audit
```

Do not begin destructive inventory migration before K/S/R/E/T provide a
trustworthy basis for deciding what is live, routable, verified, owned, stale,
or safe to delete.

# Current implementation ownership map

| Responsibility | Current location / target |
|---|---|
| Canonical capability identity/state | `collective_core/capability_contract.py` |
| Discovery/legacy registry | `collective_core/capabilities.py` |
| Source admission classification | `collective_core/source_classification.py` — implemented foundation |
| Behavioral fidelity | `collective_core/fidelity.py` — implemented foundation |
| Assimilation synthesis/adoption | `collective_core/assimilation_synthesis.py` |
| Main assimilation lifecycle | `collective_core/service.py` |
| Capability-specific semantic adapter | `collective_core/capability_semantic.py` — refactor to existing `SemanticService` |
| Existing semantic provider/index | `semantic/service.py`, `semantic/semantic_index.py` |
| Intent router | `collective_core/capability_router.py` — partial; extend |
| Contract-driven execution | `collective_core/capability_execution.py` — partial; extend |
| Existing governed Collective execution | `collective_core/executor.py` |
| Synthesized runtime packaging | `collective_synthesized/tool_runtime.py` |
| MCP exposure | `collective_core/agentx_mcp_server.py` |
| Capability publication transaction | add/locate clean owner; do not confuse with gap-filling transaction |
| Inventory migration/GC | add/locate clean owner; reuse current orphan-cleanup logic |
| General transaction primitives | inspect `gap_filling/transaction.py`; reuse only where semantically valid |

# Final stop condition

The backlog is complete only after all **remaining** tasks above are implemented
and the full acceptance suite is rerun. Previously completed A/C/F work must
remain green as regression coverage.

Final required invariants:

```text
[ ] Contract completeness/routability is strict and fidelity-aware.
[ ] Old authority records migrate safely without silent trust upgrades.
[ ] Native/adopted/synthesized verified abilities share one canonical authority.
[ ] Canonical publication failure cannot leave a reported successful promotion.
[ ] Capability semantic retrieval uses the existing SemanticService.
[ ] Semantic-provider failure has a bounded deterministic fallback.
[ ] Only actual routable capability contracts participate in normal routing.
[ ] NO_MATCH and MISSING_INPUT are explicit and safe.
[ ] Required arguments are never invented.
[ ] Composition is bounded, acyclic, and schema-compatible.
[ ] Capability effects execute through existing Agent_X governance/approval.
[ ] Outputs and postconditions are verified.
[ ] Candidate fallback is bounded.
[ ] Reliability evidence is recorded and used as a bounded ranking signal.
[ ] Normal MCP exposure remains essentially constant as inventory grows.
[ ] Newly assimilated verified abilities are usable in the same running process.
[ ] Capability publication is atomic or fully rolled back/recovery-blocked.
[ ] Existing polluted synthesized inventory is migrated safely.
[ ] Cleanup never removes original external/user source material.
[ ] Repeated assimilation is idempotent.
[ ] Repeated cleanup is idempotent.
[ ] No stale/duplicate/orphan Assimilator-owned live artifacts remain.
[ ] Acceptances A-L pass together.
[ ] Relevant existing regressions pass.
```

Only then report:

```text
ASSIMILATOR COMPLETION: PASS
```
