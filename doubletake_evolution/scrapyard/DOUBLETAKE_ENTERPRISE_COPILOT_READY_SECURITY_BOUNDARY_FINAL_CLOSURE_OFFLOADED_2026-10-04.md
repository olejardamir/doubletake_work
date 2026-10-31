# DOUBLETAKE ENTERPRISE COPILOT-READY SECURITY BOUNDARY
# FINAL OFFLOADED CLOSURE MISSION
# 2026-10-04

## 0. Mission authority

You MUST work on `main`.

Repository:

```text
https://github.com/olejardamir/DT.git
```

At the time this offload was authored, authoritative `main` was:

```text
8844c3f08a5e4319fabb88bd4c5b2614c3f53a12
```

That SHA is context only, NOT a pin. Other agents may be committing concurrently.

Re-read every file you are about to edit immediately before changing it.
Do not reset, rebase, clean, overwrite, or discard unrelated concurrent work.

This file supersedes:

```text
DOUBLETAKE_ENTERPRISE_COPILOT_READY_SECURITY_BOUNDARY_MISSION_v1.md
```

Do NOT rerun that broad mission from the beginning.

The enterprise boundary is now largely implemented. This mission exists only to finish the remaining closure/evidence work honestly and prevent already-completed mechanisms from being reworked.

---

# 1. Current status

Treat these findings as a starting point to REVERIFY on current `main`.

Approximate state at this offload:

```text
core implementation: ~97%
overall mission closure: ~92%
```

Most remaining work is evidence/closure, not new architecture.

Current enterprise implementation exists under:

```text
tools/doubletake_evolve/enterprise/
```

including:

```text
coding_agent/
packaging/
policy/
review_bundle/
regression_evidence.py
tests/
```

---

# 2. Completed architecture — preserve, do not redesign

Reinspect these areas and treat them as frozen invariants unless an executable test proves a real defect.

## 2.1 Provider-neutral coding-agent boundary

Current implementation includes:

```text
enterprise/coding_agent/contract.py
enterprise/coding_agent/supervisor.py
enterprise/coding_agent/mock.py
```

Preserve:

```text
CodingAgentAdapter protocol
provider-neutral task/result/session types
bounded supervisor repair loop
truthful cancellation
truthful unavailable backend handling
malformed result refusal
deterministic mock backend
no fake-success default
```

Do NOT bake GitHub Copilot-specific transport/vendor concepts into the control plane.

The enterprise profile is Copilot-READY, not required to ship an actual Copilot adapter in v1.

---

# 3. Copilot-ready means adapter-substitutable

The required property is:

```text
DoubleTake governed control plane
        |
        v
CodingAgentAdapter
        |
        +-- MockCodingAgent today
        |
        +-- future organization-approved Copilot adapter
```

A future Copilot adapter must be addable BELOW the canonical adapter contract.

Do NOT change the supervisor/control-plane contract merely to prove readiness.

Do NOT count the absence of a real Copilot adapter as a defect if the mission requirement is readiness rather than production Copilot connectivity.

---

# 4. Completed security boundary — preserve

Current implementation already includes dedicated enterprise policy controls for:

```text
network
process/subprocess
workspace/filesystem
memory
logging
self-modification
```

Preserve the following properties.

## 4.1 Network

```text
external network egress denied
remote embedding denied
remote knowledge ingestion denied
unknown network capability denied
primitive not reached on denial
```

## 4.2 Process

```text
arbitrary subprocess denied
spawn primitive not reached on refusal
```

## 4.3 Workspace

```text
in-workspace access allowed where policy permits
path escape refused
prefix-collision escape refused
Windows path classification covered
```

## 4.4 Memory

```text
run/project scoping
cross-project retrieval refused
enterprise memory has no remote transport
```

## 4.5 Logging

```text
raw/full conversation logging unavailable
environment escalation neutralized
metadata-only logging
secrets redacted/refused
```

## 4.6 Self-modification

```text
installed implementation immutable
self-evolution/refactoring of installation refused
runtime-state root remains the only permitted mutable target class
```

Do not weaken any of these controls to make final closure easier.

---

# 5. Completed packaging boundary — preserve

Current enterprise package construction already follows:

```text
declared enterprise seeds
-> measured first-party import closure
-> independent excluded-capability audit
-> normal package selector/builder
-> built-artifact validation
-> self-describing manifest
```

Preserve this architecture.

The allowlist is DERIVED, not a hand-maintained file list.

Do not replace import-closure derivation with:

```text
directory glob
static current-file list
negative-only denylist
```

---

# 6. Completed forward-closure property — preserve

Current tests now prove both directions:

```text
new unreferenced source file
-> does NOT enter enterprise package

same new source file becomes imported by packaged runtime
-> DOES enter derived closure
```

This prevents both:

```text
package everything
```

and:

```text
frozen allowlist that never evolves
```

Do not reopen this implementation unless current tests fail.

---

# 7. Completed excluded-capability audit — preserve

The enterprise artifact independently audits excluded behavior classes rather than trusting the allowlist alone.

Preserve path/import-based detection for classes such as:

```text
external AI/provider implementations
remote embedding
VPN/network manipulation
browser/remote automation
MCP/server surfaces
self-evolution
other forbidden runtime capability classes
```

Do not reduce exclusion to filename substring matching only.

---

# 8. Completed secret-scan precision evidence — preserve

Current packaging tests now measure both:

```text
true positive credential detection
false positive avoidance
```

including real historical false-positive cases.

Do not weaken secret scanning.

Do not return to name-only secret detection.

---

# 9. Completed review-bundle architecture — preserve

Current review bundle derives security claims from measured facts/probes.

Preserve:

```text
PROVED
NOT_PROVEN
FAILED
```

as distinct outcomes.

Do not coerce:

```text
NOT_PROVEN -> PASS
```

The bundle must remain honest when evidence is unavailable.

---

# 10. Evidence vocabulary E1–E17

The current enterprise review boundary uses:

```text
E1  enterprise package builds from allowlist
E2  excluded provider modules absent
E3  external-provider dependencies absent
E4  mock coding-agent lifecycle
E5  higher-level supervision against mock
E6  external network denied
E7  remote embedding unavailable/denied
E8  remote knowledge ingestion unavailable/denied
E9  VPN code absent
E10 arbitrary subprocess denied
E11 path escapes fail
E12 Windows-relevant path cases
E13 cross-project memory blocked
E14 raw/full conversation logging unavailable
E15 self-evolution absent/unavailable
E16 review bundle generated from measured facts
E17 full DoubleTake regression suite remains healthy
```

Do not add a new evidence numbering scheme.

---

# 11. Remaining blocker A — E17 full-DT regression proof

This is the main unresolved closure item.

Current code correctly reports:

```text
E17 = NOT_PROVEN
```

when no valid regression-evidence record exists.

Do NOT change that behavior.

The mission requires a real baseline-vs-head measurement.

Use the existing:

```text
tools/doubletake_evolve/enterprise/regression_evidence.py
```

mechanism.

Do not invent another regression framework.

---

# 12. E17 closure semantics

The final E17 proof must establish:

```text
full declared DoubleTake test surface measured at clean pre-enterprise baseline
full declared DoubleTake test surface measured at current head
head failures partitioned into:
    regressions
    new-test failures
    pre-existing failures
```

A true enterprise regression is:

```text
a node that passed at baseline and fails at head
```

Do not count:

```text
new tests
pre-existing baseline failures
uncollected-at-baseline nodes
```

as enterprise regressions.

---

# 13. E17 record must remain re-derivable

The recorded artifact must not be trusted because it says:

```json
{"zero_regressions": true}
```

The verifier must recompute the verdict from node-id sets.

Preserve current tests that reject:

```text
forged zero_regressions boolean
edited regression list
missing measurement
stale measured-surface digest
wrong baseline revision
unretained/missing baseline
```

---

# 14. E17 baseline must predate enterprise mission

The selected baseline must genuinely predate the enterprise security-boundary implementation.

Do not choose a later “clean” commit that already contains enterprise work merely to get zero regressions.

Use the current baseline-verification mechanism.

If the real intended baseline is not retained or cannot be measured:

```text
E17 remains NOT_PROVEN
```

Do not fake it.

---

# 15. E17 measured surface

Use the declared measured-surface derivation in current code.

Do not hardcode a stale test-file list.

The baseline and head surfaces must each be derived from their own revision's declarations.

