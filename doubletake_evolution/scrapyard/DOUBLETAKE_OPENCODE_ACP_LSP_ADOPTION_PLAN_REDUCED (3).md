# DoubleTake Adoption Plan — opencode ACP + LSP Only

**Derived from:**  
`MAIN_DOCS/WISHLIST/DOUBLETAKE_OPENCODE_ACP_CODEMODE_LSP_ADOPTION_PLAN.md`

**Current status:** CodeMode is already implemented and is explicitly out of scope for this execution.

Current CodeMode implementation:

`tools/doubletake_evolve/codemode_runtime/`

Do not reimplement CodeMode. Do not create a second CodeMode runtime. Do not change it except when an ACP/LSP integration requirement exposes a real regression that must be fixed.

References from the original plan:

- `MAIN_DOCS/WISHLIST/hard_drive_findings/25_opencode_acp_agent_client_protocol_interop_reference.md`
- `MAIN_DOCS/WISHLIST/hard_drive_findings/27_opencode_lsp_live_language_server_protocol_client_reference.md`

Source checkout referenced by the original plan:

`/home/njonji/Desktop/opencode/`

Treat that checkout as read-only reference material and never as a runtime dependency.

---

# 0. Mission

Implement the two remaining transferable opencode mechanisms that are not yet natively present in DoubleTake:

1. **ACP (Agent Client Protocol) interop**
2. **LSP live code intelligence**

Do not revisit CodeMode.

Use the current DoubleTake repository as authoritative.

Before editing:

1. inspect current `main`;
2. locate the current canonical session, MCP, governance, operation-enforcement, workspace-isolation, indexing, and event subsystems;
3. map this prompt onto those real owners;
4. extend existing owners instead of creating duplicate authorities;
5. preserve all current governance, evidence, containment, and authorization behavior.

---

# 1. Shared architectural principle

Both new subsystems must remain:

- opt-in;
- additive;
- host-neutral;
- governed by existing DoubleTake authorities;
- unable to bypass enforced primitive execution;
- fail-closed when authorization or containment cannot be proven.

They should sit at the same upstream capability/tool boundary already used by DoubleTake's MCP and governed execution surfaces.

Anything that:

- launches a process;
- reads or writes a workspace path;
- sends an external message;
- exposes a capability;
- starts or controls a session;

must route through the current approved DoubleTake operation/enforcement path.

Do not bypass:

- `AdapterEnforcer`;
- runtime adapter enforcement;
- workspace isolation;
- prompt-context governance;
- accepted run identity/digest binding;
- current capability/gate authority.

Where the current repository has renamed or relocated these components, use the live canonical owner.

---

# 2. CodeMode is complete — do not implement it again

The original plan contained a first phase for:

`tools/doubletake_evolve/codemode_runtime/`

That subsystem now exists.

Treat CodeMode as a completed prerequisite.

Before starting ACP/LSP, verify only that:

```text
tools/doubletake_evolve/codemode_runtime/
```

exists and that its existing focused tests pass.

Do not:

- create another interpreter;
- create another tool bridge;
- create another CodeMode catalog;
- duplicate its concurrency/sequencing logic;
- reopen its architecture merely because the original plan listed it first.

If ACP/LSP can reuse an existing CodeMode primitive safely, reuse it through the current public boundary.

---

# 3. Phase 1 — ACP interop server

## Goal

Implement a native DoubleTake ACP agent-side bridge so external ACP clients can operate DoubleTake-hosted sessions through the existing DoubleTake session/runtime/governance stack.

ACP is a wire/interoperability layer.

It must not become a second session authority.

---

## 3.1 New subsystem

Create:

`tools/doubletake_evolve/acp_bridge/`

Expected components:

### `service.py`

Implement ACP agent-side protocol handling for:

```text
initialize
newSession
loadSession
resumeSession
forkSession
setSessionMode
setSessionModel
prompt
cancel
shutdown
```

Use:

```text
protocolVersion: 1
```

Use newline-delimited JSON stdio framing consistent with the ACP reference.

