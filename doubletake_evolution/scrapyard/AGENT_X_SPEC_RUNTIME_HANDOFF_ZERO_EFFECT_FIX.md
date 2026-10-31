# Agent_X — Spec Compliance → Runtime Handoff + Zero-Effect Completion Enforcement

Current audited `main` at prompt creation:

`df26134f78270c8dc5c16cb187970a5cce6b1705`

Re-check actual current `main` and local working tree before editing.

This prompt contains only the remaining defect.

Do not reopen the already-working specification extraction/compliance logic unless a regression proves it is broken.

---

# Exact production failure

The user runs:

```text
complete everything according to:
/home/glompy/Downloads/AGENT_X_HARVEST_CURRENT_CODE_10_OF_10_IMPLEMENTATION.md
```

The newly added spec-compliance layer correctly detects that the Harvest specification is **not complete**.

Current committed evidence from the spec-compliance repair itself shows approximately:

```text
mandatory requirements: 124
remaining requirements: 123
```

and explicitly records the Harvest defects as UNSATISFIED.

However the user-facing run still does nothing and ends as complete.

Therefore the false no-op detector is no longer the primary bug.

The remaining defect is the downstream execution contract.

---

# Proven defects on current main

## 1. Semantic compliance state is not handed to the coding runtime

Current `/api/chat` prepares only:

```python
prepared = {
    "run_id": ...,
    "run_state_dir": ...,
    "read_only": ...,
    "change_id": ...,
    "write_set": ...,
    "target_digest": ...,
    "workspace_root": ...,
}
```

The incomplete compliance ledger / remaining requirements are absent.

Then the OpenCode prompt is created as:

```python
prompt_body = {
    "agent": opencode_agent,
    "parts": [
        {"type": "text", "text": message}
    ],
}
```

So the coding runtime receives the original one-line user prompt, not the already-proven semantic implementation obligations.

The same architecture exists in Codex/LLM7 peer runtime entrypoints: they receive `prepared` semantic identity/write scope but do not receive an authoritative implementation packet describing the remaining mandatory requirements.

This allows the coding runtime to independently conclude:

```text
looks done
```

even though semantic-first has already proven that mandatory requirements remain.

## 2. Zero effects are currently considered successful finalization

Current `finalize_ui_run()` contains a path equivalent to:

```python
if not changed:
    transition_run_overlay(run_state_dir, change_id, "noop")
    _mark_finalized(run_id, record)
    return {
        "finalized": True,
        "reason": "no-effects",
        "change_id": change_id,
    }
```

This is wrong for an incomplete `SPEC_COMPLIANCE` run.

For a spec-driven request with mandatory requirements remaining:

```text
zero implementation effects
```

is not successful completion.

It is:

```text
SPEC_REQUIREMENTS_REMAIN_UNIMPLEMENTED
```

unless the compliance state was independently re-evaluated after execution and is now complete.

---

# Core invariant

For a `SPEC_COMPLIANCE` mutation run:

```text
semantic-first proves work remains
↓
coding runtime MUST receive that exact remaining-work contract
↓
coding runtime may only finish successfully if:
    required implementation effects occurred
    OR
    fresh post-execution compliance proves no requirements remain
```

A coding model saying:

```text
task complete
```

has no authority by itself.

A provider/session ending normally has no authority by itself.

A zero-diff workspace has no authority by itself.

---

# 1. Add a canonical RuntimeImplementationPacket

Create one immutable/run-bound structure owned by semantic-first.

Conceptually:

```python
RuntimeImplementationPacket(
    schema_version: str,
    run_id: str,
    change_id: str,
    target_digest: str,
    source_digest: str,
    request_mode: str,
    original_request: str,
    materialized_source_ids: tuple[str, ...],
    remaining_requirements: tuple[...],
    satisfied_requirement_ids: tuple[str, ...],
    affected_components: tuple[...],
    write_set: tuple[str, ...],
    scope_provenance: tuple[...],
    verification_requirements: tuple[str, ...],
)
```

Do not let each runtime reconstruct this independently.

One canonical builder.

---

# 2. Packet must come from accepted semantic state

