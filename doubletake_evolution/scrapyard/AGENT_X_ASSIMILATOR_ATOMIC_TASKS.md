# Agent_X Assimilator — Atomic Implementation Backlog

**Repository:** `Astrocytech/Agent_X`  
**Starting point audited:** `main` at `47dcde3ffc0d97fabd501875cb97e597a708a063`  
**Derived from:** `AGENT_X_ASSIMILATOR_REMAINING_WORK.md`  
**Goal:** convert the remaining Assimilator work into small, dependency-ordered implementation tasks with exact ownership, implementation guidance, tests, and binary definitions of done.

---

# 0. Historical execution and test boundaries

This is a historical Agent_X backlog derived from `AGENT_X_ASSIMILATOR_REMAINING_WORK.md`, audited against `Astrocytech/Agent_X` main at `47dcde3ffc0d97fabd501875cb97e597a708a063`; it is **not** a current DoubleTake implementation order or evidence of completed tests. Apply tasks in dependency order, one responsibility and focused regression at a time, after checking the current baseline. Preserve existing owners: `CapabilityAuthority`, `CapabilityRegistry`, `SemanticService`, semantic index, `collective_synthesized/tool_runtime.py`, governance, synthesis pipeline and gap-filling transactions. Extend current modules where appropriate; suggested `tools/agentx_evolve/collective_core/` modules and `tests/test_assimilator_*.py` names in the historical task bodies are proposals, not verified existing paths. Do not transplant Agent_X-specific paths into DT without independent parity checks. Preserve task-level acceptance and negative tests below.

---

# PHASE A — Baseline and guardrails

## A01 — Freeze the implementation baseline

**Depends on:** none

**Where**

Repository root.

**What**

Confirm what changed after the audited starting SHA before touching the Assimilator.

**How**

Run once:

```bash
git rev-parse HEAD
git status --short
git diff --name-status 47dcde3ffc0d97fabd501875cb97e597a708a063..HEAD
```

If HEAD moved, inspect only changes touching:

```text
tools/agentx_evolve/collective_core/
tools/agentx_evolve/collective_synthesized/
tools/agentx_evolve/semantic/
tools/agentx_evolve/gap_filling/
```

Record any task in this backlog that is already fully satisfied.

Do not reset, checkout away, or revert unrelated changes.

**Definition of done**

- Current HEAD is recorded.
- Pre-existing dirty files are known.
- No task already completed by newer code will be reimplemented.
- No repository state has been destroyed.

---

## A02 — Create one reusable mixed assimilation fixture

**Depends on:** A01

**Where**

Recommended:

```text
tests/fixtures/assimilation_mixed/
```

**What**

Create a fixture tree that contains both real executable behavior and material that must never become a normal tool.

**How**

Include at least:

```text
calculator.py              # real public callable
_internal.py               # helper-only callable
README.md
AGENTS.md
ChangeLog
settings.yaml
sample.json
logo.txt or asset-like file
notes.txt
duplicate_calculator.py    # deliberate duplicate behavior
```

Use a capability with unmistakable behavior, for example:

```python
# calculator.py
def weighted_total(values: list[int], weight: int = 3) -> int:
    return sum(values) * weight
```

Give `README.md`, `AGENTS.md`, and `ChangeLog` tempting words such as "tool", "execute", "agent", and function names so classification cannot pass merely by keyword matching.

**Definition of done**

- Fixture exists.
- It contains at least one genuinely executable user-facing behavior.
- It contains helper-only code.
- It contains metadata/history/knowledge/config/noise examples.
- It contains one deliberate duplicate.

---

## A03 — Audit reusable transaction primitives before designing publication

**Depends on:** A01

**Where**

Read:

```text
tools/agentx_evolve/gap_filling/transaction.py
tools/agentx_evolve/gap_filling/tests/test_gap_filling_transaction.py
```

**What**

Determine exactly which hardened transaction primitives can be reused for Assimilator publication.

**How**

Write a short code comment/design note near the eventual publication transaction implementation identifying whether the following are reusable:

```text
preimage/postimage validation
journal persistence
receipt validation
fail-closed mutation
rollback
reconciliation
mode/hash verification
transaction ownership evidence
```

Do **not** import the entire gap-filling transaction blindly. Capability publication has different state:

```text
runtime module
manifest row
CapabilityAuthority contract
semantic index record
```

Reuse only primitives whose contracts match.

**Definition of done**

- Reuse decision exists in code/design comments.
- No duplicate general transaction primitive is created without justification.
- Gap-filling `GapApplyTransaction` is not incorrectly treated as already solving capability publication.

---

# PHASE C — Source classification and admission

## C01 — Extend canonical `SourceClass`

**Depends on:** A01

**Where**

```text
tools/agentx_evolve/collective_core/capability_contract.py
tests/test_assimilator_capability_contract.py
```

**What**

Extend the current two-value classification:

```python
CAPABILITY
KNOWLEDGE
```

to support the remaining source roles.

**How**

Target semantics:

```python
class SourceClass(str, Enum):
    CAPABILITY = "capability"
    KNOWLEDGE = "knowledge"
    METADATA = "metadata"
    HISTORY = "history"
    ASSET_CONFIG = "asset_config"
    NOISE = "noise"

    @classmethod
    def values(cls) -> set[str]:
        return {item.value for item in cls}
```

