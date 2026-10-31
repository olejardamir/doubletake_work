# APR standalone formal evolution — A6 (Run A, 2026-10-20)

**Classification:** **provisional, additive assurance amendment** to recovered A1→A5 chain, not a verified complete implementation of original v3.5-F. SHA-256 preimage work and neural networks excluded. **Source recovery:** local A5 archive SHA-256 `762c82a8450b183912a9e9c5a10fe71b2f93c748dd9606a37e0c82892f4e217e` was recovered; its manifest, pinned A4 parent archive, and all 122 tests were verified. The shared registry initially contained only `BOOTSTRAP_UNVERIFIED`, no verified HEAD. Prior original v3.5-F source remains missing; its 164 claimed tests are NOT counted.

## Formal state and lineage

APR historical claimed lineage: `v3.4-F → v3.5-F (full originals unavailable) → A1 → A2 → A3 → A4 → A5 → A6`. A1–A5 are reconstructible through the nested archived audit specifications and executable finite reference models. The A6 archive embeds the verified A5 archive, adds this amendment and executable tests. The only verified HEAD candidate is the **provisional additive assurance chain** A1–A6, not the missing original standalone v3.5-F source.

Inherited formal modules: A1 finite-world reasoning, conditional minimum interventions, verifier boundary; A2 property-preserving abstraction, three-valued status, semantic substitution and independent-branch guards; A3 concrete SAT witness, capture avoidance, four-state evidence; A4 event-sourced evidence retractions, policy-bound review freshness and typed membership; A5 Ed25519 signed externally pinned evidence chain, conditional dependency-scoped review, and strictly Boolean witness evaluation.

## A6-01: Artifact-grounded signed evidence

### Falsification

A5's `authenticated_review_stamp` verifies a source's signature over a claim containing a 64-character `artifact_sha256`, but **never obtains the alleged artifact bytes**. A valid source can therefore sign a fabricated hash or a nonexistent artifact and still obtain a review freshness stamp. A valid signature proves key possession, not artifact availability or semantic truth. Reproduced in `test_a5_allows_review_without_artifact_bytes`.

### Corrected reference semantics

Let `L` be a signed ledger; `A(L)` its active claims after full signature, trust-root and revocation verification; `D` the declared conservative proposition-dependency closure for proposition `p` (or all propositions under global fallback); and `B` an artifact inventory indexed by claim ID. Define the required active set:

`Q(L,p,D) = { c ∈ A(L) : D=GLOBAL or c.proposition ∈ D }`.

The artifact binding obligation is

`ArtifactOK(L,p,D,B) := ∀c∈Q(L,p,D): type(B[c.id])=bytes ∧ SHA256(B[c.id])=c.artifact_sha256`.

The reference review stamp additionally binds the ordered canonical digest

`h_B = H("APR-A6-ACTIVE-ARTIFACTS-v1" || canon(sort_by_claim_id{(id, proposition, SHA256(B[id])):c∈Q}))`.

Issuance requires **all** of: A5 externally pinned signed replay, supported-only evidence status for `p`, A6-02 freshness scope, and `ArtifactOK`. A prior stamp is current only if these conditions hold **again** and all bound stamp fields match. Missing bytes, non-`bytes` values, and hash mismatch cause fail-closed rejection. For a scoped review, irrelevant active claims outside the certified dependency closure do not need artifacts; for global fallback, all active claims do.

**Conditional theorem A6-T1 (artifact binding).** Assuming collision resistance of SHA-256, correct implementation of the reference verifier, and an authentic externally pinned signed ledger, issuance implies that every currently active in-scope claim has available bytes whose digest matches its signed claim digest. Proof: the only issuance branch checks every member of `Q`, compares bytes and digests, and hashes the resulting ordered set. Currentness recomputes the checks. This **does not** establish that the bytes are accurate, independently observed, unmanipulated at collection, semantically relevant, or retained indefinitely. Availability is only at verification time. A reviewer still must evaluate the actual evidence.

**Counterexamples:** A5 signs a nonexistent claim and stamps it; A6 rejects. A5 continues to accept a stamp after external artifact disappearance because it never reads artifacts; A6 rejects currentness. A6 also rejects wrong bytes, mutable-type substitutes, and missing relevant dependency artifacts. Unrelated missing artifacts can be ignored under a separately sound dependency overapproximation.

## A6-02: Delegated revocation without needless global invalidation

### Falsification

A5's scoped projection invokes `replay(events)` without passing authorized delegates. If a valid event revokes a relevant claim through a registered delegate, `replay` fails and A5 **falls back to global hashing**. An unrelated subsequent event then invalidates the review unnecessarily. This is safe but contradicts A5's desired dependency-scoped efficiency for valid delegated events.

### Corrected semantics

First validate the **entire** ledger with its externally pinned delegate map: `replay(L, D_auth) → (all_claims, active_claims)`. Then project the already-validated ledger onto the reported sound overapproximation `Cl_G(p)` by including every `ADD` for propositions in that closure and every `REVOKE` whose target claim belongs to the closure. Include all event metadata in the canonical projection. Bind the stamp to `H(projection)`, review policy digest, and `H(universe, reported graph, reference graph)`. Do not project *before* validating the complete ledger. The full signed ledger is independently verified against the current host-pinned head before issuing or checking a stamp.