Do not invent an incompatible transport if the current reference contract already provides one.

---

### `session_adapter.py`

Bridge ACP sessions into the existing:

`tools/doubletake_evolve/session_runtime/`

The existing DoubleTake session/runtime remains authoritative.

ACP sessions are wire representations of those sessions.

Do not create a second durable session database.

Preserve authority consistency:

```text
ACP session
    ↓
existing DoubleTake session_runtime identity
    ↓
existing durable session/event state
```

If the ACP reference uses `knownParts`, map it onto the existing append-only/chained-digest session/event model rather than maintaining a second mutable ledger.

Resume/load/fork behavior must bind to current DoubleTake session identities and lifecycle rules.

---

### `permission.py`

Map ACP capability advertisement onto the current DoubleTake authorization model.

Requirements:

- default deny;
- all capabilities opt-in;
- never advertise a capability the current session/run is not permitted to invoke;
- MCP/tool exposure must reflect existing `AllowedUse`/capability/governance authority;
- an ACP wire request never grants authority by itself.

---

### `cli.py`

Add an ACP-serving command equivalent in purpose to:

```text
opencode acp
```

Use DoubleTake naming and CLI conventions.

It must start the ACP agent-side service using current DoubleTake runtime/session providers.

---

## 3.2 Governed ACP operations

Add governed operation types for the ACP effects required by the final implementation.

At minimum preserve the intent of:

```text
acp.session_open
acp.prompt
acp.cancel
```

Register them in the current equivalents of:

```text
runtime_adapter_enforcement/operations.py
direct_operation_bypass/manifest.py
```

If those files or registries have changed, use the current authoritative operation registry and migration/manifest mechanism.

Every ACP effect must bind to the accepted:

- run identity;
- agent identity;
- generation identity;
- issue/change identity where current governance requires it;
- full/current source SHA where required by the existing evidence model.

No ACP effect may become an untracked direct side effect.

---

## 3.3 Prompt-context governance

ACP session conversation content must pass through the current prompt-context governance path before provider execution or external wire exposure where that governance applies.

Preserve existing classification for sources such as:

- user input;
- repository context;
- connected sources;
- memory/context;
- other governed prompt segments.

ACP must not bypass the existing prompt construction/classification boundary.

---

## 3.4 ACP directionality

Implement **agent-side ACP only**.

DoubleTake serves ACP.

Do not add a second bidirectional agent-driver architecture unless the current ACP reference explicitly requires it and the existing DoubleTake architecture already has the correct owner.

The target is:

```text
external ACP client
        ↓
DoubleTake ACP bridge
        ↓
existing DoubleTake session/runtime
        ↓
existing governed execution
```

not:

```text
ACP bridge
        ↓
new parallel agent runtime
```

---

## 3.5 ACP error behavior

Unknown, malformed, stale, unauthorized, or tampered frames must:

- fail closed;
- return sanitized errors;
- not leak protected values;
- not create partial unauthorized effects.

Cancellation must target the correct current session/run identity.

Stale cancellation must not kill a newer run.

---

## 3.6 ACP tests

Create focused ACP tests, preferably under the new subsystem and/or the current test organization.

Cover at least:

```text
protocol handshake
newSession
loadSession
resumeSession
forkSession
setSessionMode
setSessionModel
prompt
cancel
shutdown
nd-json frame round-trip
session identity binding
knownParts / append-only ledger behavior
tamper detection
permission default deny
capability advertisement filtering
prompt-context governance
real enforcer flow for acp.prompt
stale cancel rejection
session_runtime parity
sanitized failures
```

Use deterministic fakes only through explicit test injection.

Do not fake the authority boundaries themselves.

---

## 3.7 ACP proof target

Add a proof target consistent with current DoubleTake conventions, equivalent to:

```text
make prove-acp-bridge
```

The proof must demonstrate:

```text
external ACP client
    ↓
initialize
    ↓
open/load session
    ↓
prompt
    ↓
governed DoubleTake execution
    ↓
cancel
    ↓
shutdown
```

with every effect bound to the accepted identity and no unauthorized side effects.