Keep existing persisted strings valid.

Do not rename `capability` or `knowledge`.

**Definition of done**

- All six semantic classes are representable.
- Existing `capability`/`knowledge` persisted values still parse.
- Unit test verifies enum values.

---

## C02 — Add a deterministic admission decision type

**Depends on:** C01

**Where**

Recommended new file:

```text
tools/agentx_evolve/collective_core/source_classification.py
```

**What**

Represent classification as a decision with evidence, rather than returning a bare string.

**How**

Suggested shape:

```python
from dataclasses import dataclass

@dataclass(frozen=True)
class AdmissionDecision:
    source_class: SourceClass
    executable_candidate: bool
    rationale: str
```

Optional useful fields:

```python
confidence: float | None
user_facing_symbols: tuple[str, ...]
```

Do not make confidence the gate unless it has a deterministic meaning.

**Definition of done**

- Callers can distinguish source class from executable candidacy.
- Every decision has a human-readable rationale.
- Tests can assert *why* a fixture was rejected.

---

## C03 — Implement path/content-role classification

**Depends on:** C02, A02

**Where**

```text
tools/agentx_evolve/collective_core/source_classification.py
tests/test_assimilator_source_classification.py
```

**What**

Classify obvious non-executable source roles before synthesis.

**How**

Use deterministic high-confidence rules first.

Examples:

```text
README*                    -> KNOWLEDGE
AGENTS.md                  -> METADATA
CHANGELOG*, ChangeLog,
Changes, HISTORY*          -> HISTORY
LICENSE*, COPYING*         -> METADATA
*.yaml/*.yml config-like   -> ASSET_CONFIG
images/assets/static       -> ASSET_CONFIG
cache/temp/generated junk  -> NOISE
```

Do not treat extension alone as sufficient for all files. A YAML file could theoretically represent a deliberate executable workflow, so allow later explicit evidence to override a generic asset/config classification.

Do not feed untrusted prose into the coding agent as instructions.

**Definition of done**

The mixed fixture deterministically classifies:

- README as non-capability;
- AGENTS notes as non-capability;
- ChangeLog as non-capability;
- config/data/assets as non-capability unless explicit callable semantics exist;
- executable source is not rejected merely because it is unfamiliar.

---

## C04 — Detect actual callable behavior in source discovery

**Depends on:** C03

**Where**

Primarily:

```text
tools/agentx_evolve/collective_core/capabilities.py
tools/agentx_evolve/collective_core/source_classification.py
```

**What**

Separate “source file exists” from “source contains candidate behavior.”

**How**

Reuse the existing language/symbol discovery in `capabilities.py`.

For code source, provide classification with evidence such as:

```text
top-level public functions
public classes with callable entry points
CLI entry points
declared procedures
documented API routes
```

Static source previews and opaque binary records are not executable evidence.

A file that yields only:

```text
constants
private helpers
data structures
test fixtures
internal-only symbols
```

must not automatically become a user-facing capability.

**Definition of done**

- Real callable fixture yields `executable_candidate=True`.
- Helper-only fixture does not become a dedicated user-facing routable capability.
- No behavior is inferred solely from a `.py` extension.

---

## C05 — Add user-facing symbol filtering

**Depends on:** C04

**Where**

```text
tools/agentx_evolve/collective_core/source_classification.py
```

and, only where necessary:

```text
tools/agentx_evolve/collective_core/capabilities.py
```

**What**

Prevent every internal function/class discovered in executable source from becoming a public capability.

**How**

Use conservative evidence:

- names beginning with `_` are internal by default;
- test functions/classes are not user-facing;
- obvious serializer/parser/helper internals are not automatically public;
- module public API declarations such as `__all__`, CLI entry points, documented examples, or source tests may provide positive evidence;
- if uncertain, keep the symbol as supporting source rather than making it routable.

Do not build a giant heuristic taxonomy. Fail safe.

**Definition of done**

- `_internal.py` fixture does not produce a normal routable ability.
- `weighted_total` does.
- The classifier can preserve helper provenance as supporting material without exposing it.

---

## C06 — Wire admission decisions into `assimilate_directory()`

**Depends on:** C03, C04, C05

**Where**

```text
tools/agentx_evolve/collective_core/capabilities.py
```

**What**

Ensure the central classification is determined before authority synchronization.

**Current seam**

`assimilate_directory()` discovers legacy `Capability` items and can call:

```python
authority.register_from_registry_item(...)
```

The current path is too coarse and authority-sync failures can be swallowed.

**How**

Pass the explicit `AdmissionDecision` or equivalent source class into authority synchronization.

Conceptually:

```python
decision = classify_discovered_item(
    path=...,
    kind=registered_cap.kind,
    name=registered_cap.name,
    description=registered_cap.description,
    ...
)

authority.register_from_registry_item(
    registered_cap,
    executable=False,  # discovery is not promotion
    source_class=decision.source_class.value,
    admission=decision,  # if signature is extended
)
```

Discovery alone should remain non-executable. Actual executable promotion happens later after fidelity verification.

**Definition of done**