Build the packet only after:

- request materialization;
- spec extraction;
- requirement assessment;
- target design;
- target-driven write-scope resolution;
- coherence validation;
- overlay persistence.

The packet must bind exact:

```text
run_id
change_id
target_digest
source_digest
write_set
remaining requirement IDs
```

Do not create it before target acceptance.

---

# 3. Persist packet in run-local semantic state

Persist as a run-bound artifact, for example:

```text
<run_state_dir>/runtime_implementation_packet.json
```

Requirements:

- canonical JSON;
- digest;
- immutable after coding runtime starts;
- digest recorded on run record;
- only run-local authority;
- never global shared mutable state.

If amendment/reseal changes the semantic target:

- issue a new packet;
- update packet digest;
- old packet becomes stale and non-authoritative.

---

# 4. Return packet identity from `run_ui_semantic_gate`

For an incomplete spec-compliance request that is authorized to proceed, return at least:

```python
{
    ...
    "spec_compliance": {...bounded summary...},
    "remaining_requirement_ids": [...],
    "runtime_packet_path": "...",
    "runtime_packet_digest": "...",
}
```

The API layer must not need to scrape arbitrary semantic files.

Prefer passing the packet data/digest directly in the gate result and durable run binding.

---

# 5. Put packet into `prepared`

Current `prepared` must be extended:

```python
prepared = {
    "run_id": ...,
    "run_state_dir": ...,
    "read_only": ...,
    "change_id": ...,
    "write_set": ...,
    "target_digest": ...,
    "workspace_root": ...,
    "runtime_packet": ...,
    "runtime_packet_digest": ...,
}
```

This becomes the common runtime handoff contract for:

- OpenCode;
- Codex;
- LLM7;
- any future coding runtime.

---

# 6. Coding runtime must receive remaining obligations

Do not merely pass the packet path and assume the model will inspect it.

Inject a bounded canonical implementation instruction into the runtime turn.

Conceptually:

```text
AGENT_X GOVERNED IMPLEMENTATION CONTRACT

The semantic-first gate has already determined that this task is NOT complete.

You are implementing the accepted semantic target.

Remaining mandatory specification requirements:
- ...
- ...

Authorized write scope:
- ...

Required verification:
- ...

Do not declare the task complete merely because related code already exists.
Do not modify paths outside the authorized write scope.
If a required change needs another path, stop before writing it and request scope amendment.
Completion is decided by Agent_X post-execution verification, not by your prose response.
```

Then include the original user request separately.

---

# 7. Do not dump the entire giant specification unnecessarily

The runtime instruction must contain:

- all remaining requirement IDs;
- bounded requirement statements;
- exact target components;
- exact write scope;
- verification obligations;
- materialized source identity/path when runtime may need full context.

For a very large spec, provide:

```text
canonical packet
+
remaining requirement summaries
+
source path/digest
```

The runtime may read the explicit source file as read context when needed.

Do not exceed provider context limits by blindly duplicating the full source.

---

# 8. Runtime packet is authoritative over coding-agent self-assessment

Add explicit system/runtime instruction:

```text
You may report observations, but you cannot override the Agent_X semantic compliance state.

If remaining_requirements is non-empty, you must not terminate as "already complete" without producing concrete evidence that those requirements are satisfied in current code.

Do not simply answer that the code already exists.
```

The runtime must either:

1. make authorized implementation changes; or
2. provide concrete no-change evidence that Agent_X can independently verify.

---

# 9. Provider prose cannot mint completion

If OpenCode/Codex/LLM7 says:

```text
Task complete.
Already implemented.
Nothing to do.
```

that text is advisory only.

Do not set run status to completed from provider prose.

Only final semantic verification may do so.

---

# 10. Fix `finalize_ui_run()` zero-effect semantics

Before accepting:

```text
reason = "no-effects"
```

load the run's semantic target/spec compliance state.

Classify:

## STANDARD request with genuine no-op

Existing no-effects behavior may remain if semantic target permits it.

## SPEC_COMPLIANCE and compliance already complete before runtime

This should normally have been intercepted earlier by `gate["completed"]`.

