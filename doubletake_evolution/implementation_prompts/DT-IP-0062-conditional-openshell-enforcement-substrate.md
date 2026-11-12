# DT-IP-0062 — Conditional OpenShell enforcement substrate (future coder prompt; NOT EXECUTED)

## Provenance and authority
- Live source: `doubletake_evolution/scrapyard/openshell_not_prompt.txt`, blob `c7de916080326d7273a6bdea33687851da681c12`, complete 3,233-byte historical distillation read.
- Full predecessor Git blob `3015885a7b72feb88035a2fa4e91500b0718ae04`, 22 numbered original proposals read in full. This is a historical unapproved recommendation, not evidence of a current DT defect or authorization.
- Primary references (version, compatibility, license and current applicability require fresh independent verification): https://github.com/NVIDIA/OpenShell ; https://docs.nvidia.com/openshell/latest/how-it-works/policies/overview ; https://docs.nvidia.com/openshell/latest/how-it-works/policies/prover .
- Do not copy upstream implementation or license-restricted components. Use upstream as an optional substrate only if owner-approved and rights/version compatibility are established. No private DT inspection, implementation, test, installation, credential grant or host policy change is authorized by this document.

## Mandatory current-DT preflight — STOP conditions
Future user-authorized coder must identify the canonical Sandbox interface and existing LocalSandbox, policy owner, DataScope, operation permissions, protected paths, adapter/evidence/promotion/rollback authority, exact consumer and approved disposable test fixture. Verify actual current implementation before proposing anything. If ALREADY_PRESENT, NO_RELEVANT_CONSUMER, NO_REPRODUCED_ENFORCEMENT_GAP, NO_OWNER_AUTHORIZATION, NO_AUTHORIZED_FIXTURE, UPSTREAM_RIGHTS_UNKNOWN or VERSION_UNSUPPORTED: STOP with evidence and no code change. Do not replace governance components or force a new backend.

## Conditional transferable mechanism and interfaces
1. Keep DT as sole policy authority and retain existing Sandbox interface and trusted LocalSandbox; optional OpenShellSandbox backend only for an owner-approved untrusted/high-assurance workload. Do not port NVIDIA Landlock, supervisor, proxy, gateway, container drivers, syscall or Rust internals. Never infer that LocalSandbox is equivalently isolated.
2. Compile an approved DT SandboxPolicy/DataScope/operation permission/protected-path contract into OpenShell least-privilege effective filesystem read-only/read-write roots, process/binary identity, network destination/port/binary and supported HTTP method/path policy. Default-deny undeclared effects; reject unrepresentable DT restrictions, unsafe symlink/wildcard cases and any compiled-policy widening. Capture canonical input and output digests.
3. Prove candidate child policy within a DT-defined maximum/parent boundary only for prover-supported modeled domains. Treat unsupported GraphQL/MCP, wildcard/path and symlink semantics as UNKNOWN/UNPROVEN, never PASS. A `within_boundary` answer alone does not establish task sufficiency or actual runtime enforcement. Capture dynamic network updates, provider attachment rules and effective runtime policy; fail closed on mismatch.
4. Conditional execution lifecycle: owner authorize → compile and validate → check child ≤ maximum where supported → create isolated sandbox → bind approved provider/secret endpoints without raw credential exposure when feasible → execute → capture allow/deny events and runtime identity → destroy and verify cleanup. Static filesystem/process rules versus dynamic network rules must be tested separately.
5. Store sandbox ID/version, DT source and policy revisions/digests, compiled and effective policy digests, prover coverage/result/unsupported list, execution identity, network/provider bindings, denied filesystem/network/process actions, exit, policy changes, cleanup/rollback and evidence owner in existing ledger. Promotion must independently verify expected revision, actual enforcement, forbidden effects and cleanup; test success alone is insufficient.
6. Explicit backend detection/configuration `local | openshell` may be considered only within current owner-approved architecture. If required OpenShell is unavailable, compilation/prover/enforcement fails, provider expands authority, or cleanup cannot be proved: BLOCK/UNKNOWN, no silent fallback to unrestricted LocalSandbox. Retain existing policy registry, AdapterEnforcer, L0/L1/L2, evidence ledger, Borg, capability fabric, assimilation, memory, routing, FICs and promotion/rollback ownership.
7. Version-pin compatible upstream OpenShell and test policy/compiler/runtime regressions before upgrade. The historical proposal to route external code, autonomous workers, self-evolution and Borg paths through OpenShell by default is CONDITIONAL ONLY after separate user/owner approval, real proof and rollout authorization; do not change routes or enable default behavior here.

## Required future tests and negative controls
Use the same approved disposable workload for DT baseline versus OpenShell and measure both false denials and missing denials. Include filesystem escape and intermediate symlink, forbidden process/shell/binary, DNS/network exfiltration, metadata-service access, unauthorized REST POST/DELETE, credential theft/leak, child policy widening, provider-added permission expansion, unsupported prover feature, stale/mismatched policy digest, unavailable backend, policy compiler failure, runtime negative effects, restart, cleanup, rollback and no-fallback bypass. Test positive allowed work and deny-before-effect with actual effective-policy capture, not only prover output. Compare runtime enforcement against DT's declared prohibition; keep evidence privacy/retention/permission limits. Future proof package may cover backend availability, policy translation, bounded prover result, containment, credentials, denial evidence, cleanup and upgrades, but no new proof package is authorized now.

## Source-section → prompt-section transfer matrix
| Historical predecessor | Live distillation | This prompt | Disposition |
|---|---|---|---|
| 1–4, 14–15, 20 | interface, authority, compiler, LocalSandbox | mechanism 1–2, 6 | COVERED conditionally |
| 5–6, 22 | high-risk/self-evolution routing | mechanism 7 | COVERED as unapproved future option |
| 7–8 | boundary prover/child containment and unsupported caveats | mechanism 3 | COVERED with UNKNOWN negatives |
| 9–10 | provider bindings, fine-grained L7 | mechanism 2, 4 | COVERED conditionally |
| 11–13, 19 | evidence, promotion, fail-closed proof | mechanism 5–6; tests | COVERED |
| 16–18 | lifecycle, adversarial and comparative tests | mechanism 4; tests | COVERED |
| 21 | pinned upgrades | mechanism 7; tests | COVERED |
| all | source rights, preflight, no DT claims | provenance; STOP gates | COVERED |

Status: `PROMPT_READY_PENDING_INDEPENDENT_REVIEW / SOURCE_RETAINED / NOT_EXECUTED`. Scout alone may certify full coverage and decide SHA-guarded original retirement. This prompt does not implement DT.