- Every discovered item synchronized to the authority has an explicit central classification.
- Discovery does not make code routable merely because it has a tool-like `CapabilityKind`.
- Non-executable source remains non-routable.

---

## C07 — Stop silently swallowing authority synchronization failure

**Depends on:** C06

**Where**

```text
tools/agentx_evolve/collective_core/capabilities.py
```

**What**

Replace broad silent failure around canonical authority synchronization with observable bounded failure handling.

**How**

Do not use:

```python
try:
    authority.register_from_registry_item(...)
except Exception:
    pass
```

Prefer one of:

- propagate the exception if canonical synchronization is required for the operation;
- or record a structured per-item failure in assimilation results and mark the item unpublished/non-routable.

Example result extension:

```python
{
    "discovered": ...,
    "registered": ...,
    "authority_sync_failures": [
        {"capability": name, "error": str(exc)}
    ],
}
```

Do not claim assimilation success for an executable promotion whose canonical publication failed.

**Definition of done**

- Forced authority failure is visible to caller/tests.
- No executable capability can be reported fully integrated while canonical registration silently failed.

---

## C08 — Prove Acceptance A

**Depends on:** C01-C07

**Where**

```text
tests/test_assimilator_source_classification.py
```

**What**

Implement the mixed-fixture classification acceptance test.

**How**

Assert the fixture produces:

```text
weighted_total        -> executable candidate
_internal helper      -> not normal executable
README                -> non-executable
AGENTS.md             -> non-executable
ChangeLog             -> non-executable
settings.yaml         -> non-executable
sample.json           -> non-executable
asset                 -> non-executable
```

Also assert none of the non-executable items has a routable canonical binding.

**Definition of done**

Acceptance A passes and fails if any document/history/config/noise fixture becomes routable.

---

# PHASE K — Complete the canonical capability contract

## K01 — Add canonical `ExecutionMode`

**Depends on:** C01

**Where**

```text
tools/agentx_evolve/collective_core/capability_contract.py
```

**What**

Represent where executable behavior comes from.

**How**

Suggested values:

```python
class ExecutionMode(str, Enum):
    NATIVE = "native"
    ADOPTED = "adopted"
    SYNTHESIZED = "synthesized"

    @classmethod
    def values(cls) -> set[str]:
        return {item.value for item in cls}
```

If the repository already has a semantically equivalent enum by implementation time, reuse it.

**Definition of done**

Native, adopted, and synthesized behavior can be distinguished canonically without inspecting tags or paths.

---

## K02 — Add canonical `FidelityState`

**Depends on:** C01

**Where**

```text
tools/agentx_evolve/collective_core/capability_contract.py
```

**What**

Represent whether the implementation has evidence that it actually reproduces useful behavior.

**How**

Suggested:

```python
class FidelityState(str, Enum):
    VERIFIED = "verified"
    PARTIAL = "partial"
    PLACEHOLDER = "placeholder"
    FAILED = "failed"
    UNKNOWN = "unknown"
```

**Definition of done**

All five states persist and round-trip.

---

## K03 — Add semantic intent fields to `CapabilityContract`

**Depends on:** K01, K02

**Where**

```text
tools/agentx_evolve/collective_core/capability_contract.py
```

**What**

Add the semantic material required for routing.

**How**

Extend `__slots__`, `__init__`, `make`, `to_dict`, `from_dict`, and digest input with:

```text
intents
examples
```

Retain existing:

```text
aliases
description
```

Suggested Python types:

```python
intents: tuple[str, ...]
examples: tuple[str, ...]
```

Normalize whitespace and deterministic ordering where appropriate.

Do not store giant source documents here.

**Definition of done**

- Contract can explain what user needs it satisfies.
- Intents/examples persist and are digest-covered.
- Round-trip test passes.

---

## K04 — Add execution-policy metadata

**Depends on:** K03

**Where**

```text
tools/agentx_evolve/collective_core/capability_contract.py
```

**What**

Add structured fields required before execution.

**How**

Add canonical equivalents of:

```text
effects
requirements
safety
execution_mode
fidelity_state
verification
```

Use JSON-compatible dictionaries/tuples so persistence remains straightforward.

Example conceptual defaults for non-routable legacy records:

```python
effects={}
requirements={}
safety={"classification": "unknown"}
execution_mode=""
fidelity_state=FidelityState.UNKNOWN.value
verification={}
```

Do not invent `VERIFIED` defaults for old records.

**Definition of done**

All required metadata persists and contributes to contract identity where appropriate.

---

## K05 — Decide and document executable-target representation

**Depends on:** K04

**Where**

```text
tools/agentx_evolve/collective_core/capability_contract.py
```

**What**

Avoid representing the same executable target in two competing fields.

**Current seam**

The contract already has:

```text
bindings
```

with targets such as native or legacy bindings.

**How**

Prefer keeping `bindings` as the canonical executable-target representation unless there is a concrete requirement it cannot express.

Add a helper/property such as:

```python
@property
def primary_binding(self) -> str | None:
    return self.bindings[0] if self.bindings else None
```

If multiple bindings are supported, document ordering/selection semantics.

Do **not** add `executable_target` merely because the previous prose used that phrase if `bindings` already satisfies it.