If reached defensively:

- verify compliance complete;
- accept canonical no-op.

## SPEC_COMPLIANCE and mandatory requirements remain

Zero effects MUST NOT finalize successfully.

Return:

```python
{
    "finalized": False,
    "reason": "SPEC_REQUIREMENTS_REMAIN_UNIMPLEMENTED",
    "remaining_requirement_ids": [...],
}
```

Transition overlay to an appropriate non-success state.

Do not mark semantic finalization complete.

---

# 11. Fresh post-execution compliance is mandatory

Even when files changed, finalization must not assume the spec is now complete.

After implementation:

1. recompute current source snapshot;
2. re-run requirement assessment for the same source digest/spec;
3. compare requirement statuses;
4. verify expected requirements moved toward satisfied;
5. reject regressions of previously satisfied requirements;
6. persist updated compliance evidence.

For spec-compliance runs, successful run completion requires either:

### Full closure

```text
all mandatory requirements
→ SATISFIED / NOT_APPLICABLE
```

or, if the architecture intentionally supports multi-slice continuation:

### Valid partial progress

The individual run may end as:

```text
PARTIAL_PROGRESS
```

but MUST NOT be labeled task complete.

The user-level task remains incomplete.

---

# 12. Distinguish run completion from task completion

This distinction is mandatory.

A coding turn may successfully complete one slice while the specification still has remaining work.

Add statuses conceptually:

```text
run_status:
    completed
    failed
    cancelled

task_status:
    complete
    partial
    blocked
```

Do not conflate:

```text
provider turn ended successfully
```

with:

```text
specification fully implemented
```

---

# 13. For large specs, allow iterative implementation slices

The Harvest specification has many requirements.

One runtime turn may not safely implement all 123 remaining requirements.

Support:

```text
remaining requirements
→ coherent bounded slice
→ target/write scope
→ implementation
→ verification
→ update requirement ledger
→ next slice
```

If a run completes a valid slice:

- mark run completed;
- mark task partial;
- persist remaining requirement count;
- automatically continue only if existing product behavior already supports the requested loop;
- otherwise return explicit “remaining requirements: N”.

Do NOT return “task complete.”

---

# 14. Runtime handoff must match sealed write scope

The packet's implementation requirements must not ask the runtime to change files outside the sealed write set.

If the remaining requirement set is broader than current transaction scope:

- include only the requirements assigned to this slice as actionable;
- list other remaining requirements as deferred;
- do not ask runtime to solve them in the same transaction.

Otherwise the runtime is given contradictory instructions.

---

# 15. Add selected requirement IDs to target components

For spec-driven target design, bind each target component to the requirement IDs it closes.

Conceptually:

```json
{
  "component_id": "harvest_gate_b_authority",
  "requirement_ids": [
    "req-..."
  ],
  "implementation_action": "modify_existing",
  "implementation_targets": [
    "module:..."
  ]
}
```

This enables deterministic verification:

```text
requirement
→ target component
→ write scope
→ actual changed file
→ test/evidence
```

---

# 16. Runtime packet provenance

Each actionable requirement in the packet must include:

```text
requirement_id
statement
source location
target component
authorized paths
verification conditions
```

No orphan requirement.

No writable path without a mapped requirement/target.

---

# 17. OpenCode integration

Current OpenCode path sends:

```python
{"type": "text", "text": message}
```

Replace the effective prompt with a governed implementation handoff.

Recommended shape:

```text
canonical implementation contract
+
original request
```

Do not alter the user's displayed message/history text.

Keep:

```text
user_message = original
runtime_prompt = implementation contract + original
```

separate.

Run records should preserve both identities/digests.

---

# 18. Codex integration

Current Codex path calls:

```python
runtime.start_turn(
    thread,
    message,
    ...
)
```

Use the same common runtime implementation packet builder.

Do not invent a Codex-only interpretation.

Codex receives the same semantic obligations/write scope as OpenCode.

---

# 19. LLM7 coding-runtime integration

If LLM7 may serve as the coding runtime, inject the same contract into its execution prompt.

