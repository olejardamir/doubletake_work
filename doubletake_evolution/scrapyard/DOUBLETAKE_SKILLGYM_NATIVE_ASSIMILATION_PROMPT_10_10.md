# DoubleTake SkillGym Native Assimilation — Verified Skill Effect + Trajectory Internalization Loop

## Target repositories

DoubleTake:

`/home/glompy/Desktop/OTHER_PROJECTS/DT/`

SkillGym donor/reference:

`/home/glompy/Desktop/ASTROCYTECH/Assimilate/SkillGym/`

Upstream donor:

`https://github.com/ECNU-ICALK/SkillGym.git`

Treat current DoubleTake `main` as authoritative.

This is an **execution prompt**. Inspect, implement, test, repair, and prove the
work. Do not stop at an architecture plan or TODO list.

If the donor checkout does not exist, clone it read-only:

```bash
mkdir -p /home/glompy/Desktop/ASTROCYTECH/Assimilate
git clone https://github.com/ECNU-ICALK/SkillGym.git \
  /home/glompy/Desktop/ASTROCYTECH/Assimilate/SkillGym
```

Record the exact donor SHA before implementation.

---

# 0. Mission

Assimilate the useful SkillGym mechanisms into DoubleTake as a native extension
of the already-complete `skill2env_compilation` pipeline.

Do **not** build a second task-generation framework.

Do **not** replace Skill2Env.

Do **not** duplicate DoubleTake evaluation, evidence, Harvest, capability
distillation, promotion, or governance authorities.

The target architecture is:

```text
SOURCE SKILL / CAPABILITY
        ↓
existing skill2env_compilation
        ↓
verified task candidate
(static + freeze + Oracle PASS + NOP FAIL)
        ↓
NEW: paired WITH-CAPABILITY / WITHOUT-CAPABILITY agent execution
        ↓
NEW: capability-effect classification
        ↓
NEW: evidence-driven task repair when the pair is invalid or non-discriminating
        ↓
NEW: successful verified trajectory archive
        ↓
NEW: governed experience asset
        ↓
existing Harvest / capability distillation / evaluation / governance
```

The central new question is:

> Does access to the target skill/capability materially cause successful task
> execution under a controlled paired comparison?

A task is evidence of skill dependence only when the with-capability run
succeeds and the without-capability run executes validly but fails the same
frozen verifier.

Interpret this correctly: it measures the **effect of exposing the external
capability under the tested model/harness/runtime**, not whether the underlying
model had zero prior knowledge of the procedure. Record that limitation in
durable evidence and reports.

---

# 1. Existing DoubleTake systems remain authoritative

Before changing code, inspect the live repository and reuse the current owners.

At minimum re-check:

`tools/doubletake_evolve/skill2env_compilation/`

`tools/doubletake_evolve/evaluation_suite/`

`tools/doubletake_evolve/evidence_bundle/`

`tools/doubletake_evolve/governed_knowledge/`

`tools/doubletake_evolve/collective_core/harvest_*`

`tools/doubletake_evolve/collective_core/capability_distillation/`

`tools/doubletake_evolve/promotion/`

`tools/doubletake_evolve/final_governance_gate/`

`tools/doubletake_evolve/rollback_recovery/`

The current Skill2Env closure is already complete. Preserve:

- source bundle and provenance handling;
- task planning and materialization;
- frozen task contracts;
- static/build validation;
- Oracle execution;
- NOP execution;
- atomic publication;
- evaluation-suite bridge;
- evidence-bundle bridge;
- parent/candidate comparison;
- promotion/final governance;
- rollback provenance.

SkillGym adds capability-effect evidence and verified trajectory learning assets
after these existing guarantees. It does not reopen them unless a real
integration bug is found.

---

# 2. Donor scope and evidence boundary

Audit the real SkillGym source, not only the paper.

Required donor files include at least:

```text
README.md
LICENSE
task_builder/README.md
task_builder/docs/task-generation-pipeline.md
task_builder/src/cli.ts
task_builder/src/codex.ts
task_builder/src/discovery.ts
task_builder/src/harbor_metrics.ts
task_builder/src/manifest.ts
task_builder/src/materialize.ts
task_builder/src/prompts.ts
task_builder/src/published.ts
task_builder/src/schema.ts
task_builder/src/skill_effect.ts
task_builder/src/skill_effect_artifacts.ts
task_builder/src/trace_archive.ts
task_builder/src/utils.ts
task_builder/src/validate.ts
task_builder/src/workspace.ts
task_builder/tests/
```

Mechanisms to classify:

- template/skill discovery;
- planning and authoring;
- blocking review;
- static validation;
- runtime validation;
- separate repair budgets;
- with-skill / no-skill paired execution;
- valid reward-failure distinction;
- skill-effect bucket classification;
- repair from runtime and pair evidence;
- publication dispositions;
- paired trace archive;
- successful trajectory retention;
- append-only manifest/resume behavior;
- runtime metrics capture;
- provenance and sanitized publication.

For each donor mechanism classify:

```text
EXISTING_NATIVE
EXTEND_NATIVE
NEW_NATIVE
NOT_MATERIAL
```

Do not copy SkillGym TypeScript into DoubleTake merely because it exists.

Use this initial native mapping, then verify it against the live code:

```text
SkillGym discovery/template plumbing
    → EXISTING_NATIVE: Skill2Env source bundle/workflow generation

SkillGym planner/writer
    → EXISTING_NATIVE / EXTEND_NATIVE: Skill2Env planner + creator

SkillGym blocking reviewer
    → EXTEND_NATIVE: bounded pre-runtime review/findings

SkillGym static + Harbor Oracle validation
    → EXISTING_NATIVE: BuildAuditor + frozen Oracle/NOP + evaluation suite

SkillGym with_skill / no_skill gate
    → NEW_NATIVE: capability-effect pair runner

SkillGym repair from pair/runtime evidence
    → EXTEND_NATIVE: Skill2Env repair/regeneration loop

SkillGym trace archive
    → NEW_NATIVE: pair + trajectory archive

SkillGym manifest/resume
    → EXTEND_NATIVE: existing tracker/output/persistence

SkillGym Codex SDK specifics
    → NOT_MATERIAL: use DoubleTake provider/agent authority

SkillGym Harbor/E2B/Daytona-specific commands
    → NOT_MATERIAL as dependencies: use DoubleTake governed runtime
       (support Harbor only if already intentionally configured)

SkillGym seed-task directory convention
    → NOT_MATERIAL as authority: keep Skill2Env task package contract

SkillGym foundation-model SFT
    → NOT_MATERIAL_FOR_THIS_PHASE: export verified assets only
```

Do not import the SkillGym dataset or model as part of this implementation.

The repository code is MIT-licensed, but dataset skills/assets can retain
upstream licensing. Preserve provenance and license metadata for any donor
artifact actually reused.

---

# 3. Explicitly out of scope: large-model training

SkillGym also studies model internalization through supervised fine-tuning.

Do **not** implement or claim reproduction of that training stage here.

The released SkillGym repository states that standalone end-to-end training code
is not included. The reported paper training setup uses large-scale accelerator
resources.

This prompt implements the reusable part that DoubleTake can own now:

```text
verified task construction
+ capability-effect measurement
+ verified trajectories
+ governed experience assets
```

Create an export interface for future training/distillation consumers, but do
not fine-tune a foundation model in this assimilation.

Do not claim that DoubleTake has "internalized" a skill into model weights.

Use the term **experience internalization asset** for the durable wrapper-level
learning artifact until a real model-training consumer exists and is separately
verified.

---

# 4. Native target files

Extend the existing Skill2Env package.

Create, unless the current repository already has an equivalent canonical owner:

```text
tools/doubletake_evolve/skill2env_compilation/skill_effect.py
tools/doubletake_evolve/skill2env_compilation/trajectory_archive.py
tools/doubletake_evolve/skill2env_compilation/experience_assets.py
tools/doubletake_evolve/skill2env_compilation/repair.py
```

Modify as necessary:

```text
tools/doubletake_evolve/skill2env_compilation/models.py
tools/doubletake_evolve/skill2env_compilation/pipeline.py
tools/doubletake_evolve/skill2env_compilation/output.py
tools/doubletake_evolve/skill2env_compilation/cli.py
tools/doubletake_evolve/skill2env_compilation/batch.py
tools/doubletake_evolve/skill2env_compilation/prompts.py
```

Integrate, do not fork:

```text
tools/doubletake_evolve/evaluation_suite/
tools/doubletake_evolve/evidence_bundle/
tools/doubletake_evolve/collective_core/harvest_models.py
tools/doubletake_evolve/collective_core/harvest_evaluation.py
tools/doubletake_evolve/collective_core/capability_distillation/
```

Add focused tests under the repository's current canonical Skill2Env test
location. Do not create duplicate mirrored test suites unless the repository
currently requires both.

Create evidence under:

```text
reports/skillgym_assimilation/
```

## 4.1 Exact pipeline insertion point

In the current `SkillCompilationPipeline._run_skill()` path, the new SkillGym
logic belongs **after**:

```text
task materialization
→ BuildAuditor/static validation
→ freeze verification
→ Oracle PASS
→ evaluation-suite execution
→ NOP PASS
```

and **before** the current irreversible/durable downstream sequence:

```text
final evidence bundle
→ parent/candidate comparison
→ rollback provenance
→ promotion/final governance
→ final publication
```

Refactor the current method so the order becomes:

```text
GENERATE TASK
    ↓
STATIC / BUILD VALIDATION
    ↓
FROZEN CONTRACT
    ↓
ORACLE PASS
    ↓
NOP PASS
    ↓
SKILL-EFFECT POLICY?
    ├─ off      → legacy path
    ├─ audit    → run pair, record result, continue legacy publication
    └─ required → require strict skill-dependence for internalization path
                     ↓
                 repair/re-freeze/revalidate if appropriate
                     ↓
                 or retain as evaluation-only / move to next candidate
    ↓
PAIR / TRAJECTORY EVIDENCE
    ↓
FINAL EVIDENCE BUNDLE
    ↓
PARENT/CANDIDATE + GOVERNANCE
    ↓
PUBLICATION
```

Do not persist a final evidence bundle claiming strict capability dependence
before the paired run exists.

Do not send a non-strict task into the **internalization** path merely because
Oracle/NOP passed.

For `audit`, preserve current task publication semantics and attach the
effect classification as additional evidence.

For `required`, a task may still be retained as a valid general evaluation task,
but it is not eligible for trajectory-internalization sampling unless the
strict skill-effect criterion passes.

