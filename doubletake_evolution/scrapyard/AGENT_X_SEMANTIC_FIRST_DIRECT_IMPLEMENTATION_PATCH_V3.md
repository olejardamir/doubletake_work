# AGENT_X — SEMANTIC-FIRST FINAL REMAINING IMPLEMENTATION PATCH V3
## SUPERSEDES THE PREVIOUS SEMANTIC-FIRST PATCH
## VERIFIED BASELINE: `Astrocytech/Agent_X` `main`
## BASELINE COMMIT: `5abc9a0c4313f536446e90e390da33a223cdf3d1`

This is a **direct implementation prompt**.

The previous implementation attempt made substantial progress, but the claim that the task is complete is still false.

Do NOT re-audit the entire repository.
Do NOT redesign PR-43.
Do NOT redo defects that are already fixed.
Do NOT weaken production invariants or move forbidden code into helper functions just to satisfy literal searches.

Fix only the remaining verified defects in this document.

When the locally implementable defects below are fixed, run the focused proof and report the exact result.

---

# 0. CURRENT VERIFIED STATUS

The following work is already complete enough for this patch and must NOT be reopened unless a focused test proves a regression.

Current `main` already has:

```text
production semantic_binding.py no longer importing FakeEmbeddingProvider
build_governed_embedding_service(...) used by production semantic binding
UnifiedRuntimeSemanticAuthority typed authority object
compute_workspace_epoch(...) for real workspace identity
embedding revision used for embedding cache epoch
bind_accepted_runtime(...) used
structural plumber graph bound
self-upgrade rollout variable removed from Unified Runtime
calibrated capacity no longer falls back to 8000/1024
SHADOW_SEMANTIC_CAPACITY centralized for shadow-only fallback
public get_accepted_model_profile() used for calibrated capacity
full repository freshness check restored
explicit bounded_index mode added
bounded retained-file freshness validation added
bounded_index propagated through adapter dispatch
tautological `or True` assertion removed
request metadata `_test_data_scope/_test_policy/_test_calibration` no longer manufactures production authority
```

Do not rewrite these.

The remaining defects are much smaller and more specific.

---

# 1. VERIFIED REMAINING DEFECTS

## 1.1 THE REQUIRED PRODUCTION E2E STILL DOES NOT USE THE REAL PRODUCTION BUILDER

File:

```text
tests/unified_runtime/test_semantic_unified_runtime_e2e.py
```

Current production E2E does the equivalent of:

```python
orig_builder = sb_mod.build_unified_runtime_semantic_service
spy_builder = _e2e_spy_builder_factory(call_counter)
sb_mod.build_unified_runtime_semantic_service = spy_builder
```

Then `_e2e_spy_builder_factory(...)` does the equivalent of:

```python
from tools.agentx_evolve.semantic_execution.tests.helpers import make_service

_svc, _, _ = make_service(...)
return _svc
```

This is NOT a production builder test.

It proves:

```text
production coordinator
→ monkeypatched fake builder
→ make_service(...)
```

It does NOT prove:

```text
production coordinator
→ real build_unified_runtime_semantic_service(...)
→ real build_governed_embedding_service(...)
→ real SemanticExecutionService(...)
→ real bind_accepted_runtime(...)
```

Moving `make_service()` outside the test body does not solve this.

The helper call graph matters, not only the literal contents of the test function.

This is the highest-priority remaining defect.

---

## 1.2 THE PRODUCTION AUTHORITY PROVIDER IS STILL NOT WIRED BY NORMAL BOOTSTRAP

File:

```text
tools/agentx_evolve/unified_runtime/api.py
```

Current state includes:

```python
_semantic_authority_provider: Any | None = None
```

and:

```python
def _build_semantic_authority_factory():
    ...
    if prov is None:
        return None
```

The production E2E manually calls:

```python
api_mod.set_semantic_authority_provider(...)
```

Therefore the test proves that a test can install an authority provider.

It does NOT prove that normal Agent_X production bootstrap supplies accepted semantic authority.

A production seam whose normal value is permanently `None` is not production integration.

---

## 1.3 COORDINATOR STILL CONTAINS A SECOND SEMANTIC ROLLOUT ALGORITHM

File:

```text
tools/agentx_evolve/unified_runtime/coordinator.py
```

Current `_resolve_semantic_mode_for_intent(...)` still:

- contains its own semantic-mode control flow;
- directly reads:

```text
AGENTX_UNIFIED_RUNTIME_SEMANTIC_ROLLOUT
```

- catches semantic mode resolution errors;
- can return:

```text
"disabled"
```

on failure.