---

## 3.8 ACP acceptance

ACP is complete when:

1. an external ACP client can initialize;
2. it can open or load a DoubleTake-backed session;
3. resume works;
4. fork works according to current session semantics;
5. model/mode updates use existing session/runtime authority;
6. prompt enters the existing governed execution path;
7. cancel targets the exact current run/session;
8. all effects are identity-bound and logged;
9. unauthorized capabilities are not advertised or executable;
10. tampered/unknown frames fail closed;
11. no second mutable session store exists;
12. focused tests and the ACP proof pass.

---

# 4. Phase 2 — LSP live code-intelligence client

## Goal

Implement a native DoubleTake LSP client that supplies live code intelligence to existing DoubleTake indexing, semantic, stabilization, and analysis systems.

LSP diagnostics and symbols are evidence.

They do not become a new mutation, promotion, or governance authority.

Implement Python first.

Then add JS/TS.

---

## 4.1 New subsystem

Create:

`tools/doubletake_evolve/lsp_bridge/`

Expected components:

### `client.py`

Implement an LSP client supporting the necessary subset of:

```text
initialize
initialized
shutdown
exit
textDocument/*
workspace/*
responses
notifications
diagnostics
symbols
definitions
references
```

Create typed native models for concepts such as:

```text
Position
Range
TextDocument
Workspace
Diagnostic
Location
Symbol
```

Use the smallest protocol surface needed for the required DoubleTake integration.

---

### `launch.py`

Launch language servers only through the current governed process-operation boundary.

Do not use uncontrolled direct:

```python
subprocess.run(...)
subprocess.Popen(...)
```

when an existing governed execution primitive owns process creation.

Preserve the original requirement:

```text
lsp.launch <language>
```

or the current repository's semantically equivalent operation.

The launch must be authorization-checked and workspace-bound.

---

### `containment.py`

Pin each language-server root to the owning DoubleTake workspace/project.

Reject:

- paths outside the workspace;
- path traversal;
- symlink escapes where current workspace policy forbids them;
- unbound roots;
- mismatched session/project identity.

Reuse the current workspace-isolation boundary rather than creating a second containment policy.

---

### `language.py`

Create a fixed governed language-server registry.

Initial languages:

```text
Python
JavaScript
TypeScript
```

Use a vetted allowlist of server binaries.

Examples from the original plan:

```text
pyright
pylsp
typescript-language-server
```

Do not allow arbitrary model-supplied server binary names or arbitrary executable paths.

If a configured/approved server is missing, return explicit degraded state rather than pretending LSP is available.

---

### `consume.py`

Convert LSP output into schema-versioned DoubleTake evidence/events.

Feed useful live information into the current canonical consumers where appropriate, including current equivalents of:

- semantic/repository indexing;
- stabilization scanning;
- collective/governance scanners;
- mining/repair indexing;
- code-context selection.

At minimum support useful consumption of:

```text
diagnostics
symbols
definitions
references
```

Do not create a second competing project index solely for LSP.

LSP augments existing indexes.

---

## 4.2 LSP governed operations

Add the necessary governed operation types.

Preserve the intent of:

```text
lsp.launch
lsp.initialize
lsp.request
lsp.shutdown
```

and any finer-grained operations justified by the existing enforcement architecture.

Register them in the current canonical operation registry and bypass/effect manifest.

Every operation must remain:

- authorization-bound;
- workspace-bound;
- identity-bound;
- evidence-producing where current operations require evidence.

---

## 4.3 Degraded fallback

LSP is optional.

When the required language server is not installed or unavailable:

```text
LSP unavailable
    ↓
explicit degraded state
    ↓
existing AST/static analysis path remains active
```

Do not fabricate diagnostics.

Do not silently report successful LSP initialization.

Do not make DoubleTake unusable merely because no language server exists.

The existing non-LSP analysis path remains the fallback.

---

## 4.4 LSP authority boundary

LSP output may inform:

- context selection;
- diagnostics;
- code understanding;
- symbol lookup;
- navigation;
- validation evidence.