---

# 5. Core data model

Add native typed contracts.

## 5.1 Capability exposure mode

```text
WITH_CAPABILITY
WITHOUT_CAPABILITY
```

The only intended experimental difference between a pair is exposure to the
target capability bundle.

## 5.2 Run validity

Every agent execution must be classified independently of reward:

```text
VALID
INVALID_INFRA
INVALID_PROTOCOL
INVALID_VERIFIER
INVALID_TIMEOUT
INVALID_CANCELLED
```

A no-capability run counts as a meaningful failure only when the run itself is
VALID and the frozen verifier produces a valid failing reward/verdict.

Infrastructure failure is never evidence that a skill is necessary.

## 5.3 Skill-effect buckets

Implement the semantic equivalent of SkillGym's buckets:

```text
WITH_PASS__WITHOUT_VALID_FAIL
WITH_PASS__WITHOUT_INVALID_FAIL
WITH_FAIL__WITHOUT_VALID_FAIL
WITH_PASS__WITHOUT_PASS
WITH_FAIL__WITHOUT_PASS
```

Map them to DoubleTake dispositions:

```text
WITH_PASS__WITHOUT_VALID_FAIL
    → SKILL_DEPENDENT
    → eligible for verified trajectory sampling

WITH_PASS__WITHOUT_PASS
    → NOT_SKILL_DEPENDENT
    → task may remain a general evaluation task
    → not eligible as evidence that the target skill caused success

WITH_FAIL__WITHOUT_VALID_FAIL
    → TASK_OR_AGENT_FAILURE
    → repair/retry within budget

WITH_FAIL__WITHOUT_PASS
    → NEGATIVE_SKILL_EFFECT_OR_TASK_CONFOUND
    → reject/repair

WITH_PASS__WITHOUT_INVALID_FAIL
    → INCONCLUSIVE
    → repair infrastructure/variant/verifier issue or retry
    → never classify as skill-dependent
```

Preserve the raw bucket and the higher-level disposition.

## 5.4 Required records

Add typed records equivalent to:

```text
CapabilityExposureManifest
SkillEffectRunEvidence
SkillEffectPairResult
TrajectoryRecord
TrajectoryArchiveEntry
ExperienceInternalizationAsset
RepairRecord
```

Every durable record must include or reference:

- source skill/capability ID;
- source bundle digest;
- task ID;
- frozen task contract digest;
- verifier digest;
- environment digest;
- pair ID;
- exposure mode;
- model/provider/harness identity;
- run identity;
- workspace identity;
- result/reward;
- validity classification;
- trajectory digest where available;
- timestamps;
- schema version.

Use current DoubleTake hashing/canonical JSON utilities.

---

# 6. Capability exposure contract

The paired experiment is meaningful only if the two variants differ in exactly
the intended capability exposure.

Create a `CapabilityExposureManifest` or native equivalent.

The exposure mechanism must be **outside the frozen task package**. Do not
create the pair by mutating `instruction.md`, `task.toml`, `tests/`, fixtures,
or the environment tree after freeze.

Prefer a governed read-only sidecar/context attachment:

```text
frozen task package              identical in both branches
+
agent capability exposure       variable under test
```

If the source capability is text-only, attach its public skill text through the
current governed agent-context mechanism. If it has supporting scripts/assets,
make them available through a read-only capability mount/attachment owned by
the agent runtime. Record the exact exposed file manifest and digest.

For `WITH_CAPABILITY`:

- expose the exact target skill/capability bundle through an explicit governed
  mechanism;
- record the source bundle digest;
- expose only the public skill material needed by a normal agent;
- never expose solution files, verifier internals, Oracle output, or hidden
  generation state.

For `WITHOUT_CAPABILITY`:

- use the same task;
- use the same environment;
- use the same model/harness configuration;
- use the same tools and normal ambient capabilities;
- remove only the target capability exposure.

Do not weaken the no-capability condition by removing unrelated tools the agent
would normally have.

Do not strengthen it by changing task instructions, verifier, timeouts, model,
environment, normal tool availability, system policies, or unrelated context.

Ambient capabilities that a normal DoubleTake agent would have must be held
constant across both branches. Only the target capability under test changes.

The host must be able to prove which target bundle was exposed or withheld.

Capability text/assets are procedural context, not authority. They must not
grant filesystem/network/process permissions, change governance policy, or
override the evaluator. All effects remain behind the existing DoubleTake
authorization boundaries.

Add leakage checks so the without-capability workspace/context does not contain
the target skill bundle by accidental copy, prompt inclusion, generated
metadata, or leftover workspace state.

SkillGym implements its no-skill variant partly by stripping skill-copy lines
from a task environment. In DoubleTake, prefer the cleaner native mapping above:
keep the frozen task identical and vary an external governed capability
attachment. Only use task-package rewriting if the live DoubleTake runtime
cannot express external exposure, and if so create both variants from the same
pre-variant frozen source, compute separate variant digests, and prove that the
only semantic delta is the target capability material. Do not silently mutate
one accepted frozen package.

---

# 7. Controlled paired execution

Implement the paired run in:

`tools/doubletake_evolve/skill2env_compilation/skill_effect.py`

Define a narrow `TaskAgentRunner` protocol or equivalent for **agentic task
execution**, not plain text completion.