The canonical Unified Runtime mode owner already exists in:

```text
tools/agentx_evolve/unified_runtime/semantic_binding.py
```

through:

```python
_resolve_rollout_mode(...)
```

There must not be two semantic rollout algorithms.

The coordinator may CONSUME the resolved mode.

It may not independently derive it.

---

## 1.4 CALIBRATED MUTATION → SEMANTIC REINDEX FAILURE IS STILL SWALLOWED

File:

```text
tools/agentx_evolve/unified_runtime/coordinator.py
```

After a governed mutation commits, current code does approximately:

```python
try:
    updated = self._perform_incremental_semantic_update(...)
    if updated:
        emit SEMANTIC_INDEX_UPDATED
        emit SEMANTIC_WORKING_SET_INVALIDATED
except Exception:
    pass
```

Then execution may still emit:

```text
WORK_UNIT_COMPLETED
```

This is unacceptable for calibrated semantic execution.

The source mutation has already happened.

If calibrated semantic state cannot be updated afterward, the runtime must not pretend the semantic-first work unit completed consistently.

Calibrated mode must fail closed into an explicit blocked/reconciliation state.

Shadow mode may degrade advisorially.

---

## 1.5 `prove_fabric.py` MUST NOT TREAT A MONKEYPATCHED-BUILDER TEST AS PRODUCTION RUNTIME PROOF

File:

```text
tools/agentx_evolve/semantic_execution/prove_fabric.py
```

This file legitimately contains many local semantic component gates that use:

```text
FakeEmbeddingProvider
make_service(...)
```

Those component gates do not need to be deleted.

But the **Unified Runtime production integration gate** must not use those component-service constructors as a substitute for the production binding path.

The Unified Runtime gate must exercise the same real-builder path required in section 5.

---

# 2. DO NOT TOUCH THESE ALREADY-FIXED AREAS

Do NOT rewrite:

```text
RepositoryToolOwner bounded-index contract
full-index freshness behavior
bounded-index per-path hash checks
SHADOW_SEMANTIC_CAPACITY
calibrated ModelProfile capacity blocking
UnifiedRuntimeSemanticAuthority dataclass
build_unified_runtime_semantic_service basic architecture
SemanticExecutionService public APIs
semantic working-set ranking
exact-source dereference
incremental semantic index implementation
governed patch transaction
TaskContract
WorkPlan
typed WorkUnit.tool_action
canonical ToolIntent ownership
plumber graph
artifact registry
```

Only fix the remaining integration defects.

---

# 3. FIX PRODUCTION AUTHORITY BOOTSTRAP FIRST

Files to inspect:

```text
tools/agentx_evolve/unified_runtime/api.py
tools/agentx_evolve/unified_runtime/semantic_binding.py
```

Then search current bootstrap/runtime/config ownership for the accepted objects.

Search for existing owners of:

```text
DataScope
accepted policy
PolicyDocument
ModelProfile
accepted semantic calibration
CalibrationEvidence
EmbeddingCapabilityConfig
sensitive_config
SensitiveConfigGovernor
budget_tracker
operation_context
enforcer
workspace/runtime bootstrap
```

Also inspect how equivalent accepted semantic authority reaches:

```text
SelfUpgradeWorkflow
build_self_upgrade_context(...)
```

Do not invent a parallel authority model.

---

## 3.1 PRODUCTION MUST HAVE A REAL AUTHORITY PROVIDER WITHOUT TEST SETUP

The normal production coordinator path:

```text
_get_coordinator()
```

must receive a semantic authority factory/provider that is actually backed by Agent_X runtime/bootstrap/config state.

Required behavior:

```text
normal production bootstrap
→ canonical accepted runtime/config owners
→ UnifiedRuntimeSemanticAuthority
→ _ensure_semantic_runtime(...)
```

The system must not require a test to call:

```python
set_semantic_authority_provider(...)
```

before production semantic execution becomes possible.

---

## 3.2 KEEP TEST OVERRIDE SEPARATE FROM PRODUCTION DEFAULT

It is acceptable to retain a test override seam.

But separate:

```text
production provider
```

from:

```text
test override provider
```

Minimal acceptable shape:

```python
def _production_semantic_authority_provider(...):
    # obtain already-accepted typed objects from canonical owners
    ...

_test_semantic_authority_provider_override = None

def _resolve_semantic_authority_provider():
    if _test_semantic_authority_provider_override is not None:
        return _test_semantic_authority_provider_override
    return _production_semantic_authority_provider
```

Names may differ.

The important invariant is:

```text
production default != None merely because no test injected a provider
```

Do not make production rely on the mutable test setter.