**Definition of done**

- There is one unambiguous canonical way to resolve executable target(s).
- No duplicated target fields can drift independently.

---

## K06 — Add contract validation helpers

**Depends on:** K03-K05

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

**Depends on:** K03-K07

**Where**

```text
tools/agentx_evolve/collective_core/capability_contract.py
tests/test_assimilator_capability_contract.py
```

**What**

Existing `capability_authority.json` files created with the old schema must still load.

**How**

In `from_dict()`/authority loading:

- default missing new fields safely;
- use `UNKNOWN` fidelity;
- do not infer execution mode from arbitrary tags unless deterministic;
- leave old incomplete executable records non-routable until enriched/revalidated;
- preserve existing capability IDs where possible;
- verify old digest according to its old schema before migration, rather than recomputing it as though new fields had always existed.

If needed, bump persisted authority schema version and implement explicit migration.

**Definition of done**

A fixture representing the old authority format loads successfully, retains identity/provenance, and is not silently upgraded to verified/routable.

---

## K09 — Enrich native seed contracts

**Depends on:** K07, K08

**Where**

```text
tools/agentx_evolve/collective_core/capability_contract.py
```

Function:

```text
seed_core_contracts()
```

**What**

Update current native `echo`, `add`, and `blob_put` seed contracts so they satisfy the complete contract.

**How**

For each, provide:

```text
intents
examples
input_schema
output_schema
effects
requirements
safety
execution_mode=NATIVE
fidelity_state=VERIFIED
verification
native binding
provenance
```

Example for `add`:

```python
intents=("add numbers", "calculate a sum", "sum numeric values")
execution_mode=ExecutionMode.NATIVE.value
fidelity_state=FidelityState.VERIFIED.value
verification={"type": "output_schema"}
```

Do not use long natural-language blobs.

**Definition of done**

`echo`, `add`, and `blob_put` are valid routable canonical contracts under the new rules.

---

## K10 — Make legacy registry adaptation safe by default

**Depends on:** K07, C06

**Where**

```text
tools/agentx_evolve/collective_core/capability_contract.py
```

Method:

```text
register_from_registry_item()
```

**What**

Ensure legacy discovery cannot accidentally manufacture a verified executable contract.

**How**

Default legacy sync to:

```text
fidelity_state=UNKNOWN
execution_mode unset/unknown unless deterministically known
no executable binding unless this is a later verified promotion
```

If `executable=True` remains supported for compatibility, require explicit:

```text
binding
execution_mode
fidelity_state
intents
verification
```

or keep the result non-routable.

**Definition of done**

Calling the adapter on a legacy `TOOL` item without verification evidence cannot create a routable contract.

---

## K11 — Add bounded authority query for routable contracts

**Depends on:** K07

**Where**

```text
tools/agentx_evolve/collective_core/capability_contract.py
```

**What**

Give semantic fallback/routing a canonical way to enumerate only eligible abilities.

**How**

Add something like:

```python
def list_routable(self, *, limit: int = 1000) -> list[CapabilityContract]:
    return [
        c for c in self.list(...)
        if c.is_routable
    ][:limit]
```

If the authority already has a clean equivalent by implementation time, reuse it.

**Definition of done**

Router/index code does not have to duplicate lifecycle/fidelity gating.

---

## K12 — Prove Acceptance B

**Depends on:** K01-K11

**Where**

```text
tests/test_assimilator_capability_contract.py
```

**What**

Test complete contracts and migration.

**How**

Cover:

1. new contract round trip;
2. digest stability;
3. old authority data migration;
4. UNKNOWN legacy contract non-routable;
5. full VERIFIED contract routable;
6. missing intent/schema/verification non-routable;
7. native seeds complete.

**Definition of done**

Acceptance B passes.

---

# PHASE F — Behavioral fidelity

## F01 — Add a placeholder-behavior detector

**Depends on:** K02, K07

**Where**

```text
tools/agentx_evolve/collective_core/assimilation_synthesis.py
tests/test_assimilator_fidelity.py
```

**What**

Detect obvious generated wrappers that pretend to implement behavior.

**How**

Add a focused helper such as:

```python
def detect_placeholder_behavior(
    code: str,
    *,
    expected_behavior: object | None = None,
) -> tuple[bool, tuple[str, ...]]:
    ...
```

Flag high-confidence patterns such as:

```text
returns {"processed": True} regardless of input
returns only "not implemented"/metadata
dummy pass-through where source behavior is non-pass-through
canned success dictionaries
function bodies containing only pass/ellipsis
```

Important: do **not** reject a legitimate echo capability merely because it echoes input. Compare against expected/source behavior when behavior itself is echo-like.

**Definition of done**

Obvious fake wrapper fixture is detected with a concrete reason and legitimate echo behavior is not generically banned.

---

## F02 — Normalize existing synthesis evidence

**Depends on:** F01

**Where**

```text
tools/agentx_evolve/collective_core/assimilation_synthesis.py
```

and the relevant path in:

```text
tools/agentx_evolve/collective_core/service.py
```

**What**

Convert existing compile/source/reference/smoke-test results into structured fidelity evidence.

**How**

Reuse existing structures such as:

```text
GeneratedModule
TestSpec
derive_reference_tests(...)
synthesis_status
synthesis_reason
fidelity_failures
```

Produce an evidence structure conceptually like:

```python
{
    "compile": {"passed": True},
    "reference_tests": {"passed": 4, "failed": 0},
    "source_tests": {"passed": 2, "failed": 0},
    "placeholder_check": {"passed": True},
}
```

Do not create a separate test runner if the pipeline already has one.

**Definition of done**

One generated/adopted candidate has one structured evidence record sufficient to explain its fidelity state.

---

## F03 — Implement deterministic fidelity-state assignment

**Depends on:** F02

**Where**

```text
tools/agentx_evolve/collective_core/assimilation_synthesis.py
```

**What**

Map evidence to canonical `FidelityState`.

**How**

Conservative rule example:

```text
placeholder detected                       -> PLACEHOLDER
behavior/reference test fails              -> FAILED
implementation compiles but behavior unknown -> UNKNOWN
explicit supported subset validated        -> PARTIAL
strong behavior/reference evidence passes  -> VERIFIED
```

Do not assign VERIFIED from compile/import success alone.

**Definition of done**

Same evidence always produces same fidelity state and every state change has an evidence reason.

---

## F04 — Define requirements for `PARTIAL`

**Depends on:** F03

**Where**

```text
tools/agentx_evolve/collective_core/assimilation_synthesis.py
tools/agentx_evolve/collective_core/capability_contract.py
```

**What**

Prevent “partial” from becoming a euphemism for unknown.

**How**

Require explicit supported behavior in contract/evidence, for example:

```python
verification={
    "type": "reference_subset",
    "supported_cases": [...],
}
```

or an equivalent structured definition.

If a supported subset cannot be described, use `UNKNOWN`, not `PARTIAL`.

**Definition of done**

A PARTIAL contract identifies what subset is actually supported.

---

## F05 — Strengthen reference-behavior comparison

**Depends on:** F02

**Where**

```text
tools/agentx_evolve/collective_core/assimilation_synthesis.py
```

**What**

Use existing source tests/examples/docstrings/reference execution to prove behavior when available.

**How**

Extend/reuse:

```text
derive_reference_tests(...)
```

Prefer evidence in order:

```text
source tests
documented executable examples
known input/output cases
reference implementation
explicit invariants/postconditions
```

Use syntax/import success only as preliminary evidence.

Keep tests bounded.

**Definition of done**

A behaviorally wrong implementation that compiles cannot receive VERIFIED if reference evidence contradicts it.

---

## F06 — Gate promotion on fidelity

**Depends on:** F03, F04, F05

**Where**

Primarily:

```text
tools/agentx_evolve/collective_core/service.py
```

and canonical contract construction path.

**What**

Do not publish a normal routable executable ability unless fidelity is VERIFIED or explicitly valid PARTIAL.

**How**

Before canonical promotion:

```python
if fidelity_state not in {
    FidelityState.VERIFIED.value,
    FidelityState.PARTIAL.value,
}:
    # preserve evidence/source, but do not publish as routable
```

A candidate may remain staged/recorded as failed knowledge for diagnosis without becoming live.

**Definition of done**

PLACEHOLDER/FAILED/UNKNOWN candidates cannot become normal routable abilities.

---

## F07 — Prove Acceptance C

**Depends on:** F01-F06

**Where**

```text
tests/test_assimilator_fidelity.py
```

**What**

Create two explicit fixtures:

1. fake wrapper;
2. faithful implementation.

**How**

Fake:

```python
def weighted_total(values, weight=3):
    return {"processed": True}
```

Faithful:

```python
def weighted_total(values, weight=3):
    return sum(values) * weight
```

Use reference cases.

**Definition of done**

- Fake wrapper does not become routable.
- Faithful implementation reaches VERIFIED.
- Acceptance C passes.

---

# PHASE P — Publish verified abilities into the canonical authority

## P01 — Add a single contract builder for promoted abilities

**Depends on:** K12, F07

**Where**

Recommended in:

```text
tools/agentx_evolve/collective_core/capability_contract.py
```

or a small focused builder module.

**What**

Translate an adopted/synthesized verified implementation into one complete `CapabilityContract`.

**How**

Builder inputs should include:

```text
name
description
intents
examples
input/output schemas
binding
provenance
execution mode
fidelity evidence
effects/safety/requirements
verification
aliases/tags
```

Do not let `service.py` construct partially different contract dictionaries in several branches.

**Definition of done**

One function builds canonical contracts for both ADOPTED and SYNTHESIZED modes with deterministic validation.

---

## P02 — Publish synthesized modules to `CapabilityAuthority`

**Depends on:** P01

**Where**

```text
tools/agentx_evolve/collective_core/service.py
```

at the existing synthesized-module promotion path.

**What**

After a synthesized candidate passes fidelity, publish its canonical contract in addition to runtime packaging/legacy compatibility registration.

**How**

Current runtime publication already writes/publishes synthesized modules and registers them in the synthesized manifest/legacy capability registry.

Add canonical upsert using the builder from P01.

Use a binding that the eventual executor can resolve, for example an explicit synthesized binding format already consistent with repository conventions.

Do not mark the contract live/routable before runtime target exists.