The production adapter must reuse the current DoubleTake agent execution path
that can actually operate inside a task workspace, invoke tools, and leave
observable effects. Inspect the live repository and bind to the canonical
OpenCode/Codex/session/agent runtime rather than guessing a filename.

`ModelRunner.complete()`-style text completion alone does **not** satisfy this
stage unless the task itself is purely text and the frozen verifier genuinely
grades that text artifact.

The test adapter may be deterministic and local, but must implement the same
`TaskAgentRunner` contract.

Use the current production model/provider/runtime authority.

Do not build a new inference stack.

Do not make Harbor, E2B, Daytona, or the donor's Codex SDK mandatory
dependencies if DoubleTake already has a native governed execution route.

Provide clear functions or equivalent methods such as:

```text
build_exposure_manifest(...)
run_effect_variant(...)
classify_variant_result(...)
classify_skill_effect_pair(...)
run_skill_effect_pair(...)
```

Keep classification deterministic and host-owned. The model/agent generates
behavior; it does not decide whether the experiment passed.

For each accepted frozen task candidate:

```text
PAIR ID
   ├─ WITH_CAPABILITY
   │    fresh workspace
   │    target capability exposed
   │    agent executes task
   │    frozen verifier executes
   │    trace captured
   │
   └─ WITHOUT_CAPABILITY
        separate fresh workspace
        target capability withheld
        same task/model/harness/budget
        agent executes task
        same frozen verifier executes
        trace captured
```

Both branches must independently verify the same frozen task contract before
execution.

Required pair controls:

- independent pristine workspaces;
- same frozen task digest;
- same verifier digest;
- same environment digest;
- same model identity;
- same harness/runtime identity;
- same execution/tool budget;
- same timeout policy;
- same task instruction;
- no solution/Oracle leakage;
- only capability exposure differs.

Persist pair metadata before execution so interrupted runs remain auditable.

Support an optional bounded `pair_replicates` setting for stochastic production
agents. Each replicate is a separate pair with separate workspaces and
evidence. Never convert invalid infrastructure replicates into no-capability
failures. If a summarized effect decision is requested, derive it from the
valid replicate buckets under an explicit deterministic threshold/policy and
retain every underlying pair result. Default deterministic test coverage may
use one replicate.

---

# 8. Agent result and reward semantics

Do not reduce the pair to process exit codes.

Parse the authoritative task verifier result.

Record:

- verifier execution status;
- reward or metric leaves;
- task success/failure;
- infrastructure validity;
- agent/runtime failure;
- timeout/cancellation;
- tool-call/run metrics where available.

A strict capability-dependent result requires:

```text
WITH_CAPABILITY:
    run validity = VALID
    verifier = PASS
    required reward/metrics = full passing threshold

WITHOUT_CAPABILITY:
    run validity = VALID
    verifier = valid FAIL
    reward/metrics below passing threshold
```

`WITHOUT_CAPABILITY` crashing, timing out because of infrastructure, failing to
start, missing reward output, or producing a corrupt verifier result is
INCONCLUSIVE, not skill dependence.

---

# 9. Evidence-driven repair loop

SkillGym repairs task candidates using blocking-review, runtime, verifier, and
skill-effect evidence.

Implement the same useful behavior natively.

The existing Skill2Env task becomes a **candidate** after static/Oracle/NOP
validation.

If the paired capability-effect gate does not yield a strict skill-dependent
result, determine whether repair is appropriate.

Repair may modify only task-authoring artifacts such as:

- public instruction;
- environment fixture design;
- verifier;
- task metadata;
- task assets.

Never modify the source skill/capability merely to force the pair to pass.

Every repair invalidates the previous frozen contract.

Therefore the repair cycle is:

```text
pair fails classification
        ↓
collect exact evidence
        ↓
repair task candidate
        ↓
static/build validation
        ↓
new freeze
        ↓
Oracle
        ↓
NOP
        ↓
new paired skill-effect run
```

Do not run skill-effect evaluation against a task whose frozen contract has been
mutated.

Do not "repair toward the test" by introducing hidden requirements whose only
purpose is to make the no-capability branch fail. A repaired task must still
represent a realistic workflow supported by the source skill's documented
procedure. Reject a task instead of manufacturing an artificial dependency on
a specific phrase, file path, secret token, or exact skill wording.

## Separate budgets

Use independent bounded budgets for:

```text
pre-runtime repair
Oracle/NOP/runtime repair
skill-effect repair
full task restart
```

Expose them in config/CLI.

Do not permit an unbounded automatic repair loop.

## Evidence supplied to repair

Include:

- blocking/static issues;
- Oracle/NOP evidence;
- verifier stdout/result/reward;
- with-capability result;
- without-capability result;
- bucket/disposition;
- relevant trace summaries;
- attempt/cycle identity.

The repair prompt must reason from the evidence rather than merely ask to
"improve the task."

Use this decision table:

```text
WITH PASS / WITHOUT VALID FAIL
    accept strict effect; no repair

WITH PASS / WITHOUT PASS
    inspect for trivial task, shortcut, leaked capability content, or verifier
    that ignores the capability-critical workflow
    repair only if the source skill supports a realistic stronger task
    otherwise classify VERIFIED_BUT_NOT_SKILL_DEPENDENT and move on

WITH FAIL / WITHOUT VALID FAIL
    treat as task/agent unusability first
    inspect instruction, assets, verifier, capability exposure and runtime
    repair within budget, then re-freeze and rerun Oracle/NOP before new pair

WITH FAIL / WITHOUT PASS
    inspect harmful/misleading skill exposure or pair confound
    reject or repair; never call this useful dependence

WITH PASS / WITHOUT INVALID FAIL
    repair/retry infrastructure, variant construction, or verifier plumbing
    do not make the task harder merely to convert an invalid failure into a
    valid failure
```

---

# 10. Blocking review before expensive execution

SkillGym uses a blocking review before runtime.

If current Skill2Env already has equivalent host validation, extend it rather
than creating a separate LLM authority.

Add a bounded pre-runtime review for task-specific problems that static schema
checks cannot reliably detect, especially:

- instruction leaks solution/verifier internals;
- verifier depends on hidden requirements;
- initial untouched environment already satisfies the task;
- target capability is unnecessary because the task is trivial;
- target capability is directly copied into the answer;
- no-capability branch would retain an obvious shortcut;
- reference solution or verifier directly depends on the injected skill path;
- task is a near-duplicate of an already accepted sibling when current
  corpus metadata can establish that.

The review produces findings.

Host-owned validation and Oracle/NOP remain authoritative.

---

# 11. Publication semantics

Do not replace the existing Skill2Env accepted-task corpus.

Add a capability-effect overlay/disposition.

At minimum preserve these conceptual publication states:

```text
SKILL_DEPENDENT
VERIFIED_BUT_NOT_SKILL_DEPENDENT
INCONCLUSIVE
REJECTED
```

Only `SKILL_DEPENDENT` tasks become sources for skill-internalization trajectory
sampling.

Map the donor publication semantics explicitly:

```text
SkillGym pf_success
    ≈ DoubleTake SKILL_DEPENDENT

SkillGym oracle_fallback_success
    ≈ DoubleTake VERIFIED_BUT_NOT_STRICTLY_SKILL_DEPENDENT / EVALUATION_ONLY
```

Do not use an Oracle-only fallback as proof that the target skill matters.

A task that is Oracle/NOP-valid but no-capability also passes may remain useful
as a general evaluation task. Do not falsely relabel it as a skill-dependent
task.

A task with invalid no-capability execution may be retained privately for
repair/debugging but not accepted as skill-dependent.

Publication must be atomic and digest-bound to:

- task;
- frozen contract;
- pair result;
- source capability;
- provenance.

---

# 12. Paired trace archive

Create:

`tools/doubletake_evolve/skill2env_compilation/trajectory_archive.py`

Archive every skill-effect pair, including failed/inconclusive attempts, for
debugging and research evidence.

Suggested durable layout:

```text
<state-or-output-root>/skill_effect/
  <skill_id>/
    <task_id>/
      <pair_id>/
        pair_result.json
        with_capability/
          result.json
          trajectory.json
          metrics.json
        without_capability/
          result.json
          trajectory.json
          metrics.json
```

Use current DoubleTake durable state/output conventions rather than hard-coding
this exact path if another canonical state root exists.

Each archive entry must bind to source and task digests.

Expose narrow functions or equivalents:

```text
archive_skill_effect_pair(...)
normalize_runtime_trajectory(...)
archive_verified_trajectory(...)
load_verified_trajectory(...)
```

Do not store secrets, API keys, auth files, or unredacted protected content.

Use existing redaction/sanitization before durable archival.

---

# 13. Verified trajectory sampling

After a task is classified `SKILL_DEPENDENT`, use it as a trajectory generator.

Add configurable sampling support.

A sampling configuration should be able to specify:

- one or more model/provider identities;
- one or more governed harness/runtime identities;
- maximum trajectories per matrix cell and total maximum;
- concurrency;
- timeout;
- tool-call/run budget;
- seed where supported;
- capability exposure mode.

For internalization assets, sample the `WITH_CAPABILITY` condition.

Support a bounded model × harness sampling matrix so DoubleTake can collect
diverse successful workflows without coupling the archive format to one agent
implementation. A single configured production combination is valid; the
architecture must not hard-code one model/harness.

Do not let one model/harness failure invalidate already verified trajectories
from another cell. Record cell identity explicitly.

A trajectory is accepted for learning only when:

```text
task freeze integrity PASS
+
agent run VALID
+
frozen verifier PASS
+
required reward threshold PASS
+
trajectory parse/normalization PASS
+
redaction PASS
```

Archive unsuccessful trajectories for diagnostics only.

Deduplicate successful learning trajectories by a stable normalized content
digest while preserving distinct provenance when two runs independently
produce the same normalized sequence.

Do not put failed trajectories in the successful-learning corpus unless a
future explicitly typed consumer requests failure data separately.

---

# 14. Trajectory normalization

Define a stable DoubleTake-native trajectory schema.

Capture as available:

```text
trajectory_id
source_skill_id
source_bundle_digest
task_id
frozen_contract_digest
pair_id
model
provider
harness
run_id
started_at
completed_at
messages / reasoning-visible outputs where policy permits
tool calls
tool results
file/effect summaries
verifier result
reward metrics
final outcome
token/runtime/tool-call metrics
source trace references
redaction status
content digest
```

Do not require private chain-of-thought.

Do not fabricate unavailable reasoning.