---

## 3.3 PRODUCTION AUTHORITY MUST STILL BE TYPED AND ACCEPTED

Do not regress to the old bad approach.

Forbidden authority construction:

```text
provider_preferences["provider"] -> accepted embedding authority
provider_preferences["model"] -> accepted model authority
AGENTX_SEMANTIC_PROVIDER string -> accepted authority
AGENTX_SEMANTIC_MODEL string -> accepted authority
revision = "stable" invented by api.py
dimensions = 8 invented by api.py
placeholder DataScope
path hash identity
request metadata fake objects
```

The production provider must return already-resolved typed authority:

```python
UnifiedRuntimeSemanticAuthority(
    embedding_config=<accepted EmbeddingCapabilityConfig>,
    data_scope=<accepted DataScope>,
    policy=<accepted typed policy>,
    accepted_model_profile=<accepted ModelProfile>,
    calibration_evidence=<accepted CalibrationEvidence or None>,
    budget_tracker=<accepted tracker if remote egress>,
    sensitive_config=<accepted secret governor/config>,
    redactor=<accepted redactor or None>,
    enforcer=<accepted enforcer or None>,
    operation_context=<accepted context or None>,
)
```

If the canonical bootstrap does not currently expose one of these objects, add the smallest adapter/provider seam at the canonical owner.

Do not synthesize authority in `api.py`.

---

## 3.4 ADD A REAL BOOTSTRAP TEST

Add a focused test proving:

```text
standard production bootstrap
→ _get_coordinator()
→ semantic authority factory present
→ production provider resolves typed authority
```

This test must not first call:

```python
set_semantic_authority_provider(...)
```

A separate test may verify the test override seam.

The production-bootstrap test must prove the default.

---

# 4. MAKE `semantic_binding.py` THE ONLY SEMANTIC ROLLOUT OWNER

Files:

```text
tools/agentx_evolve/unified_runtime/semantic_binding.py
tools/agentx_evolve/unified_runtime/coordinator.py
```

The existing resolver in semantic binding is already the authority:

```python
_resolve_rollout_mode(
    *,
    authority,
    explicit=None,
)
```

Prefer renaming it public if coordinator legitimately needs it:

```python
resolve_unified_runtime_semantic_mode(...)
```

or keep a private wrapper entirely inside semantic binding.

Do not duplicate its rules in coordinator.

---

## 4.1 REMOVE DIRECT ENVIRONMENT READING FROM COORDINATOR

Search:

```text
tools/agentx_evolve/unified_runtime/coordinator.py
```

for:

```text
AGENTX_UNIFIED_RUNTIME_SEMANTIC_ROLLOUT
```

Expected after the fix:

```text
0
```

The environment override may be read in:

```text
semantic_binding.py
```

because that is the single Unified Runtime semantic rollout owner.

It must not be read independently by coordinator.

---

## 4.2 REFACTOR `_ensure_semantic_runtime()` TO RETURN THE RESOLVED MODE

The cleanest minimal fix is for the binding seam to resolve:

```text
accepted authority
+ explicit Unified Runtime override
→ semantic mode
→ service construction
```

in one place.

For example:

```python
def _ensure_semantic_runtime(...) -> tuple[Any | None, str]:
    authority = ...
    mode = resolve_unified_runtime_semantic_mode(
        authority=authority,
    )

    if mode == "disabled":
        return None, "disabled"

    if authority is None:
        if mode == "calibrated":
            raise RuntimeError(
                "BLOCKED: calibrated semantic runtime requires accepted authority"
            )
        return None, mode

    svc = build_unified_runtime_semantic_service(
        repository_root,
        authority=authority,
        run_id=req.request_id,
        rollout_mode=mode,
    )

    if svc is None:
        if mode == "calibrated":
            raise RuntimeError(
                "BLOCKED: calibrated semantic runtime failed to bind"
            )
        return None, mode

    if svc.rollout_mode != mode:
        raise RuntimeError(
            "BLOCKED: semantic rollout binding mismatch"
        )

    return svc, mode
```

Adapt exact API as needed.

The important point:

```text
one authority resolution
one rollout resolution
one service construction
```

---

## 4.3 DELETE THE SECOND MODE ALGORITHM

`_resolve_semantic_mode_for_intent(...)` must either:

```text
be deleted
```

or become a trivial consumer of an already-resolved binding result.

It must NOT:

```text
read rollout environment variables
call _resolve_rollout_mode(authority=None) as a proxy
derive a second fallback
catch mode failures and choose disabled
infer calibration separately
```

A helper that simply returns:

```python
svc.rollout_mode
```