Do not confuse this with the semantic reasoning provider call.

Semantic LLM call:
- architecture/design.

Coding runtime call:
- execute accepted target.

They remain distinct.

---

# 20. Recovery paths must preserve the packet

Current network/VPN recovery recreates the prompt from the original run record/body.

That can lose semantic runtime context.

Update:

- OpenCode retry;
- browser disconnect recovery;
- usage-limit/VPN retry;
- timeout confirmation/retry;
- Codex resumed turn where applicable;
- LLM7 resumed call where applicable;

so they reuse the exact same:

```text
runtime_packet_digest
change_id
target_digest
remaining requirement slice
```

Do not rebuild semantic requirements from scratch during transport recovery.

---

# 21. A retry cannot fall back to original one-line prompt

Mandatory regression:

Initial runtime prompt:

```text
governed implementation packet + original prompt
```

Network failure occurs.

Recovered prompt MUST contain the same packet digest and obligations.

It must never become only:

```text
complete everything according to: /path/spec.md
```

---

# 22. Finalizer must verify runtime packet identity

At finalization, require:

```text
run record runtime_packet_digest
==
persisted packet digest
==
semantic target packet digest
```

Mismatch:

```text
RUNTIME_IMPLEMENTATION_PACKET_MISMATCH
```

Fail closed.

---

# 23. No-effects regression

Fixture:

```text
spec requirements remaining = 4
write_set non-empty
provider returns "Task complete"
provider performs no writes
```

Expected:

```text
finalized = false
reason = SPEC_REQUIREMENTS_REMAIN_UNIMPLEMENTED
task_complete = false
```

This is the exact current production failure.

---

# 24. False runtime-completion regression

Fixture coding provider responds:

```text
Everything is already implemented.
Task complete.
```

but compliance ledger says:

```text
remaining = 4
```

Expected:

- response text may be shown;
- run does not become task-complete;
- finalizer rejects zero effects;
- UI shows incomplete/failed/partial status based on policy.

---

# 25. Real current Harvest regression

Use current `main` Harvest implementation before fixing Harvest.

Semantic compliance already knows these remain broken:

- Gate B mutation authority;
- `agentx_status` authority;
- disposition-only `can_implement`;
- `(ui_api_wired or True)`.

Run the actual command.

The runtime packet must include these remaining obligations.

Assert OpenCode/Codex receives them.

If runtime makes no changes:

```text
task complete MUST NOT be returned
```

---

# 26. Actual implementation regression

Use a deterministic fake coding runtime that fixes one mapped defect.

Example:

```text
remove `(ui_api_wired or True)` bypass
```

Post-execution compliance:

```text
that requirement → SATISFIED
others → still UNSATISFIED
```

Expected:

```text
run may complete as valid progress
task status = partial
remaining > 0
```

Not task complete.

---

# 27. Full closure regression

After all requirements are fixed:

Post-execution compliance:

```text
remaining = 0
```

Then and only then:

```text
task_complete = true
```

followed by canonical semantic reconciliation and `SYNCED`.

---

# 28. UI behavior

When a spec-driven runtime turn finishes:

## Full completion

Show:

```text
Task complete
0 mandatory requirements remaining
```

## Partial progress

Show:

```text
Progress saved
N mandatory requirements remaining
```

Do not show generic `Task complete`.

## Zero-effect rejection

Show something such as:

```text
No implementation changes were made, but N mandatory specification requirements remain.
```

The exact wording may follow existing UI conventions.

---

# 29. Do not rely on assistant text parsing

Forbidden:

```python
if "task complete" in assistant_text:
    completed = True
```

or opposite.

Provider prose is not completion authority.

Use semantic compliance state and verified implementation effects.

---

# 30. Do not force meaningless changes

The no-effects guard must not force code churn when the spec is actually satisfied.

If post-execution compliance independently proves all requirements satisfied without changes:

- allow canonical no-op;
- record positive evidence.

The key requirement is proof, not mandatory diff count.

---

# 31. Preserve semantic-first authority

Do not let the runtime packet itself become a second mutation authority.

The packet is a projection of the accepted semantic target.

