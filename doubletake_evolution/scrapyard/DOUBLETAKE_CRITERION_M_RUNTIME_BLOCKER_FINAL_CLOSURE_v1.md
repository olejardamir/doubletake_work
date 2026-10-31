# DOUBLETAKE CRITERION M
# RUNTIME-BLOCKER FINAL CLOSURE v1
# 2026-10-05

## 0. Mission authority

You MUST work on `main`.

Repository:

```text
https://github.com/olejardamir/DT.git
```

At the time this offload was authored, current `main` was:

```text
ccbe14e1b47a6c298ab60f45a638c754bed8d0e6
```

That SHA is context only, NOT a pin. Other agents may commit concurrently.

Re-read every file immediately before editing it.
Do not reset, rebase, clean, overwrite, revert, or discard unrelated concurrent work.

This mission supersedes:

```text
DOUBLETAKE_AUTOMATIC_CAPABILITY_PARTICIPATION_MISSION_v6_SEMANTIC_INTENT_IR_FINAL_M_CLOSURE.md
```

Do NOT rerun the broad v6 implementation mission.

The DoubleTake-side criterion-M architecture is now substantially implemented.

The remaining blocker is the currently running OpenCode runtime's inability to accept the required native structured semantic request.

This mission exists only to:

```text
preserve the completed implementation
re-measure the active OpenCode runtime
close M if the runtime capability becomes available
otherwise leave M OPEN honestly and stop
```

---

# 1. Current criterion state

Current convergence truth:

```text
Criterion M = OPEN
```

Do not change this until the live runtime proof passes.

Current authoritative convergence row:

```text
tools/doubletake_evolve/tests/test_capability_participation_convergence_table.py
```

The negative M property still exists in:

```text
tools/doubletake_evolve/collective_core/test_capability_nameless_reach.py
```

Current live evidence:

```text
reports/capability_semantic_live/evidence.json
```

Current live verdict at this offload:

```text
transport.verdict = STRUCTURED_REQUEST_REFUSED
```

---

# 2. Completed DoubleTake-side architecture — FREEZE IT

Treat the following as completed unless an executable current test proves a real defect.

Do NOT refactor or redesign them merely because M is still OPEN.

## 2.1 Semantic capability profiles

Implemented.

Preserve:

```text
effects["semantic_profile"]
typed validation
governed digest binding
migration/reconciliation
de-identified vocabulary derivation
legacy lexical isolation
```

## 2.2 Semantic Intent IR

Implemented.

Preserve:

```text
closed typed schema
resolved / partial / unresolved states
canonical atom IDs
strict validation
no capability IDs in call #1 output
no chain-of-thought dependency
```

## 2.3 Deterministic semantic matcher

Implemented.

Preserve:

```text
structural operation/subject/property/output matching
no provider dependency
no floating-point semantic threshold
no capability-name lookup
deterministic admission
G-negative controls
```

## 2.4 Deferred semantic participation

Implemented.

Preserve:

```text
pending semantic round
nameless task-begin deferral
no premature execution
same-round finalization
deterministic fallback
explicit-name zero-LLM fast path
```

## 2.5 Router authority

Implemented.

Preserve:

```text
provider-free CapabilityRouter
provider-free rank_candidates
semantic evidence as separate provenance
semantic evidence bypasses only lexical-only relevance failure
safety/conflict/binding/composition/permission remain authoritative
```

## 2.6 OpenCode-only learned semantics

Implemented.

Preserve:

```text
use_embedding_provider=False
no auxiliary learned model on M path
no SentenceTransformer dependency on production M path
no second model/provider fallback
```

## 2.7 OpenCode semantic transport implementation

Implemented on the DoubleTake side.

Preserve:

```text
OpenCodeModelRef(providerID, modelID)
fresh semantic session
same active OpenCode service
no server/model acquisition for M
ordinary-tool denial
native structured request path
served-model provenance
session cleanup
```

## 2.8 Live proof and evidence

Implemented.

Preserve:

```text
real governed M populations
fresh held-out population
negative controls
G coincidence controls
source-surface/vocabulary digests
live transport verdict
non-vacuity
evidence verifier
```

---

# 3. Current measured blocker

The latest live proof against the already-running OpenCode runtime measured:

```text
DoubleTake sends the required native structured semantic request
        |
        v
OpenCode runtime rejects it
        |
        v
InvalidRequestError
Missing key ["text"]
```

The served runtime contract requires a prompt shape centered on:

```text
text
```

and rejects the v6-required native request carrying fields equivalent to:

```text
model
tools
format
system
parts
```

The served runtime interface also exposes no usable native:

```text
json_schema
structured output
```

capability for this path.

Therefore:

```text
semantic compiler cannot produce admissible native structured evidence
DoubleTake falls back deterministically
criterion M remains OPEN
criterion G remains intact
```

This is a RUNTIME-SIDE blocker unless new evidence proves otherwise.

---

# 4. Forbidden workaround: prose extraction

Do NOT "solve" this by changing the semantic compiler to accept free-form text and scrape JSON from it.

Forbidden examples:

```text
ask model to print JSON in prose
strip markdown fences
search for first "{"
parse best-effort JSON substring
regex semantic fields out of text
retry until valid text appears
```

Sections 42/107 of the superseded v6 mission deliberately prohibited this.

Preserve that prohibition.

Reason:

```text
native schema-constrained structured evidence
is part of the authority/safety boundary
```

A permissive prose parser is not equivalent.

---

# 5. Forbidden workaround: auxiliary models

Do NOT:

```text
download another LLM
download an embedding model
use sentence-transformers
use MiniLM/BGE/E5
use remote embedding APIs
use a second OpenCode model
use another provider
```

The only learned semantic system permitted remains:

> the already-selected active OpenCode LLM for the current run.

---

# 6. Forbidden workaround: weaken G

Do NOT improve M by:

```text
lowering lexical thresholds
loosening coincidence gates
admitting one-atom matches
adding per-capability aliases
adding hand-written synonyms
hardcoding M probe vocabulary
```

Criterion G must remain intact.

---

# 7. Forbidden workaround: capability-name leakage

Do NOT expose to call #1:

```text
capability names
capability IDs
bindings
implementation paths
expected target mapping
```

The semantic compiler remains an intent compiler, not a capability selector.

---

# 8. No more semantic architecture research

Do NOT resume broad experiments with:

```text
WordNet
lexical hierarchies
sentence embeddings
similarity thresholds
alternate representations
capability-specific phrase expansion
```

Those avenues were already measured and rejected.

The current blocker is no longer "find a better semantic retrieval trick".

The current blocker is:

```text
the active runtime must accept the required structured semantic request
```

---

# 9. Mission entry condition

At the start of every run of this mission:

1. capture current `main` SHA;
2. inspect current M convergence status;
3. inspect:
   ```text
   reports/capability_semantic_live/evidence.json
   ```
4. inspect the currently active OpenCode runtime/API contract;
5. determine whether the runtime still rejects the required structured request.

Do NOT implement anything before this measurement.

---

# 10. Runtime capability probe

Use the existing live semantic proof machinery.

Do not invent a second probe.

Relevant current production/live-proof surfaces include current equivalents of:

```text
tools/doubletake_evolve/providers/opencode_provider.py
tools/doubletake_evolve/runtime/capability_semantic_bridge.py
tools/doubletake_evolve/runtime/capability_semantic_live_proof.py
tools/doubletake_evolve/runtime/test_capability_semantic_live_proof.py
reports/capability_semantic_live/evidence.json
```

The probe must use the actual already-running OpenCode service.

Do not start another server solely for M.

---

# 11. Exact runtime decision

There are only two legitimate runtime states.

## State A — structured semantic request still refused

If the active runtime still:

```text
requires text-only prompt shape
rejects model/tools/format/system/parts
has no native JSON-schema structured output
```

then:

```text
M stays OPEN
regenerate live evidence if stale
record STRUCTURED_REQUEST_REFUSED
stop
```