LSP output does not independently authorize:

- source writes;
- promotion;
- governance decisions;
- capability grants;
- unrestricted process launch.

Existing DoubleTake authority remains authoritative.

---

## 4.5 LSP event integration

Use the existing DoubleTake event/evidence posture.

Where the current repository uses `CanonicalEventLog`, event buses, schema registries, or equivalent durable event infrastructure, emit LSP observations through those existing mechanisms.

Record enough identity to know:

- workspace/project;
- file;
- language;
- server identity/version where available;
- request type;
- run/session identity where applicable;
- timestamp/sequence;
- degraded vs live source;
- source digest/revision where applicable.

Avoid a second independent event database.

---

## 4.6 LSP tests

Create focused tests covering at least:

```text
protocol initialize handshake
typed message encode/decode
approved Python server resolution
approved JS/TS server resolution
unapproved server rejection
workspace containment
path escape rejection
launch through governed process boundary
diagnostic ingestion
symbol ingestion
definition lookup
reference lookup
event/evidence emission
degraded fallback
missing binary handling
shutdown
sanitized server failure
```

Where a real language-server binary is available, run integration tests against it.

Where it is unavailable, skip only the binary-dependent test and still execute all hermetic protocol/containment/governance tests.

---

## 4.7 LSP proof target

Add a proof target consistent with current DoubleTake conventions, equivalent to:

```text
make prove-lsp-bridge
```

With an approved language server present, demonstrate:

```text
workspace
    ↓
governed LSP launch
    ↓
initialize
    ↓
open/analyze source
    ↓
diagnostics + symbols + definition/reference data
    ↓
existing DoubleTake index/evidence consumer
```

Also demonstrate:

```text
unapproved server → refused
outside-workspace path → refused
missing server → degraded fallback
```

---

## 4.8 LSP acceptance

LSP is complete when:

1. Python LSP works through an approved server when installed;
2. JS/TS support uses the same governed architecture;
3. process launch uses the existing governed process boundary;
4. language servers are fixed/allowlisted;
5. workspace containment rejects escapes;
6. diagnostics are ingested;
7. symbols are ingested;
8. definition/reference queries work;
9. results feed existing DoubleTake consumers rather than a duplicate index;
10. missing server produces explicit degraded state;
11. current AST/static fallback still works;
12. LSP observations do not become an authority bypass;
13. focused tests pass;
14. the LSP proof passes.

---

# 5. Cross-cutting requirements for ACP + LSP

## 5.1 Registry and manifest hygiene

Every new effect/operation type must be registered in the current canonical:

- runtime operation registry;
- effect/bypass manifest;
- schema/version registry where required;
- proof/effect-site verification.

Keep current manifest/effect-site verification green.

---

## 5.2 Redaction

Protected data must not appear in:

- ACP frames;
- LSP errors;
- operation results;
- diagnostics forwarded to model context;
- logs;
- evidence payloads.

Use existing sensitive-config/vault/redaction infrastructure.

---

## 5.3 Digest and identity binding

Bind ACP/LSP effects to the accepted identities required by current DoubleTake governance.

Use current equivalents of:

```text
run
agent
generation
issue/change
source SHA
workspace
session
```

Do not introduce weaker identity records for these subsystems.

---

## 5.4 Existing persistence authority

Use current governed persistence/schema writers.

Do not add raw independent persistence if an existing DoubleTake authority already owns the data.

ACP session durability belongs to the existing session store.

LSP durable evidence belongs to existing event/index/evidence systems.

---

## 5.5 Existing defaults remain unchanged

ACP and LSP must remain optional.

If not configured:

```text
ACP disabled → current session/runtime behavior unchanged
LSP unavailable → current AST/static-analysis behavior unchanged
```

Do not make either subsystem mandatory for unrelated existing workflows.

---

## 5.6 No parallel authorities

Do not create:

- another session authority for ACP;
- another capability authority;
- another workspace authority;
- another process-launch authority;
- another project index solely for LSP;
- another governance decision engine.

Extend the current owners.

