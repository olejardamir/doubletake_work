# DT-IP-0037 — Evidence-register disposition comparison completeness (conditional)

**State:** PROMPT_READY_PENDING_INDEPENDENT_REVIEW / NOT_EXECUTED. **Private DT parity:** UNKNOWN. This is a future user-invoked LLM coder inspection prompt, not authority to change code or evidence.

## Source and provenance
- Full current public original: `doubletake_evolution/scrapyard/TMP_MATRIX_REGISTER_COMPARISON.md`, Git blob `1859dc3d88dabc65f9d0cb4893a09ca00aadaa56`; [public source](https://github.com/olejardamir/doubletake_work/blob/main/doubletake_evolution/scrapyard/TMP_MATRIX_REGISTER_COMPARISON.md).
- Full historical original: same path, blob `cd5656a8d7e381cd685beab8893672005145d752`; retrieve from Git history. Historical unit `TASK_5_EVIDENCE_CLOSURE_MATRIX / FIC-L1-PLAN-915`, described as **in progress**, not verified as a current defect. Source is project-authored historical operator text; no external licensed code is required. Do not treat archived commands as authorization.
- Clauses compared: historical token vocabulary, G25 discrepancy, mapping rules, focused tests, generator verification, dependent evidence regeneration, guard/rollback and authority preservation. Current distillation captures them; old private paths and workflow directives remain historical hypotheses.

## Distinct, independently testable mechanism
A closure matrix may silently skip an evidence-register disposition because its comparator recognizes only a subset of declared tokens. Historical example: `DEMONSTRATED_SYNTHETIC`, `INFERRED`, `DEFERRED`, `EXTERNALLY_SCOPED`, `BLOCKED` were declared; comparator reportedly handled only the first, third and fourth. G25 register `BLOCKED` versus matrix `PARTIAL` yielded `register_agrees: null` instead of a substantive comparison.

**Conditional invariant:** For an authorized, current matrix/register contract, compare every known non-null disposition; `BLOCKED` and `INFERRED` count as non-PASS claims and agree only with `DEFERRED`, `PARTIAL`, or `MISSING_EVIDENCE` (subject to verifying current canonical status vocabulary). Known mismatch: `register_agrees=false` and `register_disposition_disagrees:<token>`. Unknown non-null token: `false` and `register_disposition_unknown:<token>`. Absent token alone retains `None`. Never reinterpret a blocked disposition as PASS, change underlying gate outcomes, or conceal unknown values.

## Future authorized coder preflight — mandatory
1. Only when explicitly invoked by the user, inspect CURRENT private DT source, tests, permissions and actual consumer. Historical candidate paths: `tools/doubletake_evolve/governed_ingestion/closure_matrix.py` (`_finish_row`), `docs/governed_agent/evidence_register.md`, and `tools/doubletake_evolve/governed_ingestion/tests/test_closure_matrix.py`. Do not assume paths or G25 still exist.
2. Identify the canonical vocabulary, ownership of matrix/register and downstream acceptance/checkpoint consumers. Exit `NO_APPLICABILITY` if absent, `ALREADY_PRESENT` if complete, or `NO_AUTHORIZED_FIXTURE` if an isolated reproducible test is unavailable. Do not claim a live defect based on this archive.
3. If applicable and authorized, prefer minimal in-place comparator/test repair; no parallel generator, controller, authority grant or private-code publication. Verify baseline before change.

## Frozen positive and negative controls
- P1: `BLOCKED + PARTIAL` yields true, not null; historical G25 expected `register_disposition=BLOCKED`, `register_agrees=true` **only if current evidence confirms those values**.
- P2: `INFERRED + DEFERRED/PARTIAL/MISSING_EVIDENCE` yields true; `None` stays unprovided.
- N1: `BLOCKED + PASS` yields false with `register_disposition_disagrees:BLOCKED`; `INFERRED + PASS` likewise false.
- N2: unknown non-null token yields false with `register_disposition_unknown:<token>`, not null or pass.
- N3: existing `DEMONSTRATED_SYNTHETIC`, `DEFERRED`, `EXTERNALLY_SCOPED` mappings do not regress; malformed/missing evidence never becomes a false PASS.
- N4: no row status, decision, blocker, digest-exclusion, acceptance authority or mission checkpoint semantics change merely because comparison coverage improves. Protect G6/G25 blockers and `AWAITING_AUTHORIZED_ACCEPTANCE` where still applicable.

## Validation and evidence (future only)
With owner-approved clean isolated tree and host guard, run focused matrix tests and canonical generator `--verify`; compare generated matrix JSON/MD before/after. If authorized, regenerate dependent acceptance/checkpoint strictly using their current canonical generators and verified dependency order; historical names `closure_acceptance.py` and `mission_state.py` are pointers, not commands to execute now. Bind clean source revision, output digests and tests to commits; record exact outcome and any guard refusal. Stop on concurrent guarded workload, unrelated test failure, unauthorized artifact writes, changed blockers/decision, or failed verification. Never bypass host guard or claim synthetic-only checks establish actual DT Ground. Roll back only through authorized, canonical regeneration preserving protected history and external effects.

**Definition of done:** Only a future explicitly authorized coder may report a code fix after current applicability, tests, independent output comparisons and commit receipts. Otherwise record `ALREADY_PRESENT`, `NO_APPLICABILITY`, `NO_AUTHORIZED_FIXTURE`, or precise blocker. The Transformer has not run DT tests, modified private code, or deleted the public source.

## Coverage handoff for independent Scrapyard Scout
Current and historical originals were fully read; mapped: vocabulary and missing-case example → invariant; nonpass/unknown/null behavior → controls; G25 and G6/acceptance constraints → negatives; test/generator/checkpoint/guard/rollback → future-only validation. Historical instruction to delete a temporary file is **not** authorization to delete this source. Scout alone independently checks source-to-prompt coverage, canonical overlap, and any safe source retirement.