Do NOT continue coding around it.

## State B — runtime now supports required structured request

If the active runtime now genuinely supports:

```text
same active model reference
fresh isolated session
ordinary tools denied
native structured JSON-schema output
served-model provenance
```

then proceed to the live M closure sequence below.

---

# 12. What counts as native structured support

Support is real only if the runtime accepts a request whose behavior is equivalent to:

```text
model = current providerID/modelID
tools = ordinary tools denied
format = json schema / equivalent native structured contract
system = compiler protocol
input = current request + de-identified vocabulary
```

and returns a machine-typed structured object under runtime enforcement.

The following do NOT count:

```text
text response that happens to contain JSON
markdown JSON
tool call used as a substitute unless runtime-native structured-output contract defines it
post-hoc parser
regular expression
schema checked only after free-form prose generation
```

---

# 13. If runtime API changed

If a newer OpenCode runtime supports the required capability under a different native field/endpoint:

You MAY adapt DoubleTake's transport adapter to the new native interface.

Conditions:

```text
same active OpenCode model
no auxiliary model
fresh session
no ordinary tools
native schema enforcement
served-model provenance
strict failure
no prose salvage
```

This is the ONLY legitimate implementation change expected under this mission.

Keep it narrow.

Do not redesign semantic IR/router/profile machinery.

---

# 14. Runtime transport adaptation test

If transport code is changed because OpenCode's native structured API changed:

Add/adjust tests proving:

```text
native schema reaches runtime
ordinary tools disabled
wrong-model response rejected
missing structured result rejected
free-form text not accepted as substitute
semantic session retired
no main-session mutation
```

Then rerun existing provider-authority tests.

---

# 15. Live closure sequence if structured support exists

Only if runtime support is genuinely present:

1. run the governed live M proof;
2. use the current real capability inventory;
3. use current semantic profiles/vocabulary;
4. use the exact current active OpenCode model;
5. call compiler once per unresolved semantic request;
6. use call #2 only if the existing architecture genuinely requires it;
7. record real route/execution outcome;
8. preserve G controls;
9. regenerate live evidence.

---

# 16. M positive property

Final M closure requires:

```text
zero valid capability losses caused solely by removal of internal capability names
```

Do not use:

```text
percentage improvement
majority success
10/16
15/16
```

The governed M population must satisfy the actual criterion.

---

# 17. Fresh population requirement

Final live proof must include:

```text
held-out
fresh held-out
```

and any current post-freeze population required by the live-proof design.

Do not remove difficult rows.

Do not edit requests to resemble semantic profile glosses.

---

# 18. G remains a hard co-gate

Final live proof must also include:

```text
coincidence controls
negative controls
```

Required:

```text
valid M targets reached
G coincidences refused
unrelated controls refused
```

M cannot PASS if G regresses.

---

# 19. Semantic call budget

Preserve:

```text
0 calls explicit-name fast path
1 call normal nameless semantic compilation
2 calls max only for genuine ambiguity
```

No repeated semantic sampling.

No best-of-N.

No "ask again until it works".

---

# 20. No expected-answer leakage

The live OpenCode compiler must never receive:

```text
expected capability
target capability ID
fixture answer
```

It receives only:

```text
current request
de-identified semantic vocabulary
compiler protocol
```

---

# 21. Live evidence must be current

After a successful live run, regenerate:

```text
reports/capability_semantic_live/evidence.json
```

The record must bind to current:

```text
source surface
fixture digest
profile inventory digest
vocabulary digest
IR schema version
providerID/modelID
```

Do not hand-edit the artifact.

---

# 22. Evidence verifier

Run the current live-evidence verifier.

It must reject:

```text
stale source surface
stale vocabulary
wrong provider/model
missing live rows
forged M aggregate
G regression
auxiliary model evidence
excess call count
```

Final successful evidence must verify cleanly.

---

# 23. Non-vacuity

Preserve and run the existing live-proof non-vacuity suite.