from an already-bound service is fine.

A second resolver is not.

---

## 4.4 CALIBRATED MODE MUST NEVER BECOME DISABLED BECAUSE BINDING FAILED

Required:

```text
explicit/automatic calibrated
+ missing authority
→ BLOCKED

calibrated
+ invalid authority
→ BLOCKED

calibrated
+ provider construction failure
→ BLOCKED

calibrated
+ calibration mismatch
→ BLOCKED
```

Forbidden:

```text
calibrated
→ exception
→ return None
→ "disabled"
→ legacy path
```

Shadow may degrade.

Disabled may use the legacy path.

---

# 5. REWRITE THE REQUIRED PRODUCTION E2E CORRECTLY

File:

```text
tests/unified_runtime/test_semantic_unified_runtime_e2e.py
```

Delete the current false production-builder proof.

---

## 5.1 DELETE THE BUILDER SUBSTITUTION

Delete:

```text
_e2e_spy_builder_factory
```

if it exists only to replace the production builder.

Delete required-production-E2E behavior equivalent to:

```python
orig_builder = sb_mod.build_unified_runtime_semantic_service
sb_mod.build_unified_runtime_semantic_service = spy_builder
```

The required E2E must call the actual function object from production code.

---

## 5.2 FORBIDDEN CALL GRAPH IN THE REQUIRED PRODUCTION E2E

The required production E2E and every helper it calls must NOT:

```text
call make_service(...)
construct SemanticExecutionService directly
replace build_unified_runtime_semantic_service(...)
replace build_governed_embedding_service(...)
return a prebuilt SemanticExecutionService
assign coord._semantic_execution_service before the request
manually call record_change(...)
manually call _perform_incremental_semantic_update(...)
```

This restriction applies transitively to helper functions.

Moving forbidden behavior into `_helper()` does not make it acceptable.

---

## 5.3 OFFLINE LOCAL-INTEGRITY TESTING MAY STUB ONLY THE LEAF PROVIDER TRANSPORT

The production builder currently routes through:

```text
build_unified_runtime_semantic_service(...)
→ build_governed_embedding_service(...)
→ OpenAICompatibleEmbeddingProvider
→ StrictSemanticEmbeddingProvider
→ SemanticService
→ SemanticExecutionService
```

For an offline LOCAL_INTEGRITY test, it is acceptable to replace only the lowest external-network/provider transport boundary.

Allowed examples:

```text
patch the HTTP transport used by OpenAICompatibleEmbeddingProvider
patch OpenAICompatibleEmbeddingProvider with a deterministic interface-compatible transport double
inject a deterministic response adapter below build_governed_embedding_service
```

Forbidden:

```text
patch build_unified_runtime_semantic_service
patch build_governed_embedding_service
call make_service
construct SemanticService directly as the production proof
construct SemanticExecutionService directly as the production proof
```

The local test must still execute all production governance and construction code ABOVE the leaf transport.

---

## 5.4 DO NOT BYPASS PRODUCTION SECRET/GOVERNANCE REQUIREMENTS

The real builder uses:

```python
production=True
```

Therefore the E2E must satisfy the actual production contract.

If the embedding config requires a secret handle, create/use the canonical typed sensitive-config/vault object.

Do not solve this by:

```text
passing a raw api_key where production rejects raw keys
changing production=True to False
adding allow_raw_secret=True to production runtime
removing secret governance
```

If remote egress classification requires:

```text
DataScope
policy
budget tracker
```

supply real typed local test instances through accepted authority.

The only substituted component should be the external transport/network leaf.

---

## 5.5 REQUIRED REAL-BUILDER CALL PATH

The production E2E must execute:

```text
production API/coordinator construction
→ production semantic authority provider
→ RuntimeRequest
→ PLANNED_WORK
→ _ensure_semantic_runtime(...)
→ real resolve_unified_runtime_semantic_mode(...)
→ real build_unified_runtime_semantic_service(...)
→ real build_governed_embedding_service(...)
→ leaf deterministic embedding transport
→ real StrictSemanticEmbeddingProvider
→ real SemanticService
→ real SemanticExecutionService
→ real bind_accepted_runtime(...)
→ admit_semantic_first(...)
→ semantic working set
→ exact-source dereference
→ bounded canonical tool dispatch
→ governed mutation
→ automatic semantic reindex
→ working-set invalidation
→ targeted verification
→ completion
```

---

## 5.6 PROVE THE REAL BUILDERS WERE CALLED WITHOUT REPLACING THEM

Use a non-replacing spy.

Allowed approach:

```python
from unittest.mock import patch

with patch(
    "tools.agentx_evolve.unified_runtime.semantic_binding.build_governed_embedding_service",
    wraps=real_build_governed_embedding_service,
) as governed_spy:
    ...
```

ONLY if `wraps` executes the original real function and does not substitute its result.

Likewise, a wrapper/spy around:

```text
build_unified_runtime_semantic_service
```

is acceptable only if it calls the original implementation.

Do not assign a replacement builder that returns another service.

Prefer event/state proof plus a `wraps=` call count.

---

## 5.7 ASSERT TYPE/ORIGIN INVARIANTS

After binding:

```python
svc = coord._semantic_execution_service
```

The required E2E may inspect that field only to identify the runtime-bound service after construction.

Assert:

```text
svc is SemanticExecutionService
svc was absent before request execution
svc appeared only through the production binding path
svc.rollout_mode == expected mode
svc.get_accepted_model_profile() is accepted profile
provider seam verification passes
```

Do not use private field mutation.

---

# 6. FIX CALIBRATED POST-MUTATION REINDEX FAILURE

File:

```text
tools/agentx_evolve/unified_runtime/coordinator.py
```

Target:

```text
_execute_single_governed_mutation(...)
```

The mutation transaction may already be committed before semantic reindex occurs.

Therefore handle this as a post-commit consistency failure.

---

## 6.1 CALIBRATED MODE

When:

```text
semantic_mode == "calibrated"
```

and semantic working-set execution was active:

```text
semantic_ws is not None
```

then any of the following must stop successful work-unit completion:

```text
_perform_incremental_semantic_update raises
_perform_incremental_semantic_update returns false
SEMANTIC_INDEX_UPDATED cannot be proven
working-set invalidation cannot be recorded
```

Required outcome:

```text
mutation remains honestly recorded as committed
semantic consistency is marked failed/stale
request/work unit becomes BLOCKED or RECONCILIATION_REQUIRED
WORK_UNIT_COMPLETED is NOT emitted
COMPLETED is NOT emitted
```

Use existing event types when possible.

Good existing choices include:

```text
BLOCKED
WORK_UNIT_FAILED
RECONCILIATION_REQUIRED
```

Do not invent a new event type unless the current event model needs one.

Recommended reason:

```text
semantic_reindex_failed_after_committed_mutation
```

Include:

```text
changed_paths
working_set_id
operation_id
mode
error
```

in durable evidence.

---

## 6.2 SHADOW MODE

Shadow semantic update failure may degrade.

But do not silently `pass`.

Record an explicit advisory/fallback event using an existing semantic fallback event if available.

Then legacy/non-authoritative execution may continue.

---

## 6.3 DISABLED MODE

No semantic reindex obligation exists.

Legacy behavior remains.

---

## 6.4 REMOVE THE BROAD SILENT PASS

The calibrated mutation/reindex block must not contain:

```python
except Exception:
    pass
```

There may be narrow exception handling to persist the consistency failure.

The exception itself may not disappear.

---

# 7. ADD THE NEGATIVE REINDEX TEST

Add a focused test that drives a real governed mutation with a semantic service whose incremental update is forced to fail at the semantic update boundary.

Do not manually simulate the expected final event state.

Required calibrated assertions:

```text
TOOL_COMPLETED exists
OPERATION_COMMITTED exists
SEMANTIC_INDEX_UPDATED does NOT falsely exist
WORK_UNIT_COMPLETED does NOT occur after the failed semantic update
COMPLETED does not occur
BLOCKED or RECONCILIATION_REQUIRED exists
reason identifies post-commit semantic reindex failure
```

This proves honest post-commit consistency handling.

Add a shadow equivalent proving:

```text
semantic update failure
→ advisory/fallback evidence
→ no false SEMANTIC_INDEX_UPDATED
→ legacy/shadow continuation permitted
```

---

# 8. FIX THE UNIFIED RUNTIME GATE IN `prove_fabric.py`

File:

```text
tools/agentx_evolve/semantic_execution/prove_fabric.py
```

Do not delete unrelated semantic component gates that use:

```text
FakeEmbeddingProvider
make_service
```

They are allowed for LOCAL_INTEGRITY component testing.

But the Unified Runtime integration gate must use the real production builder.

---

## 8.1 REQUIRED UNIFIED RUNTIME PROOF

The gate must prove:

```text
normal production authority provider
→ real Unified Runtime semantic builder
→ real governed embedding builder
→ leaf deterministic transport only
→ RuntimeRequest
→ PLANNED_WORK
→ semantic working set
→ governed mutation
→ automatic semantic reindex
→ verification
→ completion
```

