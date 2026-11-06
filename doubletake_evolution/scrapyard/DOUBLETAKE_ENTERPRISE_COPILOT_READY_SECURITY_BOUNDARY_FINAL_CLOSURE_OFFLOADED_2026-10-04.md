# Historical enterprise Copilot-ready security boundary: transferable closure contract

## Provenance and authority
Distilled in place from this document's Git blob `825d62b79c6209486455ed21c66956557bab4366` (historical offloaded mission dated 2026-10-04). Its historical DT main reference was `8844c3f08a5e4319fabb88bd4c5b2614c3f53a12`; that is **not** a current implementation assertion. Earlier related source: `DOUBLETAKE_ENTERPRISE_COPILOT_READY_SECURITY_BOUNDARY_MISSION_v1.md`. Original named implementation areas included `tools/doubletake_evolve/enterprise/{coding_agent,packaging,policy,review_bundle,regression_evidence.py,tests}`; paths, APIs, claims of completion and E1–E17 results require independent revalidation against current DT. This document is research/test criteria, **not** authorization to edit private DT or run historical commands.

## Provider-neutral coding-agent contract
A governed supervisor communicates with a `CodingAgentAdapter` through typed task/result/session interfaces. Required lifecycle: start, resume, send task, status/events, cancel, successful and failed results, stall, backend unavailable, malformed response, and bounded repair. A deterministic mock is a positive-control backend; failure, cancellation and exhausted repair budget must never masquerade as success. An approved future Copilot backend must fit **below** the adapter contract without vendor transport in supervisor, policy or authority control plane. Adapter approval must be explicit, not inferred from a Python file's existence. The historical expectation was mock-only, not proof of current registration.

## Enterprise security policy and executable contrasts
- **Network:** external egress, remote embeddings/ingestion and unknown capabilities denied; instrument transport and prove the primitive is never reached after refusal.
- **Process:** arbitrary spawn denied; instrument the subprocess primitive and prove zero calls.
- **Workspace:** permitted in-root reads and state writes succeed; prefix collisions, traversal, symlinks, out-of-root writes and platform-relevant Windows paths fail. Real junction/platform semantics need **live Windows** execution, not Linux simulation.
- **Memory:** same-project permitted retrieval works; cross-project retrieval fails; no remote transport.
- **Logging/privacy:** metadata-only output; raw conversation and secrets cannot be enabled via environment escalation; actual persisted output must be checked, not just policy identifiers.
- **Self-modification:** installation immutable, runtime-state root narrowly mutable; forbidden evolution modules absent from packaged artifact and installation mutations refused at runtime.
- **Non-vacuity:** every denial has a reachable guarded primitive that remains untouched, with attributable denial evidence; separately demonstrate legitimate workspace operations, mock lifecycle, package import and review-bundle creation. Do not weaken policy to manufacture positive tests.

## Packaging and artifact proof
Start from declared enterprise runtime seeds; derive transitive first-party import closure, then independently audit prohibited capability classes (external providers, remote embedding, VPN, browser/remote automation, MCP/server surfaces, self-evolution). A directory glob, frozen allowlist or negative-only denylist is not sufficient. Forward-closure contrast: an unreferenced new file stays excluded; the same file becomes included when imported by packaged runtime. Parse/import-closure errors must not silently shrink the package.

Validate **built bytes**, not just source: manifest file set equals derived closure, each digest matches final transformed artifact bytes, dependency set derives from packaged imports, policy profile and approved adapters match runtime. Excluded imports must fail in an isolated artifact-only interpreter, while permitted imports succeed without source-checkout shadowing. Provider-only distributions must not leak into dependencies. Credential scanning needs both true-positive and historical false-positive controls; name-only scanning is inadequate.

## Review evidence E1–E17
Use three distinct statuses: `PROVED`, `NOT_PROVEN`, `FAILED`. Never promote unavailable evidence to success. The historical vocabulary was:
- E1 package from derived allowlist; E2 excluded provider modules absent; E3 external-provider dependencies absent.
- E4 mock agent lifecycle; E5 supervisor behavior.
- E6 network denied; E7 remote embedding denied/unavailable; E8 remote ingestion denied/unavailable; E9 VPN code absent; E10 subprocess denied.
- E11 workspace escapes denied; E12 Windows-specific path behavior; E13 cross-project memory denied; E14 raw/full logging unavailable; E15 self-evolution absent/denied.
- E16 review bundle generated from measured facts; E17 full DT regression health.

Review bundle must be reproducible from current artifact/probes, omit raw prompts/responses/transcripts and credentials, and avoid gratuitous nondeterministic timestamps. Exit success only when all **required** evidence is PROVED; FAILED or NOT_PROVEN is not a pass.

## E17 regression evidence: baseline and tamper tests
Use a genuine, retained **pre-enterprise** baseline and current head; derive each revision's declared full test surface independently. Compare node IDs: baseline PASS → head FAIL is a regression; pre-existing failures, newly added tests and baseline-uncollected nodes must be classified separately, not misrepresented. Recompute from measured sets rather than trusting a supplied `zero_regressions` flag. Negative tests must reject edited regression lists, forged booleans, missing measurements, stale measured-surface digests, incorrect/unretained baseline and mismatched revisions. If baseline or full measurement unavailable, E17 stays NOT_PROVEN. Historical module named `enterprise/regression_evidence.py` is a reference, not proof of current API.

## E12 platform limitation and closure
Static Windows path classification on non-Windows does **not** prove live junction/escape behavior. If actual Windows tests cannot run, E12 remains NOT_PROVEN; do not force PROVED through a classifier patch. Historical strict closure demanded E1–E17 PROVED, validated rebuilt artifact, independent excluded-capability audit, positive/negative and mutation-sensitive tests, measured review bundle and zero enterprise-introduced regressions. Otherwise report OPEN with the exact missing evidence. The historical mission estimated near-completion and cited E12/E17 as blockers; those percentages and blockers are **unverified historical claims**, not present-day DT status.

## High-value mutation/negative controls
Tests should fail if import closure becomes a glob or frozen list; parse failures are silently skipped; prohibited provider code enters artifact; denied network/spawn still invokes primitives; cross-project memory leaks; full logging can be enabled; install-root modification is accepted; malformed agent results pass; repair becomes unbounded; review statuses are hardcoded; E17 trusts forged zero-regression claims or stale surface digests; credential detection misses true secrets or rejects known nonsecrets. Preserve distinct failure evidence and allowed-path controls.

## Open verification
No private DT checkout, runtime host, live Windows environment, current artifact, current approved-adapter registry or E1–E17 probe outputs were inspected during this scrapyard dissection. Do not infer current implementation or closure from this historical source.