Preserve only observable messages, actions, tool calls/results, artifacts, and
verifier evidence that the runtime is actually authorized to retain.

Normalize provider-specific traces into a common schema while retaining a
reference to the raw private trace when allowed.

---

# 15. Experience internalization asset

Create:

`tools/doubletake_evolve/skill2env_compilation/experience_assets.py`

Convert one or more verified successful trajectories into a durable
`ExperienceInternalizationAsset`.

This is not automatically a production capability.

The asset should include:

- source capability identity and digest;
- skill-dependent task IDs;
- successful trajectory IDs/digests;
- task/verifier/freeze digests;
- observed workflow/action patterns that are evidence-backed;
- measured capability effect;
- model/harness identities;
- limitations;
- license/provenance;
- source redistribution/training-use status when known;
- contamination/redaction status.

Do not infer training or redistribution permission from the SkillGym repository
MIT license. Source skills and assets may have different upstream terms.
Represent unknown permission as unknown and retain the original notices.

Produce a canonical digest.

Expose functions or equivalents:

```text
build_experience_asset(...)
validate_experience_asset(...)
export_experience_jsonl(...)
emit_harvest_evidence(...)
```

Support deterministic export to JSON/JSONL for future:

- supervised fine-tuning;
- distillation;
- retrieval/procedural memory;
- capability synthesis;
- offline analysis.

Do not make any training framework a dependency of the core implementation.

The export format must contain enough observable sequence structure to support a
future trainer without requiring the trainer to reconstruct hidden runtime
state. At minimum preserve ordered user/system-visible messages where
retention is allowed, tool/action calls, tool/action results, artifact/effect
references, final answer/output, verifier result, and provenance.

Never export secrets or private chain-of-thought.

---

# 16. Feed experience into existing Harvest and capability distillation

Integrate the new assets with existing DoubleTake evidence systems.

Use existing:

`HarvestEvidenceRecord`

`HarvestEvidenceLedger`

and current capability-distillation contracts.

Do not directly promote a trajectory into production.

Create evidence records that reference:

- source skill;
- task;
- pair result;
- successful trajectory;
- effect classification;
- experience asset digest.

Where a capability candidate is distilled, populate measurable evidence such
as:

```text
problem
mechanism
inputs
outputs
expected_behavioral_effect
measurements
evidence references
```

Then allow the existing Gate A / Gate B and later R0-R6 evaluation process to
decide what DoubleTake should do with that evidence.

The new trajectory pipeline is an evidence producer, not a promotion bypass.

If `governed_knowledge` already has a canonical typed ingestion route suitable
for these assets, register the `ExperienceInternalizationAsset` there as an
inactive/candidate evidence source. Do not invent a second knowledge registry.
Do not make governed-knowledge registration a prerequisite if Harvest already
provides the canonical consumer path.

---

# 17. Evaluation and governance integration

Extend existing evidence-bundle support to reference:

```text
SKILL_EFFECT_PAIR
WITH_CAPABILITY_RESULT
WITHOUT_CAPABILITY_RESULT
TRAJECTORY
EXPERIENCE_INTERNALIZATION_ASSET
```

Use current event/evidence naming conventions.

For any downstream candidate influenced by these assets, preserve:

- source bundle digest;
- task corpus digest;
- trajectory digests;
- parent/candidate identity;
- evaluation evidence;
- promotion decision;
- rollback provenance.

A trajectory-derived capability must still pass existing evaluation and
promotion rules.

---

# 18. Resume and idempotency

SkillGym preserves published state and append-only run records.

Add equivalent behavior using current DoubleTake persistence.

On restart:

- completed pair results are reusable only when all referenced digests still
  match;
- completed successful trajectories are not re-run unnecessarily;
- corrupt/missing referenced artifacts invalidate resume;
- a partial pair resumes or restarts according to explicit state;
- duplicate trajectory/event IDs are idempotent;
- accepted corpus state cannot be silently overwritten.

Use atomic writes and append-only evidence where current DoubleTake policy
requires it.

---

# 19. Resource and cost bounds

Paired execution and trajectory sampling multiply runtime cost.

Add explicit budgets for:

- maximum pair replicates;
- maximum skill-effect repair rounds;
- maximum task restarts;
- maximum trajectories per model/harness cell;
- total trajectory samples;
- concurrency;
- wall-clock timeout;
- tool-call budget where the runtime exposes it;
- token/cost budget where the provider exposes it.

Budget exhaustion is a typed outcome such as `BUDGET_EXHAUSTED` or
`INCONCLUSIVE`; it is never converted into evidence that the skill is needed.

Cancellation must terminate active agent work cleanly and persist the last
known state/evidence.

---

# 20. CLI and configuration

Extend the existing Skill2Env CLI rather than creating a second top-level task
builder.

Add semantically equivalent options such as:

```text
--skill-effect-policy off|audit|required
--max-skill-effect-repair-rounds N
--max-task-restarts N
--skill-effect-replicates N
--trajectory-samples N
--trajectory-concurrency N
--trajectory-model MODEL
```

Use repository naming conventions if equivalent options already exist.

Semantics:

```text
off
  preserve legacy Skill2Env behavior

audit
  run paired capability-effect evaluation and record classification
  but do not make it a prerequisite for ordinary evaluation-task publication

required
  require strict SKILL_DEPENDENT classification for
  experience-internalization eligibility
```