It must not call:

```text
make_service
```

anywhere in the helper chain for this specific gate.

---

## 8.2 KEEP PROOF CLASSIFICATION HONEST

The offline leaf transport proves:

```text
LOCAL_INTEGRITY
```

It does NOT prove:

```text
REAL_PROVIDER_QUALIFICATION
```

Therefore if all local runtime integration gates pass but external provider credentials/real endpoint evidence are not available, final proof status remains:

```text
EXTERNAL_VERIFICATION_REQUIRED
```

That is acceptable.

Do not fabricate real-provider qualification.

---

# 9. PRODUCTION AUTHORITY TESTS

Add these focused tests.

## Test A — default production provider exists

Without calling the test setter:

```text
resolve production semantic authority provider
→ provider is callable
```

Then give it a valid repository-backed runtime request/bootstrap context and assert it returns:

```text
UnifiedRuntimeSemanticAuthority
```

with real typed fields.

If environment/config genuinely does not configure semantic execution, the canonical production provider may return an explicit capability-unavailable result.

But there must still be a real production resolver implementation.

The default must not be simply:

```text
global None
```

with no production resolution path.

---

## Test B — test override does not define production behavior

Prove:

```text
test override installed -> override used
test override cleared -> production provider restored
```

Do not leave the system with:

```text
override cleared -> None
```

unless the production resolver explicitly evaluates current runtime config and returns unavailable for a documented reason.

---

## Test C — request strings still cannot become authority

Keep proof that:

```text
provider_preferences
model_preferences
_test_data_scope
_test_policy
_test_calibration
```

do not themselves create accepted semantic authority.

---

# 10. ROLLOUT SINGLE-OWNER TESTS

## Test D — coordinator has zero direct rollout env reads

Read coordinator source and assert:

```text
AGENTX_UNIFIED_RUNTIME_SEMANTIC_ROLLOUT
```

does not appear.

---

## Test E — semantic_binding owns explicit override

Set:

```text
AGENTX_UNIFIED_RUNTIME_SEMANTIC_ROLLOUT=shadow
```

Then resolve through the production semantic binding resolver and assert:

```text
shadow
```

Do not test the coordinator's own environment parsing because that parsing must no longer exist.

---

## Test F — calibrated missing authority fails through the binding seam

Set the Unified Runtime override to calibrated.

Provide no accepted authority.

Call the normal semantic binding path.

Assert:

```text
BLOCKED
```

not:

```text
None
disabled
legacy
```

---

# 11. REQUIRED PRODUCTION E2E EVENTS

The corrected real-builder E2E must still prove:

```python
event_types = [e.event_type for e in events]

assert "TASK_CONTRACT_CREATED" in event_types
assert "PLAN_CREATED" in event_types
assert "SEMANTIC_MODE_SELECTED" in event_types
assert "SEMANTIC_WORKING_SET_CREATED" in event_types
assert "SEMANTIC_CONTEXT_DEREFERENCED" in event_types
assert "WORK_UNIT_STARTED" in event_types
assert "TOOL_COMPLETED" in event_types
assert "SEMANTIC_INDEX_UPDATED" in event_types
assert "SEMANTIC_WORKING_SET_INVALIDATED" in event_types
assert "VERIFICATION_PASSED" in event_types
assert "COMPLETED" in event_types
```

Required ordering:

```python
assert event_types.index("SEMANTIC_WORKING_SET_CREATED") < event_types.index("TOOL_COMPLETED")
assert event_types.index("SEMANTIC_INDEX_UPDATED") > event_types.index("TOOL_COMPLETED")
assert event_types.index("SEMANTIC_WORKING_SET_INVALIDATED") > event_types.index("SEMANTIC_INDEX_UPDATED")
assert event_types.index("VERIFICATION_PASSED") > event_types.index("SEMANTIC_INDEX_UPDATED")
assert event_types.index("COMPLETED") > event_types.index("VERIFICATION_PASSED")
```

---

# 12. PROVE ARTIFACT UPDATE AND REUSE

Before mutation record public semantic artifact state.

After automatic reindex prove:

```text
changed auth/service.py
→ new file_bytes_sha256
→ new artifact version/identity where applicable

unchanged repository files
→ unchanged artifact file digest
→ existing embedding identity/digest reused where applicable
```

Use public APIs:

```text
list_live_artifacts()
get_live_artifact_index()
```

or add the smallest public read-only query if necessary.

Do not mutate:

```text
_artifacts
_artifact_index
_accepted_model_profile
_semantic
```

inside the required production E2E.

---

# 13. CLEAN UP TESTS THAT HIDE THE BAD PATH