At authoring time the convergence record reports:

```text
13/13
```

for the live semantic evidence mechanism.

Re-derive the current count.

Do not hardcode 13 if the current suite evolved.

Required:

```text
all intended mutations FIRED
BLIND=0
NOOP=0
```

under current conventions.

---

# 24. Current deterministic fallback must remain healthy

Whether runtime support exists or not, preserve:

```text
OpenCode unavailable/refused
-> semantic evidence not admitted
-> deterministic route revalidated
-> no crash
-> no auxiliary model
-> G intact
```

Do not make M closure work by breaking fallback.

---

# 25. No M status change on transport-only success

A runtime accepting structured output is NOT enough.

Do NOT mark M PASS until:

```text
structured transport works
AND live compiler produces valid IR
AND zero M name-removal losses
AND G controls remain refused
AND N/history isolation remains intact
AND provider authority remains intact
AND non-vacuity passes
```

---

# 26. Criterion N

Preserve:

```text
fresh semantic session
no prior chat history
same current request + vocabulary -> same permitted semantic input
```

Do not fix transport by reusing the user's main OpenCode conversation.

---

# 27. Provider authority

Preserve all current authority tests.

OpenCode may produce semantic evidence only.

DoubleTake still owns:

```text
routing
admission
safety
conflicts
binding
composition
permissions
execution
```

Do not move final capability selection into the model.

---

# 28. No OpenCode server acquisition

The semantic path may use only the already-running OpenCode service.

If the configured runtime is down:

```text
semantic unavailable
deterministic fallback
M remains OPEN for live closure
```

Do not start another server solely to satisfy the proof.

---

# 29. No model switching

Use the actual current run:

```text
providerID
modelID
variant
```

Do not call model listings and choose a stronger model.

Do not change the model for the M benchmark.

---

# 30. If the active model itself fails semantic compilation

If the runtime supports native structured output but the active model cannot correctly compile the governed M requests:

Do NOT:

```text
switch model
add synonyms
weaken matcher
lower gates
resample repeatedly
```

Leave M OPEN and report the exact failing live cases.

That is an honest model-capability blocker.

---

# 31. Scope of allowed code changes

Expected change surface is now tiny.

Likely allowed files, only if runtime interface changed:

```text
tools/doubletake_evolve/providers/opencode_provider.py
tools/doubletake_evolve/runtime/capability_semantic_bridge.py
tools/doubletake_evolve/runtime/capability_semantic_live_proof.py
related transport/live-proof tests
reports/capability_semantic_live/evidence.json
convergence record after real PASS
```

Changes to:

```text
capability_semantic_ir.py
capability profiles
router admission logic
participation architecture
G gates
```

are suspicious and require a current failing deterministic test that proves a genuine defect.

---

# 32. Do not delete historical blocker evidence

When the runtime eventually supports structured output:

Do not erase history proving that the older runtime refused it.

The current live artifact will be superseded by a new current artifact.

Historical commit evidence remains in Git.

Do not retain stale blocker prose in the active convergence row after PASS.

---

# 33. Current M convergence row

While runtime remains blocked:

```text
M = OPEN
```

The row should truthfully say:

```text
DoubleTake implementation exists
active runtime refuses required native structured request
live proof therefore falls back
G intact
M not satisfied
```

Do not describe the blocker as an embedding procurement issue if that is no longer current.

---

# 34. PASS transition

Only after successful live closure:

1. replace/supersede the negative M property;
2. set:
   ```text
   M = PASS
   ```
3. update the M row to describe the shipping Semantic Intent IR architecture;
4. cite exact live and deterministic certifiers;
5. remove stale active wording saying structured transport is refused;
6. run:
   ```text
   test_no_criterion_is_open()
   ```

Do not special-case M in the global convergence test.

---

# 35. Final focused tests after PASS

Run current equivalents of:

```text
test_capability_nameless_reach.py
test_capability_semantic_ir_matcher.py
test_capability_semantic_bridge.py
test_capability_semantic_live_proof.py
test_capability_semantic_live_runner.py
test_capability_participation_convergence_table.py
test_capability_routing_is_provider_independent.py
test_provider_wiring.py
test_interpretation_confidence_is_not_earned_by_a_provider.py
```

plus current semantic profile/migration/no-aux-model tests.

Do not cherry-pick only M positives.

---

# 36. Broader tests

After focused green:

Run the authoritative broader/default test command required by current repository conventions.

Do not hide unrelated failures.

Distinguish:

```text
new regression
pre-existing unrelated failure
```

M cannot be closed if this work introduces a new unresolved regression.

---

# 37. STOP condition while runtime remains blocked

If the current active OpenCode runtime still refuses the required structured request:

Stop.

Final report:

```text
STATUS: OPEN
Criterion M: OPEN
DoubleTake implementation: COMPLETE
Runtime structured support: UNAVAILABLE
transport verdict: STRUCTURED_REQUEST_REFUSED
G: PASS
auxiliary models: 0
remaining blocker: active OpenCode runtime lacks required native structured-output interface
```

Do not continue experimenting.

This is an acceptable end state for this mission run.

---

# 38. STOP condition if runtime support appears

If runtime support appears:

Continue only through:

```text
transport adaptation if needed
live M proof
G proof
non-vacuity
convergence
broader regression
```

Then stop at either:

```text
PASS
```

or an exact new model/runtime blocker.

Do not reopen the entire semantic architecture.

---

# 39. Final report format

Output:

```text
STATUS: PASS | OPEN

main HEAD:
<sha>

Criterion M:
PASS | OPEN

DoubleTake semantic-IR implementation:
COMPLETE | INCOMPLETE

Active OpenCode runtime:
endpoint=<non-secret endpoint identity>
providerID=<...>
modelID=<...>
variant=<...>

Native structured-output support:
AVAILABLE | UNAVAILABLE

Transport verdict:
<current verdict>

Structured request accepted:
YES | NO

Ordinary tools available to semantic session:
0 | VIOLATION | NOT_RUN

Auxiliary learned models on M path:
0 | VIOLATION

Live M proof:
PASS | FAIL | BLOCKED

Held-out name-removal losses:
<none or list>

Fresh name-removal losses:
<none or list>

G coincidence controls:
PASS | REGRESSION

Negative controls:
PASS | REGRESSION

Criterion N/history isolation:
PASS | REGRESSION

Provider authority:
PASS | REGRESSION

Semantic call budget:
PASS | VIOLATION
observed max=<n>

Live evidence verifier:
PASS | FAIL

Non-vacuity:
<fired>/<attempted>
blind=<n>
noop=<n>

Convergence:
M=<status>
test_no_criterion_is_open=<result>

Broader tests:
<exact result>

Remaining blocker:
none | exact blocker
```

---

# 40. Final definition of done

This mission is complete when one of the following two statements is truthfully supported by executable evidence.

## A. PASS

> The already-active OpenCode runtime now supports the native structured semantic request required by DoubleTake's criterion-M architecture. DoubleTake uses that exact current provider/model in a fresh no-history semantic session with ordinary tools denied and native schema-constrained output. The live compiler maps nameless requests to governed Semantic Intent IR without seeing capability identities, deterministic semantic matching reaches every valid M target with zero losses caused solely by removing internal capability names, criterion G controls remain refused, criterion N and provider-authority invariants remain intact, no auxiliary learned model is used, the live evidence re-derives cleanly, non-vacuity passes, and the convergence table can honestly mark M PASS.

## B. HONEST OPEN

> The DoubleTake-side Semantic Intent IR architecture is complete and its deterministic/fallback/authority properties are proven, but the currently active OpenCode runtime still refuses the required native structured-output request or the active model cannot satisfy the governed live M population. No permitted repository-side repair can close M without violating the mission's structured-output, OpenCode-only, G-preservation, no-probe-fitting, or provider-authority constraints. Criterion M therefore remains OPEN with an exact measured runtime/model blocker.

Anything else is not final closure.