**Conditional theorem A6-T2 (scoped freshness).** Under A5's independently sound reference graph assumption, fixed externally pinned delegation registry, collision-resistant hashing, and full signed-ledger verification, any added/revoked relevant claim changes the projected ledger digest and invalidates an earlier stamp. Changes exclusively outside the certified closure leave the projection unchanged and may leave the stamp current. Proof: the validated projection includes each relevant event in order; unique event IDs and collision resistance distinguish changed projections. A delegated revocation is now correctly classified without global fallback. This theorem does **not** establish real-world graph soundness, temporal delegation authorization, or protection against compromised trust roots.

**Counterexamples:** A5 reports `GLOBAL` for an authorized delegated Q revocation when reviewing P depending on Q. A6 reports `SCOPED`, preserves currentness after an unrelated R event, invalidates after a relevant Q event, and rejects an unauthorized delegate even when the target is irrelevant to P.

## APR applied to APR itself

**R6-A (source-grounding assumption):** Treat the statement "a signed artifact hash implies accessible evidence" as a falsifiable assumption. APR separates source authenticity, byte availability, and factual correctness, then proposes the independent `ArtifactOK` obligation. The concrete A5 counterexample and A6 negative tests support accepting A6-01 as a bounded formal assurance improvement. This is a self-application candidate **checked separately** by executable tests; self-reference is not its proof.

**R6-B (overbroad fallback):** Treat "delegated revocations force global invalidation" as a contingent implementation shortcut. Reframe it as "validate complete authorization before projecting a dependency-scoped history". Compare A5 and A6 on the same signed ledger; tests establish preservation of sound fail-closed behavior and reduced unnecessary invalidation for the chosen fixture. Accept A6-02 provisionally.

**Rejected/deferred:** Treating available artifacts as true evidence; claiming proof of dependency graph soundness; assuming immutable global trust registry can rotate keys correctly; accepting self-generated tests as fully independent certification; asserting improved general-purpose APR discovery efficiency. No production-grade authorization mechanism or unrestricted mathematical completeness claim.

## Verification ledger

- Recovered A5 archive digest matched previously published `762c82a8450b183912a9e9c5a10fe71b2f93c748dd9606a37e0c82892f4e217e`.
- `python verify_bundle.py` on recovered A5: **PASS**, 21 files, pinned parent digest.
- `python run_regression.py` on recovered A5: **PASS**, A1 25, A2 29, A3 14, A3 manifest 4, A4 21, A5 29 = **122/122** targeted tests.
- `python -m unittest -v apr_a6_checks`: **PASS 20/20** new tests, including 39 exhaustive signed event-append label sequences and 8 artifact-inventory subsets; explicit old-vs-new counterexamples.
- Cumulative total **142/142** targeted tests. These are bounded reference tests, not a proof of universal APR soundness or general discovery advantage.
- The reference test suite and formal argument were created in the same investigation. Independent external audit and real-world semantic validation are still needed.

## Operational cross-worker merge rule (not counted as a mathematical upgrade)

A branch may advertise an A6 patch only as a descendant of its **exact** A5 archive digest. A competing branch must be compared by actual ancestor digests and patch content; no automatic merge from version number or wall clock. If an independently validated competing HEAD exists, preserve both and mark `MERGE_REQUIRED`. The shared registry's `HEAD` should not claim recovery of the missing original v3.5-F implementation. A future integration must run all predecessor suites and check proof assumptions; a green test count is necessary but not sufficient.

## Remaining proof obligations and next frontier

1. Recover original full v3.5-F specification, historical source and claimed 164 tests; reconcile formal definitions with additive amendments.
2. Independently validate semantic dependency graph soundness and predicate-to-world correspondence; otherwise global fallback is required.
3. Establish signed artifact collection/retention, evidence authenticity and truth evaluation; A6 only verifies byte-to-digest correspondence at review time.
4. Introduce **temporal authorization semantics** for key rotation, compromise, revocation and policy updates without retroactively changing historical authorization; require externally anchored epochs and test temporal consistency.
5. Harden artifact retrieval against races, malicious storage, unavailable blobs, resource exhaustion and non-canonical serialization.
6. Conduct independent cross-worker proof review and empirical discovery benchmarks with preregistered baselines, equal budgets and holdouts.
7. Establish durable content-addressed storage and read-back of the full A6 cumulative archive; shared registry alone is insufficient unless referenced source is retrievable.

## Reproduction and handoff

A6 cumulative ZIP contains the exact A5 parent ZIP, this complete A6 audit, A6 reference code/tests, A5/A4 imports needed for the new suite, logs, a JSON checkpoint, a hash manifest and verification scripts. Extract and run `python verify_bundle.py` and `python run_regression.py` from the A6 directory. Check parent archive digest and `APR_A6_CHECKPOINT.json`. A1–A5 materials remain nested in the A5 archive; inspect original sources before claiming full integration. If A6 is not recoverable, report `RECOVERY_NEEDED` and resume only from the latest actually verified parent.