**Definition of done**

A verified synthesized fixture appears in `CapabilityAuthority` as an active complete SYNTHESIZED contract.

---

## P03 — Publish adopted implementations to `CapabilityAuthority`

**Depends on:** P01

**Where**

```text
tools/agentx_evolve/collective_core/service.py
tools/agentx_evolve/collective_core/assimilation_synthesis.py
```

**What**

Make successful adoption first-class in the same canonical inventory.

**How**

When an `AdoptionSpec` succeeds, build a contract with:

```text
execution_mode=ADOPTED
real adopted binding
fidelity evidence
```

Do not masquerade adopted behavior as synthesized behavior solely because a small adapter module is generated.

**Definition of done**

A verified adopted fixture and a verified synthesized fixture appear side by side in one authority with distinct execution modes.

---

## P04 — Keep legacy registry and synthesized manifest non-authoritative

**Depends on:** P02, P03

**Where**

Comments/API boundaries in:

```text
tools/agentx_evolve/collective_core/capabilities.py
tools/agentx_evolve/collective_synthesized/tool_runtime.py
```

**What**

Make architectural ownership explicit.

**How**

Canonical semantics:

```text
CapabilityAuthority -> can this ability be semantically routed/executed?
CapabilityRegistry  -> discovery/provenance/compatibility
synth manifest      -> synthesized runtime packaging/lookup
```

Ensure new routing code never selects executable abilities directly from the legacy registry or manifest.

**Definition of done**

There is one semantic/executable authority and tests do not route from legacy inventory.

---

## P05 — Make canonical publication failure observable

**Depends on:** P02, P03

**Where**

```text
tools/agentx_evolve/collective_core/service.py
```

**What**

A runtime module cannot be reported as successfully integrated if canonical publication fails.

**How**

Until the full transaction in Phase T exists, make failure explicit and clean up the just-created transaction-owned runtime artifact where safely possible.

Later T-phase work will replace this provisional handling with full rollback.

**Definition of done**

Injected `CapabilityAuthority.upsert()` failure causes assimilation to report failure/non-promotion rather than success.

---

## P06 — Prove one-authority inventory

**Depends on:** P02-P05

**Where**

```text
tests/test_assimilator_publication.py
```

**What**

Test native, adopted, and synthesized capability presence.

**How**

Seed native contracts, publish one adopted fixture and one synthesized fixture.

Assert all are queryable through `CapabilityAuthority`.

**Definition of done**

One canonical query returns all three execution modes and only complete verified/partial ones are routable.

---

# PHASE S — Semantic capability indexing

## S01 — Add deterministic routing-text builder

**Depends on:** K12

**Where**

Recommended:

```text
tools/agentx_evolve/collective_core/capability_semantic.py
```

**What**

Create concise text for semantic indexing from canonical contract fields.

**How**

Example:

```python
def build_capability_routing_text(contract: CapabilityContract) -> str:
    parts = [
        contract.name,
        *contract.intents,
        *contract.aliases,
        contract.description,
        f"inputs: {sorted(contract.input_schema.get('properties', {}))}",
        f"outputs: {contract.output_schema}",
        f"effects: {contract.effects}",
        f"requirements: {contract.requirements}",
    ]
    return "\n".join(str(p) for p in parts if p)
```

Keep deterministic ordering.

Do not include raw source files, books, README bodies, or giant provenance text.

**Definition of done**

Same contract yields byte-identical routing text across calls.

---

## S02 — Add semantic index adapter for capability contracts

**Depends on:** S01

**Where**

```text
tools/agentx_evolve/collective_core/capability_semantic.py
```

**What**

Wrap the existing `SemanticService` for capability-specific indexing/search.

**How**

Use:

```text
object_kind="capability_contract"
object_id=<stable capability id + revision/digest strategy>
```

Store semantics sufficient to recover:

```text
capability_id
contract_digest
authority revision if useful
```

Do not create another embedding provider/index database.

**Definition of done**

One active routable contract can be indexed and found through the existing semantic service.

---

## S03 — Index only routable contracts

**Depends on:** S02, K11

**Where**

```text
tools/agentx_evolve/collective_core/capability_semantic.py
```

**What**

Prevent knowledge, stale, placeholder, failed, or incomplete contracts from becoming routing candidates.

**How**

Before indexing:

```python
if not contract.is_routable:
    tombstone_if_present(...)
    return
```

**Definition of done**

A KNOWLEDGE and PLACEHOLDER fixture never appears in active capability search results.

---

## S04 — Connect authority invalidation callbacks to semantic maintenance

**Depends on:** S03

**Where**

```text
tools/agentx_evolve/collective_core/capability_semantic.py
```

plus service initialization where `CapabilityAuthority` is created.

**What**

Keep index state synchronized with authority lifecycle changes.

**How**

Reuse `CapabilityAuthority` invalidation/revision callbacks.

On change:

- fetch current contract;
- index/reindex if routable;
- tombstone old semantic record if superseded/retired/non-routable;
- avoid reindex when digest unchanged.

Use existing semantic tombstone semantics.

**Definition of done**

Changing an active contract to RETIRED removes it from active semantic retrieval without restarting the process.

---

## S05 — Make indexing idempotent