Do not silently change legacy Skill2Env publication behavior until tests and
migration evidence justify it.

Batch mode must support the same policy.

---

# 21. Deterministic test provider and real production path

All tests must be runnable without paid remote model calls.

Use dependency-injected deterministic fake providers/agents through the same
public interfaces used by production.

Do not put fake-success behavior in the production default path.

Production provider/runtime failure must be explicit.

At least one optional smoke test may use a real configured agent/model/runtime,
but closure must not depend on credentials being present.

---

# 22. End-to-end deterministic proof fixture

Create a small nontrivial skill fixture where the expected contrastive result is
known.

Example semantics:

- target skill contains a procedural transformation rule;
- task requires applying that rule to a fixture;
- with-capability deterministic agent follows it and passes;
- without-capability deterministic agent produces a plausible but wrong result;
- frozen verifier distinguishes them.

The proof must execute:

```text
source skill
  ↓
skill2env task candidate
  ↓
static/build validation
  ↓
freeze
  ↓
Oracle PASS
  ↓
NOP FAIL
  ↓
WITH_CAPABILITY agent run PASS
  ↓
WITHOUT_CAPABILITY valid run FAIL
  ↓
SKILL_DEPENDENT
  ↓
successful trajectory archived
  ↓
ExperienceInternalizationAsset
  ↓
HarvestEvidenceRecord
  ↓
capability-distillation evidence input
```

Also include negative fixtures proving:

```text
both pass → NOT_SKILL_DEPENDENT
without-capability infra crash → INCONCLUSIVE
with fails / without passes → NEGATIVE_SKILL_EFFECT_OR_TASK_CONFOUND
```

---

# 23. Focused tests

Prefer these files in the current canonical Skill2Env test directory:

```text
test_skill_effect.py
test_skill_effect_repair.py
test_trajectory_archive.py
test_experience_assets.py
test_skillgym_e2e.py
```

Modify existing `test_pipeline.py`, `test_cli.py`, and `test_batch.py` where the
new path crosses existing behavior.

Add focused tests for at least:

- strict skill-effect bucket classification;
- TaskAgentRunner production/test seam;
- proof that plain completion is not silently substituted for agentic execution;
- valid failure vs infrastructure failure;
- same frozen task/verifier across pair;
- independent workspaces;
- with-capability exposure;
- without-capability withholding;
- capability leakage detection;
- exact same model/harness/budget metadata;
- repair invalidates old freeze;
- repair creates a new frozen contract;
- bounded skill-effect repair;
- publication dispositions;
- pair archive;
- pair resume/idempotency;
- trajectory normalization;
- only verified successes enter learning corpus;
- failed trajectory diagnostic retention;
- redaction;
- experience asset digest;
- JSON/JSONL export;
- Harvest evidence creation;
- capability-distillation evidence bridge;
- evidence-bundle references;
- production provider failure is explicit;
- fake provider requires explicit injection;
- CLI policy modes;
- batch policy modes.

---

# 24. Regression tests

Run directly affected existing suites:

```text
skill2env_compilation
evaluation_suite
evidence_bundle
governed_knowledge
Harvest
capability_distillation
promotion
final_governance_gate
rollback_recovery
provider/runtime integration touched by this work
```

Do not repair unrelated pre-existing failures unless this change caused them.

Record exact commands and outcomes.

---

# 25. Donor mechanism matrix

Create:

`reports/skillgym_assimilation/mechanism_matrix.json`

For every material SkillGym Task Builder mechanism record:

```text
donor file
donor symbol/mechanism
donor behavior
DoubleTake disposition
DoubleTake implementation
production path
test
evidence
status
```

Allowed final statuses:

```text
REAL
NOT_MATERIAL
```

Any `PARTIAL`, `STUB`, `UNWIRED`, or `FALSE_POSITIVE` material mechanism blocks
closure.

Do not claim training reproduction: mark SkillGym foundation-model SFT as
`NOT_MATERIAL_FOR_THIS_PHASE` with the reason that the released repository does
not provide a standalone end-to-end training implementation and this
assimilation intentionally produces training-ready assets only.

---

# 26. Source coverage

Create:

`reports/skillgym_assimilation/source_coverage.json`

Record:

- donor repository URL;
- donor SHA;
- donor file SHA256;
- material symbols/helpers;
- mechanism mapping;
- implementation/test/evidence path;
- disposition.

Audit material private helpers as well as public functions where they carry
behavior such as:

- pair construction;
- reward parsing;
- failure classification;
- repair budgets;
- trace copying;
- publication path safety;
- resume state.

No placeholder hashes.

No one-row-per-file shortcut.

Zero unclassified material mechanisms.

---

# 27. Final evidence

Create:

```text
reports/skillgym_assimilation/final_evidence.json
reports/skillgym_assimilation/final_report.md
```

Bind them to the exact final implementation HEAD.

Include:

- DoubleTake HEAD;
- donor SHA;
- source coverage;
- mechanism counts;
- skill-effect implementation;
- repair implementation;
- trajectory archive;
- experience asset bridge;
- Harvest/capability-distillation bridge;
- tests;
- deterministic end-to-end proof;
- known limitations.

Do not declare complete if the report contradicts the mechanism matrix or
actual tests.

---

# 28. Anti-false-completion rules