The test file currently contains helpers that make the false production E2E look clean while hiding forbidden behavior elsewhere.

Delete/rewrite helpers whose only purpose is:

```text
call make_service
and return it from a replacement production builder
```

Specifically remove:

```text
_e2e_spy_builder_factory
```

or any renamed equivalent.

Do not retain a disguised replacement under another name.

---

# 14. SEARCH-AND-DESTROY ACCEPTANCE CHECKS

Run these before final response.

## 14.1 Production E2E must not replace the Unified Runtime builder

Search:

```text
tests/unified_runtime/test_semantic_unified_runtime_e2e.py
```

for:

```text
build_unified_runtime_semantic_service =
_e2e_spy_builder_factory
```

Expected:

```text
0
```

If using `patch(...)`, inspect it.

Allowed only:

```text
wraps=<real function>
```

or leaf transport patching.

Not allowed:

```text
return_value=<prebuilt service>
side_effect=<replacement service factory>
```

for the production semantic builders.

---

## 14.2 Required production-E2E helper call graph must not call `make_service`

Search all helpers used by:

```text
test_production_http_api_uses_canonical_semantic_service
```

for:

```text
make_service
```

Expected in that call graph:

```text
0
```

`make_service` may remain in unrelated component tests.

---

## 14.3 Real production authority provider

Search:

```text
tools/agentx_evolve/unified_runtime/api.py
```

Production must not effectively be:

```python
_semantic_authority_provider = None

if _semantic_authority_provider is None:
    return None
```

with no real production resolution path.

There must be a normal production provider/resolver.

---

## 14.4 Coordinator rollout env read

Search:

```text
tools/agentx_evolve/unified_runtime/coordinator.py
```

for:

```text
AGENTX_UNIFIED_RUNTIME_SEMANTIC_ROLLOUT
```

Expected:

```text
0
```

---

## 14.5 Self-upgrade rollout leakage remains zero

Search Unified Runtime production for:

```text
AGENTX_SELF_UPGRADE_SEMANTIC_ROLLOUT
```

Expected:

```text
0
```

---

## 14.6 Silent calibrated post-mutation update failure

Inspect:

```text
_execute_single_governed_mutation
```

There must be no calibrated semantic reindex block equivalent to:

```python
except Exception:
    pass
```

followed by:

```text
WORK_UNIT_COMPLETED
```

---

## 14.7 No production authority fabrication regression

Search production authority path for:

```text
_test_data_scope
_test_policy
_test_calibration
provider_preferences["provider"]
provider_preferences["model"]
```

Expected accepted-authority construction hits:

```text
0
```

---

# 15. FOCUSED TEST COMMANDS

At minimum run:

```bash
pytest -q tests/unified_runtime/test_semantic_unified_runtime_e2e.py
```

Also run the focused tests covering:

```text
semantic_binding
embedding_route
RepositoryToolOwner bounded freshness
incremental semantic indexing
calibrated post-mutation failure
production authority bootstrap
```

Use the exact paths currently present.

Do not run the entire repository unless a shared bootstrap change makes it necessary.

---

# 16. OPTIONAL CI CHECK

If repository CI is configured for these paths, push the finished commit and verify the relevant status.

The previously verified baseline commit had no attached combined status checks.

Do not claim:

```text
CI PASS
```

unless a real GitHub check exists.

Local focused tests are still required regardless.

---

# 17. REQUIRED WORK ORDER

Do this order.

```text
1. Wire a real production semantic-authority provider into normal bootstrap.

2. Refactor _ensure_semantic_runtime so authority + rollout are resolved once
   through semantic_binding.

3. Delete coordinator's independent rollout/env algorithm.

4. Fix calibrated post-commit semantic reindex failure so it blocks/reconciles
   and cannot emit false WORK_UNIT_COMPLETED.

5. Rewrite the required production E2E:
   - real build_unified_runtime_semantic_service
   - real build_governed_embedding_service
   - only leaf transport stubbed
   - no make_service in helper call graph

6. Add default-production-authority bootstrap test.

7. Add calibrated post-mutation reindex-failure negative test.

8. Update Unified Runtime gate in prove_fabric.py to use the same real-builder
   local-integrity path.

9. Run focused tests.

10. Run acceptance searches.

11. Report status.
```

Do not start by editing `prove_fabric.py`.

Do not solve test failures by weakening production code.

---

# 18. LOCAL STOP CONDITION

You may report local completion only when all are true:

- [ ] normal production bootstrap has a real semantic authority provider/resolver
- [ ] test setter is not the only way to obtain semantic authority
- [ ] production authority still uses accepted typed objects
- [ ] coordinator contains zero direct Unified Runtime semantic rollout env reads
- [ ] semantic_binding is the single semantic rollout owner
- [ ] calibrated missing/invalid authority blocks
- [ ] calibrated provider/binding errors block
- [ ] calibrated semantic mutation cannot complete after failed reindex
- [ ] shadow reindex failure produces explicit advisory evidence
- [ ] required production E2E does not replace build_unified_runtime_semantic_service
- [ ] required production E2E does not replace build_governed_embedding_service
- [ ] required production E2E helper call graph contains no make_service
- [ ] required production E2E uses only a leaf external transport test double
- [ ] required production E2E proves real production builder invocation
- [ ] required production E2E proves mutation → reindex → invalidation → verification → completion
- [ ] required negative E2E proves calibrated reindex failure blocks completion
- [ ] `prove_fabric.py` Unified Runtime gate uses the same real-builder path
- [ ] fake/deterministic transport evidence remains LOCAL_INTEGRITY only
- [ ] focused tests pass
- [ ] acceptance searches pass

If any locally implementable item is false:

```text
CONTINUE_REQUIRED
```

---

# 19. EXTERNAL VERIFICATION BOUNDARY

Once every local item above passes, a real external embedding provider may still require:

```text
real provider endpoint
real secret
real provider identity
real network execution
real provider qualification evidence
```

If those external facts are the ONLY remaining gap:

```text
EXTERNAL_VERIFICATION_REQUIRED
```

is correct.

Do not keep coding solely to fake external qualification.

Do not report COMPLETE from a deterministic leaf transport.

---

# 20. FINAL RESPONSE FORMAT

Return only:

```text
STATUS:
<COMPLETE | EXTERNAL_VERIFICATION_REQUIRED | CONTINUE_REQUIRED>

BASELINE:
5abc9a0c4313f536446e90e390da33a223cdf3d1

FILES CHANGED:
- ...

FIXES:
- production semantic authority bootstrap: <done/not done>
- single semantic rollout owner: <done/not done>
- calibrated post-mutation reindex fail-closed: <done/not done>
- real-builder production E2E: <done/not done>
- prove_fabric Unified Runtime gate: <done/not done>

PRODUCTION E2E CONSTRUCTION:
- production authority provider used: <yes/no>
- build_unified_runtime_semantic_service original implementation executed: <yes/no>
- build_governed_embedding_service original implementation executed: <yes/no>
- leaf transport stub only: <yes/no>
- make_service in required E2E helper call graph: <count>
- prebuilt SemanticExecutionService injection: <yes/no>

PRODUCTION E2E EVENTS:
- TASK_CONTRACT_CREATED: <yes/no>
- PLAN_CREATED: <yes/no>
- SEMANTIC_MODE_SELECTED: <yes/no>
- SEMANTIC_WORKING_SET_CREATED: <yes/no>
- SEMANTIC_CONTEXT_DEREFERENCED: <yes/no>
- TOOL_COMPLETED: <yes/no>
- SEMANTIC_INDEX_UPDATED: <yes/no>
- SEMANTIC_WORKING_SET_INVALIDATED: <yes/no>
- VERIFICATION_PASSED: <yes/no>
- COMPLETED: <yes/no>

NEGATIVE CALIBRATED REINDEX TEST:
- mutation committed before forced semantic failure: <yes/no>
- false SEMANTIC_INDEX_UPDATED emitted: <yes/no>
- false WORK_UNIT_COMPLETED emitted: <yes/no>
- BLOCKED/RECONCILIATION_REQUIRED emitted: <yes/no>

SEARCH CHECKS:
- builder replacement in production E2E: <count>
- make_service in required E2E helper call graph: <count>
- AGENTX_UNIFIED_RUNTIME_SEMANTIC_ROLLOUT in coordinator.py: <count>
- AGENTX_SELF_UPGRADE_SEMANTIC_ROLLOUT in unified_runtime: <count>
- fabricated request-metadata authority in production: <count>
- silent calibrated post-mutation reindex exception swallowing: <count>

TESTS:
- <exact command>
  <exact result>

CI:
- <exact GitHub status or NOT RUN/NO CHECK>

REMAINING:
- <NONE or exact external verification item>
```

Do not give an architecture essay.

Do not report COMPLETE if the production E2E replaces the production semantic builder.

Do not report COMPLETE if the production authority provider only exists after a test setter call.

Do not report COMPLETE if calibrated post-mutation semantic reindex failure can be swallowed.

Do not report COMPLETE if coordinator still derives semantic rollout independently.