Actual tool effects remain enforced by:

```text
run_id
change_id
target_digest
write_set
effect authorization
```

If packet text and sealed write set disagree:

- sealed deterministic authorization wins;
- treat mismatch as a bug/failure.

---

# 32. Preserve existing finalization requirements

After real changes still require:

- exact changed-file verification;
- test verification;
- invariants;
- target comparison;
- semantic reconciliation;
- evidence issuance/consumption;
- synchronization baseline update as applicable.

This repair adds spec-compliance completion enforcement; it does not replace existing finalization.

---

# 33. Canonical evidence after repair

This repair changes production execution semantics.

After implementation:

1. run runtime-handoff tests;
2. run zero-effects tests;
3. run spec-compliance tests;
4. run semantic gate tests;
5. run OpenCode chat tests;
6. run Codex chat tests;
7. run LLM7 chat tests if applicable;
8. run network recovery tests;
9. run finalizer tests;
10. run current Harvest regression;
11. reconcile project model;
12. issue fresh evidence;
13. remint current baseline;
14. independent `SYNCED`;
15. immediate no-change `SYNCED`.

---

# 34. Exact real-world acceptance test

After this repair, restart Agent_X and run:

```text
complete everything according to:
/home/glompy/Downloads/AGENT_X_HARVEST_CURRENT_CODE_10_OF_10_IMPLEMENTATION.md
```

Before Harvest itself is repaired, expected behavior is NOT:

```text
Task complete
```

Expected behavior:

```text
semantic compliance finds remaining requirements
↓
runtime receives remaining requirements + exact write scope
↓
runtime performs real implementation work
↓
post-execution compliance re-evaluates current code
↓
if remaining > 0:
    progress/partial, not task complete
↓
continue until remaining = 0
```

Only after the Harvest code actually satisfies the specification may the same command produce:

```text
Task complete
```

---

# Completion criteria

Do not stop until ALL are true:

1. semantic gate exposes incomplete compliance state to runtime handoff;
2. one canonical RuntimeImplementationPacket exists;
3. packet is bound to run/change/target/source digest;
4. packet contains actionable remaining requirement IDs/statements;
5. packet contains exact target components;
6. packet contains exact write scope;
7. packet contains verification obligations;
8. packet is persisted run-locally and digest-bound;
9. OpenCode receives the packet, not only the original one-line prompt;
10. Codex receives the same semantic execution contract;
11. LLM7 coding runtime receives it where applicable;
12. user-visible original prompt remains unchanged in conversation history;
13. runtime self-claims cannot mint task completion;
14. zero effects with remaining mandatory requirements fails finalization;
15. `no-effects` success is allowed only when compliance is genuinely complete or normal non-spec no-op policy permits it;
16. post-execution spec compliance is rerun;
17. requirement status changes are persisted;
18. satisfied requirements cannot silently regress;
19. run completion and task completion are distinct;
20. partial progress is not labeled task complete;
21. runtime packet digest is verified at finalization;
22. network/VPN/browser retry preserves the same runtime packet;
23. recovery never falls back to only the original one-line prompt;
24. current Harvest defects are included in actual runtime obligations;
25. current bad Harvest code cannot return task complete with zero effects;
26. one-defect-fix regression produces partial progress;
27. fully fixed Harvest produces task complete;
28. mutation enforcement remains deterministic and semantic-first owned;
29. current semantic baseline is reconciled after the repair;
30. first independent assessment is `SYNCED`;
31. immediate second assessment is `SYNCED`.

---

# Stop condition

Stop only when the missing chain is closed:

```text
spec compliance says work remains
        ↓
accepted target selects a bounded slice
        ↓
runtime implementation packet
        ↓
OpenCode / Codex / LLM7 sees exact remaining obligations
        ↓
real implementation effects
        ↓
fresh post-execution compliance
        ↓
remaining > 0 → partial, NEVER task complete
remaining = 0 → verified task complete
```

The decisive negative regression is:

```text
remaining requirements > 0
+
coding runtime changes nothing
```

This MUST NOT successfully finalize as:

```text
no-effects
task complete
```