---

# 6. Execution order

Run the implementation in this order:

```text
1. inspect current repository
2. verify CodeMode already exists and leave it alone
3. map ACP onto current session_runtime + governance
4. implement ACP protocol service
5. implement ACP permission/identity/effect integration
6. add ACP tests
7. run ACP proof
8. run affected regressions
9. implement LSP governed launcher + protocol client
10. implement workspace containment
11. implement Python language-server support
12. integrate diagnostics/symbols/definitions/references
13. add degraded fallback
14. add JS/TS support
15. add LSP tests
16. run LSP proof
17. run affected regressions
18. update documentation/evidence
```

Do not begin LSP by creating an unrelated independent process/runtime stack.

Finish the ACP vertical slice first.

---

# 7. Required regression scope

After ACP changes, run the relevant current tests for:

```text
session_runtime
MCP
capability fabric
prompt-context governance
runtime adapter enforcement
workspace isolation
run management
event/evidence logging
```

After LSP changes, additionally run relevant tests for:

```text
semantic indexing
semantic execution
stabilization
repository/project indexing
workspace isolation
governed process execution
schema/event handling
```

Repair regressions caused by this work.

Do not broaden into unrelated cleanup.

---

# 8. Completion evidence

At completion create a concise implementation report containing:

## CodeMode

```text
status: ALREADY_COMPLETE
path: tools/doubletake_evolve/codemode_runtime/
action_taken: none except any necessary regression fix
```

## ACP

Record:

- implementation paths;
- protocol methods supported;
- session-runtime binding;
- permission/governance binding;
- operation types added;
- tests run;
- proof result;
- known limitations.

## LSP

Record:

- implementation paths;
- approved servers/languages;
- process-governance path;
- workspace containment;
- consumers/index integrations;
- tests run;
- proof result;
- degraded fallback behavior;
- known limitations.

---

# 9. Final completion gate

Declare this reduced plan complete only when all are true:

### CodeMode

1. Existing CodeMode runtime remains intact.
2. No duplicate CodeMode subsystem was created.

### ACP

3. `tools/doubletake_evolve/acp_bridge/` exists.
4. ACP initialize works.
5. ACP new/load/resume/fork session flows use existing session authority.
6. ACP prompt uses existing governed execution.
7. ACP cancel is exact-owner/exact-run scoped.
8. ACP capability advertisement is deny-by-default and authorization-derived.
9. ACP effects are operation/evidence/identity-bound.
10. malformed/tampered/unauthorized ACP requests fail closed.
11. no second mutable session store exists.
12. ACP focused tests pass.
13. ACP proof passes.

### LSP

14. `tools/doubletake_evolve/lsp_bridge/` exists.
15. Python LSP support works with an approved server when available.
16. JS/TS support uses the same governed architecture.
17. language-server launch uses the current governed process boundary.
18. arbitrary server binaries are rejected.
19. workspace escapes are rejected.
20. diagnostics feed existing DoubleTake consumers.
21. symbols feed existing DoubleTake consumers.
22. definitions/references are usable.
23. missing LSP binaries produce explicit degraded fallback.
24. existing AST/static fallback remains operational.
25. LSP output cannot bypass governance or mutation authorization.
26. LSP focused tests pass.
27. LSP proof passes.

### Regression

28. Relevant session/MCP/governance regressions pass.
29. Relevant semantic/index/workspace/process regressions pass.
30. Final implementation report accurately describes the real final state.

When all 30 conditions pass, output:

`ACP_LSP_ADOPTION_COMPLETE`

Otherwise continue fixing the failing condition.

---

# 10. Standing residue

This reduced prompt deliberately removes the original CodeMode phase because it
is already implemented.

After this prompt completes, the original findings 25–27 plan should be treated
as fully absorbed:

```text
finding 26 — CodeMode → already complete
finding 25 — ACP      → completed by this prompt
finding 27 — LSP      → completed by this prompt
```

The original plan's separate MLEvolve/adaptive-code-modes residue remains
independent and is not part of this ACP/LSP implementation.