**Depends on:** S04

**Where**

```text
tools/agentx_evolve/collective_core/capability_semantic.py
tests/test_assimilator_semantic.py
```

**What**

Repeated synchronization must not create multiple active semantic rows for the same current contract.

**How**

Use a deterministic object ID strategy or tombstone-and-replace keyed by contract digest.

Assert:

```text
same authority state synchronized twice
=> one active semantic representation
```

**Definition of done**

Second index sync creates no duplicate active result.

---

## S06 — Implement bounded lexical/structured fallback

**Depends on:** K11, S01

**Where**

```text
tools/agentx_evolve/collective_core/capability_semantic.py
```

**What**

When semantic provider/search fails, retrieve obvious matches deterministically from current authority.

**How**

Score only active routable contracts using compact evidence:

```text
exact name match
alias match
intent token overlap
description overlap
input-property compatibility
```

Example simple scoring:

```python
score = 0
if q == name: score += 100
if q in aliases: score += 80
score += 10 * token_overlap(q, intents)
score += 2 * token_overlap(q, description)
```

Bound the scanned authority list and return top-K.

Do not invent a second semantic database.

**Definition of done**

With semantic provider forced to fail, a request containing an obvious capability alias/name/intent still retrieves the correct candidate.

---

## S07 — Add bounded candidate retrieval API

**Depends on:** S02, S06

**Where**

```text
tools/agentx_evolve/collective_core/capability_semantic.py
```

**What**

Expose one retrieval function for the router.

**How**

Suggested:

```python
async def retrieve_candidates(
    intent: str,
    *,
    top_k: int = 5,
) -> list[CapabilityCandidate]:
    ...
```

Hard-cap `top_k`, for example:

```python
top_k = max(1, min(top_k, 10))
```

Return canonical IDs/digests and relevance evidence, not full inventory dumps.

**Definition of done**

Router can request at most a small bounded candidate set through one API.

---

## S08 — Prove Acceptance D

**Depends on:** S01-S07

**Where**

```text
tests/test_assimilator_semantic.py
```

**What**

Test semantic and fallback retrieval among distractors.

**How**

Index:

- weighted-total capability;
- unrelated formatter;
- unrelated file counter;
- several distractors.

Natural language:

```text
"multiply the sum of these values by a weight"
```

must retrieve weighted-total near/top first.

Then force semantic-provider failure and use an obvious alias/intent query.

**Definition of done**

Acceptance D passes in both semantic and fallback modes.

---

# PHASE R — Transparent capability routing

## R01 — Define router result types

**Depends on:** S07

**Where**

Recommended:

```text
tools/agentx_evolve/collective_core/capability_router.py
```

**What**

Create explicit typed outcomes rather than returning ad-hoc dictionaries.

**How**

Suggested shape:

```python
from dataclasses import dataclass
from typing import Literal

@dataclass(frozen=True)
class BoundCapabilityCall:
    capability_id: str
    contract_digest: str
    arguments: dict[str, object]

@dataclass(frozen=True)
class RouteResult:
    status: Literal["MATCH", "NO_MATCH", "MISSING_INPUT"]
    plan: tuple[BoundCapabilityCall, ...] = ()
    missing: tuple[str, ...] = ()
    rationale: str = ""
```

Add candidate/ranking types if useful.

**Definition of done**

Router outcomes distinguish no match from missing required input.

---

## R02 — Retrieve candidates from semantic adapter only

**Depends on:** R01

**Where**

```text
tools/agentx_evolve/collective_core/capability_router.py
```

**What**

Make ordinary user intent the router input.

**How**

Primary entry:

```python
async def route(
    intent: str,
    *,
    context: dict[str, object] | None = None,
) -> RouteResult:
    candidates = await semantic.retrieve_candidates(intent, top_k=...)
```

Do not require:

```text
module name
source path
synth_* tool name
function name
```

**Definition of done**

Caller can route using only ordinary outcome language/context.

---

## R03 — Revalidate candidate canonical state

**Depends on:** R02

**Where**

```text
tools/agentx_evolve/collective_core/capability_router.py
```

**What**

Do not trust stale semantic hits.

**How**

For each semantic candidate:

```python
contract = authority.get(capability_id)
if not contract:
    skip
if contract.contract_digest != hit.contract_digest:
    refresh/skip stale hit
if not contract.is_routable:
    skip
```

**Definition of done**

A retired or changed contract cannot be routed because an old semantic record still exists.

---

## R04 — Add understandable candidate ranking

**Depends on:** R03

**Where**

```text
tools/agentx_evolve/collective_core/capability_router.py
```

**What**

Rank the bounded candidate set using transparent signals.

**How**

Use a small scoring structure, for example:

```text
semantic relevance
fidelity preference: VERIFIED > PARTIAL
input compatibility
reliability evidence
safety/risk penalty
```

Do not create a giant learned score.

Keep score components available in debug evidence.

**Definition of done**

Given two known candidates, a test can explain why one ranks above the other.

---

## R05 — Implement schema-driven argument binding

**Depends on:** R04

**Where**

```text
tools/agentx_evolve/collective_core/capability_router.py
```

**What**

Bind available user/context values to contract `input_schema`.