The following do not count as implementation:

- defining a bucket enum without executing paired runs;
- copying the source skill into both pair variants;
- treating a crashed no-skill run as evidence of skill dependence;
- generating fake trajectories from prompts rather than runtime traces;
- marking a task skill-dependent because an LLM reviewer says so;
- creating a JSON asset that has no real successful trajectory behind it;
- routing directly to promotion without Harvest/evaluation gates;
- claiming foundation-model internalization without actual model training;
- adding unit tests that only instantiate dataclasses;
- production code that silently substitutes a fake provider;
- evidence JSON that says COMPLETE while code remains stubbed.

---

# 29. Final closure gates

Declare complete only when all are true:

1. Skill2Env remains the authoritative task-generation pipeline.
2. No duplicate task-builder subsystem was created.
3. The exact SkillGym donor SHA is recorded.
4. Material SkillGym Task Builder mechanisms are audited.
5. A real TaskAgentRunner production adapter executes tasks; plain completion is not silently substituted.
6. Paired WITH_CAPABILITY / WITHOUT_CAPABILITY execution is real.
7. Both variants use the same frozen task or an explicitly proven semantically identical variant contract.
8. Both variants use the same frozen verifier.
9. Both variants use the same model/harness/budget configuration.
10. Only target capability exposure differs.
11. Capability exposure is outside the frozen task package in the preferred native path.
12. Without-capability leakage is checked.
13. Capability exposure cannot grant new authority or bypass governance.
14. Valid task failure is distinguished from infrastructure/protocol/verifier failure.
15. Strict skill dependence requires with-pass + without-valid-fail.
16. With-pass + without-pass is not mislabeled as skill dependence.
17. Invalid without-capability failure is INCONCLUSIVE.
18. Reverse effect is rejected or repaired.
19. Optional pair replicates preserve every underlying result and never treat invalid runs as failures.
20. Repair is evidence-driven.
21. Repair never modifies the source skill merely to force dependence.
22. Repair does not manufacture hidden/artificial skill bottlenecks.
23. Repair invalidates the old frozen contract.
24. Repair and restart budgets are bounded.
25. Pair results are durably archived.
26. Resume/idempotency verifies referenced digests.
27. Successful trajectories are captured from real executions.
28. Failed trajectories do not enter the successful-learning corpus by default.
29. Successful trajectories are normalized and deduplicated without fabricating private reasoning.
30. Trajectory archives and exports are redacted.
31. ExperienceInternalizationAsset is digest-bound to real evidence.
32. Training-ready export exists without requiring a training framework.
33. License/provenance and unknown training/redistribution permission are preserved.
34. No unsupported claim of model-weight internalization is made.
35. Harvest receives trajectory/effect evidence.
36. Capability distillation can consume that evidence.
37. Existing evaluation/governance remains the promotion authority.
38. Evidence bundle can reference pair/trajectory/experience assets.
39. CLI supports effect policy, replicates, bounded repair, and bounded sampling.
40. Batch supports the same policy.
41. Production provider/runtime failures are explicit.
42. Deterministic fake runtime is test-injected only.
43. End-to-end strict positive fixture passes.
44. Both-pass negative fixture is classified correctly.
45. Infra-failure fixture is classified INCONCLUSIVE.
46. Reverse-effect fixture is classified correctly.
47. Focused tests are green.
48. Affected regressions show no new failures.
49. Mechanism matrix has zero unresolved material mechanisms.
50. Source coverage has zero placeholder hashes and zero unclassified material behavior.
51. Final evidence is bound to the exact final implementation HEAD.
52. Final report agrees with code, tests, mechanism matrix, source coverage, and real runtime evidence.

---

# 30. Iteration loop

Repeat until every closure gate passes:

```text
1. inspect current main
2. inspect exact donor SHA
3. update mechanism/source coverage
4. pick highest-value unresolved mechanism
5. implement it natively in the existing DoubleTake owner
6. add positive and negative tests
7. run focused tests
8. run affected regressions
9. run the deterministic end-to-end proof
10. persist real evidence
11. re-audit for stubs/false-positive mappings
12. continue
```

Do not stop because the file count is large or because an implementation report
looks complete.

Stop only when the runtime behavior and evidence prove closure.

---

# 31. Final output

At completion print:

## DoubleTake SkillGym assimilation report

### Repository
- branch:
- final HEAD:
- working tree:

### Donor
- repository:
- SHA:
- license:

### Skill-effect
- pair runner:
- exposure contract:
- strict bucket:
- validity handling:
- leakage check:
- repair budgets:

### Trajectories
- archive:
- successful count:
- failed diagnostic count:
- normalization:
- redaction:
- resume/idempotency:

### Internalization assets
- asset schema:
- export:
- Harvest bridge:
- capability-distillation bridge:

### Tests
- focused:
- regressions:
- end-to-end proof:

### Evidence
- mechanism matrix:
- source coverage:
- final evidence:
- final report:

### Limitations
State real limitations, including that this phase does not train a foundation
model unless a separately verified training implementation was actually added.

### Closure decision

Output exactly:

`SKILLGYM_ASSIMILATION_COMPLETE`

only when all 52 closure gates pass.

Otherwise output:

`SKILLGYM_ASSIMILATION_INCOMPLETE`

with exact failing gate IDs and continue the iteration loop.