This is already tested; preserve it.

---

# 16. E17 execution

Run the actual regression evidence generation against:

```text
baseline revision
current head
```

Store the resulting record in the repository's expected location/convention.

Then run:

```text
verify_record(...)
probe_e17_full_dt_regression_free(...)
```

Final E17 must be:

```text
PROVED
```

for mission closure.

If it is FAILED:

```text
fix only regressions introduced by the enterprise mission
```

Do not fix unrelated baseline failures merely to make E17 green.

---

# 17. Remaining blocker B — E12 live Windows validation

Current E12 behavior is intentionally honest.

On non-Windows systems, DoubleTake can prove:

```text
Windows path-shape classification
legal Windows spelling acceptance
static escape recognition
```

but platform-only behavior such as real Windows junction semantics may remain:

```text
NOT_PROVEN
```

This is not a Linux-code defect.

---

# 18. E12 closure path

If a Windows execution environment is available:

Run the real Windows-specific enterprise path tests and update evidence only from actual execution.

Target:

```text
every required Windows escape check = EXERCISED
E12 = PROVED
```

Do not change the classifier merely to force PROVED on Linux.

---

# 19. If Windows is not available

Do NOT fake E12.

Report:

```text
E12 = NOT_PROVEN
reason = live Windows validation unavailable
```

Then final mission status remains:

```text
OPEN
```

unless the original mission explicitly allows external platform validation to remain pending while the implementation is considered complete.

If the original mission wording cannot be retrieved, use the stricter interpretation:

```text
full closure requires E12 PROVED
```

---

# 20. Remaining closure item C — final artifact rebuild

After E17 and any final code changes:

Rebuild the enterprise artifact through:

```text
build_enterprise_package()
```

or current authoritative CLI/API.

Do not reuse an artifact created at an older commit.

---

# 21. Manifest freshness

The committed enterprise package manifest is checked against the derived allowlist.

If stale:

```text
regenerate through the official builder
```

Do not manually edit include patterns.

The committed manifest remains reviewable evidence but not an independent source of truth.

---

# 22. Final manifest must describe current artifact bytes

Verify:

```text
file list == derived allowlist
per-file digest == built artifact bytes
dependency set == measured packaged imports
policy profile == live enterprise policy
approved coding-agent adapters == live approved list
```

Do not digest pre-normalization source when the artifact rewrites first-party spellings.

---

# 23. Approved coding-agent adapters

Current expected v1 state is:

```text
MockCodingAgent only
```

unless a real approved adapter has been intentionally added by another mission.

Do not add a Copilot adapter merely to make the package name look complete.

The closure property is:

```text
future approved Copilot adapter can be substituted under CodingAgentAdapter
without redesigning supervisor/security boundary
```

---

# 24. No vendor leakage above adapter boundary

Re-run structural checks confirming no GitHub/Copilot-specific transport concepts leak into:

```text
coding_agent/contract.py
coding_agent/supervisor.py
enterprise policy control plane
```

Vendor naming in documentation describing future integration is acceptable.

Vendor-specific runtime logic is not.

---

# 25. Final review-bundle regeneration

Generate the current review bundle from the rebuilt artifact.

Use:

```text
build_review_bundle(...)
write_review_bundle(...)
```

or current authoritative CLI.

Do not hand-edit evidence statuses.

---

# 26. Review-bundle exit semantics

Preserve:

```text
exit 0 only if all required evidence is PROVED
exit 1 if FAILED or NOT_PROVEN remains
```

Do not treat pending E12/E17 as success.

---

# 27. Review-bundle privacy

Verify the final bundle contains:

```text
no raw prompts
no raw responses
no raw source transcripts
no credentials
no secret material
```

It may contain measured metadata/digests according to policy.

---

# 28. Review-bundle determinism

For identical source/artifact state, review-bundle identity should remain deterministic except where repository conventions explicitly permit nondeterministic fields.

Preserve current choice to omit build timestamps if that is what current conventions require.

Do not add random/time-varying fields to make the bundle look more complete.

---

# 29. Enterprise negative acceptance suite

Run the entire current negative enterprise suite.

Do not cherry-pick only network/process tests.

It must cover current equivalents of:

```text
excluded modules absent from artifact
network primitive not reached
unknown network capability denied
arbitrary spawn primitive not reached
workspace escape denied
cross-project memory denied
restricted content not persisted unredacted
enterprise memory no remote transport
full logging cannot be enabled
self-evolution refused
coding-agent boundary refuses undeclared/malformed outcomes
```

---

# 30. Positive non-vacuity

A secure profile that refuses everything is not acceptable.

Preserve tests proving allowed operations still work where intended, such as:

```text
in-workspace read
valid coding-agent mock result
declared coding-agent outcome
enterprise package import
review bundle creation
```

---

# 31. Packaging/closure non-vacuity

Current recent work added non-vacuity around import-closure derivation.

Run and preserve it.

It must prove both:

```text
unreferenced source does not enter artifact
referenced source does enter artifact
```

and that failure-to-parse/import-close does not silently narrow the package.

---

# 32. Security-control non-vacuity

Do not add artificial “widening” tests that require forbidden operations to become admissible.

For unconditional enterprise denials such as:

```text
external egress
arbitrary subprocess
```

non-vacuity should prove:

```text
the named gate is what refused
primitive was reachable behind the gate
primitive was not touched
distinct requests produce appropriate reason evidence
```

Do not mutate the system into violating policy just to prove it can.

---

# 33. Coding-agent contract closure

Run the lifecycle against `MockCodingAgent` and prove:

```text
start
resume
send task
status
events
cancel
success
failure
stall
unavailable backend
malformed backend result
bounded repair
```

No fake success.

---

# 34. Bounded repair closure

Supervisor repair behavior must remain bounded by explicit budget.

Prove:

```text
failed result -> repair task when permitted
repair does not loop forever
budget exhaustion -> truthful failure
```

No model/vendor assumptions.

---

# 35. Artifact self-sufficiency

Final built enterprise artifact must be importable in an isolated process using the artifact as the only first-party import root.

This prevents accidentally passing because the source checkout shadows missing artifact files.

Preserve/use current artifact import probe.

---

# 36. Excluded modules must fail from artifact environment

Probe representative excluded modules from the built artifact's isolated interpreter.

Expected:

```text
import unavailable from enterprise artifact
```

Do not prove absence only by inspecting the source tree.

---

# 37. Dependency closure

Verify the enterprise dependency set is derived from packaged imports.

Provider-only distributions must remain excluded when their provider code is excluded.

Do not maintain a manual “forbidden dependency names” list as the primary mechanism.

---

# 38. Self-modification closure

Verify both halves:

```text
self-evolution implementation absent from artifact
runtime immutable-install policy refuses modification attempt
```

One half alone is insufficient.

---

# 39. Memory closure

Verify:

```text
same-project retrieval works where policy permits
cross-project retrieval fails
state remains local
no remote transport
```

Do not confuse “memory disabled” with “memory isolated”.

---

# 40. Logging closure

Verify:

```text
full content logging cannot be enabled by environment
enterprise logger remains summary/metadata mode
secrets are never stored raw
changed-file names obey declared policy
```

Do not merely inspect `policy_id`.

Exercise real behavior.

---

# 41. Workspace closure

Verify:

```text
in-scope read works
out-of-scope read fails
out-of-scope write fails
runtime-state writes follow policy
prefix collisions fail
symlink/path escapes fail where platform allows
Windows static cases remain correct
```

---

# 42. Network closure

Verify denied enterprise request cannot reach its transport primitive.

Do not merely return:

```text
allowed=False
```

while transport still runs.

Recorder must remain untouched.

---

# 43. Process closure

Verify denied arbitrary subprocess cannot reach the spawn primitive.

Again, refusal alone is insufficient if side effect occurred.

---

# 44. Final E1–E17 table

Generate a final measured table:

```text
E1  PROVED | NOT_PROVEN | FAILED
E2  ...
...
E17 ...
```

Every status must come from current probe execution.

Do not write expected statuses manually.

---

# 45. Final closure requirement

Strict final closure requires:

```text
E1-E17 all PROVED
```

No FAILED.
No NOT_PROVEN.

If E12 cannot be run live on Windows:

```text
STATUS remains OPEN
implementation blocker = external Windows validation only
```

If E17 has not been measured:

```text
STATUS remains OPEN
```

---

# 46. Do not reopen completed work

Reject changes whose main purpose is:

```text
redesign CodingAgentAdapter
replace supervisor
replace packaging framework
replace allowlist derivation
replace policy modules
rename enterprise package
rebuild review evidence from scratch
rewrite secret scanner
rewrite memory system
rewrite workspace system
```

unless current executable evidence proves a real defect.

This is a closure mission.

---

# 47. Current likely file touch set

Reconfirm on current `main`.

Expected closure changes, if any, should mostly be limited to:

```text
enterprise/regression_evidence.py
enterprise/review_bundle/probes.py
enterprise/review_bundle/builder.py
enterprise/tests/
tests/enterprise/
packaging manifest/review artifacts
scripts or evidence-generation helpers
```

A large change to core runtime should be treated as suspicious and justified explicitly.

---

# 48. Baseline before editing

Before making any change:

1. capture HEAD;
2. run enterprise focused tests;
3. run packaging closure tests;
4. run current non-vacuity drivers;
5. build current enterprise artifact;
6. generate current review bundle;
7. record E1–E17 statuses;
8. identify exactly which evidence remains NOT_PROVEN/FAILED.

Do not assume only E12/E17 remain without measuring current `main`.

---

# 49. Implementation phase 1 — measure current closure

Produce a machine-readable/current table.

If all E1–E17 already PROVED:

```text
do not implement new mechanisms
move directly to final regression/non-vacuity verification
```

---

# 50. Phase 2 — E17

If E17 is NOT_PROVEN:

```text
generate real regression record
verify baseline
verify measured surface
verify current head
re-run E17
```

If FAILED:

```text
identify actual enterprise-introduced regressions
fix those only
regenerate record
```

---

# 51. Phase 3 — E12

If current execution platform is Windows:

```text
run live Windows proof
fix actual Windows boundary defect if found
```

If not Windows:

```text
do not patch code to simulate platform proof
record external blocker honestly
```

---

# 52. Phase 4 — artifact refresh

After any code/evidence change:

```text
regenerate derived manifest if needed
build artifact
validate artifact
verify import closure
verify exclusions
```

---

# 53. Phase 5 — review bundle

Regenerate review bundle from the current artifact.

Verify every bundle security claim corresponds to real probe evidence.

---

# 54. Phase 6 — non-vacuity

Run:

```text
packaging/closure derivation non-vacuity
security refusal non-vacuity
coding-agent supervisor positive/negative contrast tests
regression-record tamper tests
secret-scan precision tests
```

No blind guards.

---

# 55. Phase 7 — broader regression

Run authoritative default/full test command.

The final mission claim is not:

```text
enterprise tests pass
```

only.

It is:

```text
enterprise boundary closes without regressing full DoubleTake
```

That is why E17 exists.

---

# 56. Phase 8 — closure

Only after all strict requirements:

```text
status = PASS
```

Otherwise:

```text
status = OPEN
exact blocker reported
```

---

# 57. Non-vacuity mutation expectations

Before PASS, ensure the existing/new tests would go red if these mechanisms were broken:

```text
allowlist changed to directory glob
allowlist changed to frozen today's-file list
unparseable import source silently skipped
excluded provider inserted into artifact
network primitive called despite refusal
process primitive called despite refusal
cross-project memory admitted
full logging env var honored
self-modification of install root admitted
supervisor accepts malformed result
repair loop unbounded
review bundle hardcodes PROVED
E17 trusts zero_regressions boolean
E17 ignores stale surface digest
secret scanner misses credential corpus
secret scanner flags known non-secret corpus
```

Do not create redundant mutation infrastructure where existing contrast/non-vacuity tests already prove the mechanism.

---

# 58. Copilot-readiness final proof

The mission name includes Copilot-ready.

Final proof should establish the architectural statement:

> An organization-approved GitHub Copilot coding-agent adapter can be implemented as a new `CodingAgentAdapter` backend without changing DoubleTake's enterprise supervisor, packaging/security policy model, verification semantics, or control-plane authority.

Prove this structurally using the mock as the substitute backend.

Do NOT implement Copilot solely to prove substitutability.

---

# 59. What a future Copilot adapter would have to satisfy

Document, without implementing vendor transport:

```text
canonical start/resume session
canonical send task
canonical status
canonical cancel
canonical event stream
canonical CodingAgentResult
workspace-root enforcement
enterprise process/network policy
result verification
bounded supervisor repair
approved-adapter registration
review-bundle declaration
```

No control-plane redesign.

---

# 60. Approved-adapter registration remains explicit

A future adapter must not become enterprise-approved merely because its Python file exists.

Enterprise approval must remain an explicit governed choice through the current approved-adapter mechanism.

New full-DT provider files must not automatically enter enterprise package.

---

# 61. Final evidence artifact set

At closure, retain or generate according to repository conventions:

```text
enterprise package manifest
built artifact
enterprise review bundle
E17 regression record
test/non-vacuity results
```

Do not commit bulky transient build output if repository conventions exclude it.

But every final claim must be reproducible from committed source/evidence instructions.

---

# 62. Final report format

Output:

```text
STATUS: PASS | OPEN

main HEAD:
<sha>

Original enterprise mission:
OFFLOADED

Core implementation:
COMPLETE | INCOMPLETE

Approved coding-agent adapters:
<list>

Copilot-specific control-plane code:
0 | VIOLATION

Enterprise artifact:
BUILT | FAILED

Artifact validation:
PASS | FAIL

Derived allowlist:
PASS | FAIL

Forward-closure property:
PASS | FAIL

Excluded-capability audit:
PASS | FAIL

Secret-scan precision:
PASS | FAIL

Negative acceptance:
PASS | FAIL

Coding-agent contract/supervisor:
PASS | FAIL

Review bundle:
GENERATED | FAILED

Evidence:
E1=<status>
E2=<status>
E3=<status>
E4=<status>
E5=<status>
E6=<status>
E7=<status>
E8=<status>
E9=<status>
E10=<status>
E11=<status>
E12=<status>
E13=<status>
E14=<status>
E15=<status>
E16=<status>
E17=<status>

Windows live validation:
PASS | NOT_PROVEN | FAIL

Full-DT regression record:
PASS | NOT_PROVEN | FAIL
baseline=<sha>
head=<sha>
regressions=<n>

Packaging/closure non-vacuity:
PASS | FAIL

Security non-vacuity:
PASS | FAIL

Default/full tests:
<exact result>

Remaining blocker:
none | exact blocker
```

---

# 63. Hard stopping condition

Stop only at:

## SUCCESS

All required E1–E17 evidence is PROVED, enterprise artifact validates, non-vacuity is green, and full-DT regression evidence shows no enterprise-introduced regression.

or:

## HONEST BLOCKER

A concrete remaining blocker exists, such as:

```text
live Windows validation unavailable
full regression suite could not be measured
actual enterprise regression remains
artifact build/exclusion test fails
```

Do not continue redesigning already-complete architecture once the blocker is external/evidentiary.

---

# 64. Final definition of done

This mission is complete only when executable evidence supports the following statement:

> DoubleTake has a reviewable enterprise package whose file set is derived from the measured transitive import closure of an explicit enterprise runtime profile, not from a broad directory glob or frozen source list. The built artifact excludes prohibited provider, remote-embedding, VPN, browser/MCP, self-evolution, and other disallowed capability classes through both positive inclusion and independent negative audit. External egress, remote embedding/ingestion, arbitrary subprocess, workspace escape, cross-project memory access, raw/full conversation logging, and self-modification are denied by executable policy mechanisms whose underlying primitives are proven not to run on refused paths. The package remains useful rather than refusing everything: governed in-workspace operations and a complete provider-neutral coding-agent lifecycle work through the canonical `CodingAgentAdapter` and bounded supervisor. The shipped enterprise profile contains only explicitly approved adapters, currently the deterministic mock unless another adapter has been separately approved. No GitHub Copilot-specific transport assumption leaks above the adapter boundary; a future organization-approved Copilot backend can be substituted without redesigning the control plane. The enterprise manifest and security review bundle are generated from measured artifact/runtime facts, the secret scanner is measured in both false-negative and false-positive directions, forward packaging closure is non-vacuously proven, the built artifact is self-sufficient under isolated import, E1 through E17 are honestly reported, live Windows path behavior is proven on Windows, and full DoubleTake regression evidence establishes that the enterprise boundary introduces no regression relative to the verified pre-enterprise baseline.

Anything weaker is not final closure.