**How**

Support JSON-schema essentials used by Agent_X:

```text
type
properties
required
additionalProperties
arrays/scalars
basic enums if present
```

Rules:

- never invent missing required values;
- reject unknown fields when `additionalProperties=False`;
- validate types;
- allow defaults only if the canonical schema explicitly defines them.

If a general schema validator already exists in Agent_X, reuse it.

**Definition of done**

Required missing fields produce `MISSING_INPUT`; invalid types do not execute.

---

## R06 — Add explicit `NO_MATCH`

**Depends on:** R04

**Where**

```text
tools/agentx_evolve/collective_core/capability_router.py
```

**What**

Permit safe refusal when no candidate is relevant enough.

**How**

Use deterministic minimum evidence such as:

- semantic result above configured relevance threshold; or
- explicit lexical/alias/intent evidence in fallback mode.

Do not select the least-bad candidate simply because top-K is non-empty.

**Definition of done**

An unrelated request produces `NO_MATCH` and an empty plan.

---

## R07 — Produce single-capability execution plans

**Depends on:** R05, R06

**Where**

```text
tools/agentx_evolve/collective_core/capability_router.py
```

**What**

Turn the best valid candidate into a bound call.

**How**

Populate:

```text
capability_id
current contract_digest
bound arguments
```

Do not embed mutable executable code in the plan.

**Definition of done**

A valid intent + complete input yields exactly one bound call for the expected capability.

---

## R08 — Add bounded composition search

**Depends on:** R07

**Where**

```text
tools/agentx_evolve/collective_core/capability_router.py
```

**What**

Allow a short chain when no single capability can satisfy the task.

**How**

Constraints:

```text
max steps <= 4
no repeated capability ID in same plan unless explicitly safe
no graph cycles
output/input schema compatibility required
effects/safety checked at each edge
```

Prefer single capability whenever sufficient.

Do not build an unbounded autonomous planner.

**Definition of done**

A two-step fixture can be planned and a cyclic fixture is rejected.

---

## R09 — Add output-to-input binding for composed plans

**Depends on:** R08

**Where**

```text
tools/agentx_evolve/collective_core/capability_router.py
```

**What**

Represent how output of step N supplies input to step N+1.

**How**

Use explicit binding expressions/keys rather than natural-language inference at execution time.

Example conceptual shape:

```python
{
    "from_step": 0,
    "output_path": "$.value",
    "to_argument": "text",
}
```

Keep the supported mapping syntax small.

**Definition of done**

A composed plan explicitly states every cross-step data dependency.

---

## R10 — Prove Acceptance E and routing core

**Depends on:** R01-R09

**Where**

```text
tests/test_assimilator_router.py
```

**What**

Test:

- ordinary intent;
- candidate ranking;
- argument binding;
- missing input;
- invalid input;
- `NO_MATCH`;
- bounded composition;
- cycle rejection.

**Definition of done**

Acceptance E passes and composition planning has focused tests.

---

# PHASE E — Governed execution, verification, fallback, reliability

## E01 — Add canonical binding resolver

**Depends on:** P06, R10

**Where**

Recommended:

```text
tools/agentx_evolve/collective_core/capability_execution.py
```

**What**

Resolve current contract bindings to existing execution paths.

**How**

Support at least:

```text
native:...
adopted:... or equivalent
synthesized/runtime manifest binding
```

Reuse:

```text
collective_synthesized/tool_runtime.py
existing native Collective execution
existing adopted execution mechanism
```

Do not import arbitrary files from provenance just because a path exists.

**Definition of done**

Each execution mode resolves through an explicit governed binding type.

---

## E02 — Revalidate contract immediately before execution

**Depends on:** E01

**Where**

```text
tools/agentx_evolve/collective_core/capability_execution.py
```

**What**

Protect against route/execute races.

**How**

Before invoking:

```python
current = authority.get(call.capability_id)
if current is None:
    fail("CONTRACT_MISSING")
if current.contract_digest != call.contract_digest:
    fail("CONTRACT_CHANGED")
if not current.is_routable:
    fail("CONTRACT_NOT_ROUTABLE")
```

Replan/fallback can happen above this layer.

**Definition of done**

Changing/retiring a contract after routing but before execution prevents stale execution.

---

## E03 — Revalidate input schema at execution boundary

**Depends on:** E02

**Where**

```text
tools/agentx_evolve/collective_core/capability_execution.py
```

**What**

Treat router binding as a proposal, not a security boundary.

**How**

Validate again against the current contract schema before actual invocation.

**Definition of done**

Tampering with a bound call after routing cannot bypass schema validation.

---

## E04 — Route effects through existing governance/approval

**Depends on:** E03

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

**Depends on:** E01-E11

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

## M01 — Add stable `borg_execute_intent` MCP tool

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

**Depends on:** M01-M06

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

## T01 — Define Assimilator publication transaction state

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

**Depends on:** T04-T06

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

**Depends on:** T05-T08

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

## G01 — Build an inventory scanner over all Assimilator-owned state

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

**Depends on:** G01, C08, F07

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

**Depends on:** G02-G05

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

**Depends on:** G02, F07

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

**Depends on:** G08-G11

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

**Depends on:** G01-G13

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
