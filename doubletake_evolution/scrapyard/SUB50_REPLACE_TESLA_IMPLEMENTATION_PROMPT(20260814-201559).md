# IMPLEMENTATION PROMPT — REMOVE TESLA COMPLETELY, REMOVE ADAPTIVE N-DEPTH, AND REPLACE WITH FIXED SUB50 CERTIFICATION + EXISTING VOTING

You are modifying the extracted `tesla_engine.zip` project.

Make the changes directly. Do not merely describe them.

When finished:

1. run the bounded tests in this prompt;
2. fix every failure;
3. create a complete runnable zip named `sub50_engine.zip`;
4. list files added, modified, deleted;
5. report exact tests and results;
6. give the exact run command.

Do not run the full multi-hour POC.

---

# 0. FINAL ARCHITECTURAL DECISIONS

These decisions supersede older Tesla/direct-core/replay/depth behavior.

## 0.1 Remove Tesla completely

Tesla must disappear from active code, state, logging, CLI text, recipe metadata, files, maturity logic, release logic, safety logic, recertification, debt, reservoir, pressure, and promotion logic.

Delete:

```text
tesla.py
tesla_algorithm.py
tesla_integration.py
tesla_logging.py
```

Delete `reference_i10_single.py` if it is only a historical Tesla monolith.

No active Python file may import Tesla.

## 0.2 Remove the v400 direct-core path

`coordinator.run_once()` currently short-circuits into:

```python
return run_direct_calibration_once(args, state)
```

Remove that early return and remove `direct_core.py`.

The intended active behavioral path is again:

```text
Phase32/Phase33 model training
    ->
SUB50 final-model certification
    ->
existing weak-signal fixed-flip vote
    ->
persist working inference recipe
    ->
future runtime inference
```

## 0.3 NO adaptive N/depth engine

Do not recreate Tesla maturity using a new name.

Delete the concept of:

```text
global N
synchronized depth
N promotion
11 -> 13 -> 15
depth maturity
depth histories
depth invalidation
replay-discovered deeper N
supervised depth promotion
frozen-candidate depth promotion
```

There is no adaptive observation depth.

Use two fixed constants instead:

```python
FIXED_TRAINING_OBSERVATIONS = 10
SUB50_WITNESS_COUNT = 101
```

Rationale:

- the current Tesla integration's nominal minimum release floor is 10 accepted **trainer observations**;
- in the current wrapper, one observation is one successful call to the helper's
  `train_normal_model(...)` that actually mutates the behavioral training state;
- this is NOT necessarily one low-level `optimizer.step()` inside the helper;
- retaining 10 fixed accepted trainer observations preserves the old observable
  training clock without Tesla maturity;
- 101 is a fixed odd witness-bank size;
- SUB50 correctness does not improve mathematically by promoting witness count.

These constants may be made command-line configurable for laboratory testing only, but they must not adapt during a run and must be persisted in the inference recipe.

`SUB50_WITNESS_COUNT` must always be positive and odd.

## 0.4 "WHEN" is deterministic now

Do not wait for measured `normal_acc < 0.5`.

The moment is:

```text
exactly FIXED_TRAINING_OBSERVATIONS accepted trainer observations complete
    ->
final model is frozen
    ->
fixed odd witness bank of SUB50_WITNESS_COUNT rows is complete
    ->
all witnesses are re-scored with that one final model
```

At that moment, the exact complementary-pair theorem guarantees one physical polarity is below 50% on the witness bank.

So calibration does not search for a lucky below-50 event.

## 0.5 Replay as recertification/retraining validation is removed

Remove:

```text
immediate replay after calibration
replay retry
replay recertification
replay maturity
replay-driven model/depth repair
same-target replay loop logic
replay debt
establishment replay whose purpose is to reconstruct calibration
```

However, do NOT simply delete the runtime reconstruction algorithm.

The current `_replay_detector_recipe()` performs an essential second job:
it rebuilds/trains the behavioral model for the CURRENT recovered prefix/boundary.

That prefix/boundary changes with each new target.

Therefore a single calibration-time model weight file is not generally a valid replacement.

Refactor the essential part into:

```text
inference.py
infer_ai_bit(...)
_run_detector_inference(...)
```

This is runtime inference, not calibration replay.

It must:

1. rebuild the model under the current recovered prefix/boundary;
2. run the fixed training procedure for exactly 10 accepted trainer observations;
3. construct the fixed 101-row non-private witness bank;
4. freeze the final model;
5. SUB50-certify which physical polarity is below 50%;
6. use that certified polarity to normalize the vote;
7. run the existing bounded weak-signal vote on the current `A_narrow`;
8. return the predicted bit.

No private target is used for steps 1–8.

## 0.6 Keep an inference recipe, not a replay recipe

The project still needs to persist the working deterministic behavioral configuration needed to reconstruct the per-target model:

```text
backend/helper identity
model seed/configuration
working curriculum
candidate/pairing geometry
fixed training-update budget
fixed SUB50 witness-bank rule
fixed vote budget/caps/chunking/tie rule
runtime fingerprints
```

Rename:

```text
replay recipe
```

to:

```text
inference recipe
```

Examples:

```text
build_inference_recipe
save_inference_recipe
validate_private_free_inference_artifact
SUB50_INFERENCE_RECIPE_FILE
```

The inference recipe reconstructs a target-specific model. It does not recertify calibration.

---

# 1. IMPORTANT FACTS FROM THE CURRENT SOURCE TREE

These are source-derived constraints.

## 1.1 Runtime model training is prefix-conditioned

Current `replay.py::_replay_detector_recipe()`:

- calculates the legal interval from `prefix_bits` and `position`;
- maps candidate-stream rows inside that recovered-prefix interval;
- creates training representatives;
- trains a new model;
- only later uses current `a_narrow_hex` in vote feature construction.

Therefore the runtime model depends on the current recovered prefix/boundary.

Do not replace this with one calibration-time frozen model unless you redesign the whole algorithm and prove equivalent behavior.

That redesign is out of scope.

## 1.2 The current runtime reconstruction already uses a deterministic recipe

Keep the useful geometry:

```text
backend identity
deterministic model seed
pairing_state_schedule / candidate-stream seed geometry
working curriculum
vote limits
candidate chunking
prefix-conditioned mapping
pair narrow overlap cache
runtime CUDA/CPU configuration
```

Remove only Tesla/depth/replay-specific control logic.

## 1.3 Private targets are generated by `secrets`

The project uses `secrets.randbelow()` for private calibration and MAIN values.

Do not transplant the MT19937 state-recovery mock solution into this project.

It does not apply.

## 1.4 Exact helper files are external dependencies

The core zip expects exact helpers:

```text
phase32_simple_avb_anti_learning_v21_restricted_range_curriculum.py
phase32_simple_avb_anti_learning_v21_restricted_range_phase33_hybrid_curriculum.py
```

`common.py` must resolve the exact helper files using the single precedence
defined immediately below.

Do not maintain a second differently ordered search list in comments,
documentation, tests, or loader code.

Before implementing SUB50, inspect the exact active helper files.

Do not substitute similarly named variants.

Verify:

```text
train_normal_model target semantics
normal_acc semantics
make_training_representatives semantics
predict_normal_predictions / normal logits
predict_anti_predictions semantics
zero-logit behavior
whether A_private enters training/model selection
```

The SUB50 witness truth must use the exact deterministic non-private synthetic training target used by these helpers.

If the exact helper target depends on A_private, stop and report that this SUB50 design is invalid for that helper.

### Exact helper resolution precedence

Preserve one deterministic helper lookup policy.

The current source effectively gives precedence in this order:

```text
1. PHASE32_HELPERS_DIR, if explicitly set
2. <project>/helpers
3. <project>
4. <project parent>
```

for exactly:

```text
phase32_simple_avb_anti_learning_v21_restricted_range_curriculum.py
phase32_simple_avb_anti_learning_v21_restricted_range_phase33_hybrid_curriculum.py
```

Do not accidentally change that precedence through a different `sys.path`
insertion order.

Do not search for or substitute similarly named helper variants.

After import, fingerprint the **actual loaded helper contents**:

```text
module.__name__
resolved module.__file__                 # diagnostic
module source SHA256                     # correctness identity
SCRIPT_VERSION if present
DETERMINISTIC_SEED
narrower callable fingerprint
narrow_batch callable fingerprint
```

The persisted correctness fingerprint must rely on content identity, especially
the source SHA256, rather than requiring the same absolute filesystem path
across machines.

If duplicate exact filenames exist in several search locations, the precedence
above decides which copy is loaded. The selected source hash must then match the
persisted correctness fingerprint on resume.

A same-named helper with different source bytes is a correctness-fingerprint
mismatch and requires reset/rebuild.

### Helper identity

Use the exact helper files only. Do not search for similarly named variants.

Persist the selected backend/module name and the loaded helper source SHA256 so
a changed helper cannot silently reuse an old recipe.

Keep the existing exact helper-resolution mechanism unless a direct, simpler
replacement is required by the refactor. Do not build a new dependency scanner
or import-cache management framework.

# 2. TARGET END-TO-END FLOW

The final operational design should be:

```text
NEW DEVELOPMENT/CALIBRATION BIT
        |
        v
choose backend / fixed deterministic seed / working curriculum candidate
        |
        v
train for exactly FIXED_TRAINING_OBSERVATIONS accepted trainer observations
        |
        v
collect/generate deterministic non-private witness representatives
        |
        v
freeze final model
        |
        v
select exactly SUB50_WITNESS_COUNT=101 witness rows
        |
        v
score all 101 with final model
        |
        v
NORMAL bit + exact complementary ANTI bit
        |
        v
exactly identify physical SUB50_LOW
        |
        v
construct SUB50_HIGH = 1 - SUB50_LOW
        |
        v
legacy raw vote source = SUB50_HIGH
        |
        v
existing fixed exact flip => FINAL_VOTES = SUB50_LOW
        |
        v
existing weak-signal vote on the certified below-50 side
        |
        v
if development result is accepted:
persist private-free INFERENCE RECIPE
```

Future runtime:

```text
NEW MAIN A_narrow
        |
        v
load bit inference recipe
        |
        v
rebuild target-specific model under current recovered prefix/boundary
        |
        v
exactly 10 accepted trainer observations
        |
        v
build/select same deterministic 101-row witness bank
        |
        v
freeze final runtime model
        |
        v
SUB50 certify physical low polarity
        |
        v
construct SUB50_HIGH = 1 - SUB50_LOW
        |
        v
legacy fixed flip of SUB50_HIGH -> FINAL_VOTES = SUB50_LOW
        |
        v
bounded weak-signal vote on current A_narrow
        |
        v
predicted bit
```

No Tesla.

No global N.

No N promotion.

No calibration replay.

No runtime recertification loop.

---

# 3. MATHEMATICAL SUB50 CONTRACT

For one final behavioral model and one witness row `x`:

```text
P_normal(x) in {0,1}
P_anti(x)   = 1 - P_normal(x)
```

Let the deterministic non-private witness target be `y_synth`.

For W witness rows:

```text
correct_normal + correct_anti = W
accuracy_normal + accuracy_anti = 1
```

If W is odd:

```text
correct_normal != correct_anti
```

Therefore exactly one physical polarity is below 50%.

With:

```text
W = SUB50_WITNESS_COUNT = 101
```

the certificate is exact.

The theorem does not require statistical significance.

## 3.1 Exact WHERE

Because `y_synth` is a deterministic non-private training target:

```python
normal_correct = count(normal_bit == y_synth)
anti_correct = W - normal_correct
```

Then:

```python
if normal_correct < anti_correct:
    certified_low_physical = "NORMAL"
    certified_high_physical = "ANTI"
else:
    certified_low_physical = "ANTI"
    certified_high_physical = "NORMAL"
```

W is odd, so a tie is impossible.

## 3.2 Final-model requirement

Do not combine predictions from changing model states.

Correct sequence:

```text
train
train
...
10th accepted trainer observation
freeze
score all 101 witnesses with THIS final model
certify
vote
```

Incorrect:

```text
prediction after update 1
prediction after update 2
...
combine them into certificate
```

That would certify an online sequence, not the final voting model.

## 3.3 Exact complement requirement

Never rely on a helper anti prediction that can diverge from exact complementarity.

Canonical binary conversion:

```python
normal_bit = 1 if normal_logit > 0 else 0
anti_bit = 1 - normal_bit
```

For exact zero:

```text
NORMAL = 0
ANTI = 1
```

No random neutral fallback.

## 3.4 Scope of certainty

The certificate proves:

```text
for the final current model
on the fixed deterministic non-private witness bank
exactly one physical polarity is below 50%
and we know which one
```

It does not mathematically prove:

```text
MAIN accuracy below 50
AVB/private accuracy below 50
vote correctness = 100%
```

The existing vote remains the weak-signal exploitation mechanism.

---

# 4. NEW `sub50.py`

Create:

```text
sub50.py
```

Keep it small and auditable.

Suggested constants:

```python
SUB50_VERSION = "SUB50-COMPLEMENT-FIXED-W101-V1"
FIXED_TRAINING_OBSERVATIONS = 10
SUB50_WITNESS_COUNT = 101
```

Suggested functions:

```python
def validate_training_observations(value: int) -> int:
    # positive integer only

def validate_witness_count(value: int) -> int:
    # positive odd integer only

def normal_bit_from_logit(logit: float) -> int:
    # 1 iff logit > 0, else 0

def complement_bit(bit: int) -> int:
    # require 0/1, return 1-bit

def certify_polarity(
    *,
    normal_bits,
    synthetic_target: int,
    witness_target_semantics: str,
) -> dict:
    """
    Require odd witness count.
    Require binary normal bits and binary synthetic target.
    ANTI is constructed internally as 1-NORMAL.
    Return:
      witness_count
      normal_correct
      anti_correct
      normal_accuracy
      anti_accuracy
      certified_low_physical
      certified_high_physical
      exactly_one_below_50=True
      private_target_used=False
      witness_target_semantics
    """

def certified_low_bits(normal_bits, certified_low_physical: str):
    """
    If low physical is NORMAL -> NORMAL.
    If low physical is ANTI   -> 1-NORMAL.
    """

def certified_high_bits(normal_bits, certified_low_physical: str):
    """
    Exact complement of certified_low_bits().
    """

def legacy_raw_vote_bits(normal_bits, certified_low_physical: str):
    """
    Return SUB50_HIGH. The existing fixed flip will transform this into
    FINAL_VOTES == SUB50_LOW.
    """

def legacy_final_vote_bits(normal_bits, certified_low_physical: str):
    """
    Return SUB50_LOW and assert it equals 1 - legacy_raw_vote_bits(...).
    """
```

`sub50.py` must not import A_private/private-target machinery.

---

# 5. FIXED TRAINING PROCEDURE

Remove all adaptive-depth behavior.

## 5.1 Fixed training-observation target

Every calibration/inference model runs until:

```text
accepted trainer observations == FIXED_TRAINING_OBSERVATIONS
```

Default:

```text
10
```

A **trainer observation** is defined at the current wrapper boundary as:

> one successful invocation of the exact helper's `train_normal_model(...)`
> following a pairing event with real representatives, where that invocation
> actually mutates the behavioral training state.

This deliberately matches the existing `trace["training_steps_observed"]`
clock after Tesla refusal logic is removed.

Do NOT reinterpret this as:

```text
10 internal torch optimizer.step() calls
10 epochs
10 minibatches inside train_normal_model
```

unless the exact helper proves those are literally the same unit.

An event with:

```text
representatives is None
no X_new
no trainer call
structural refusal before training
```

does not count.

After the 10th accepted trainer observation:

```text
do not call train_normal_model again
freeze the model/training state
build/complete witness bank read-only
SUB50 certify
vote
```

## 5.2 Hard failure

Candidate generation may continue deterministically until exactly 10 accepted
trainer observations are obtained or the fixed training candidate-event cap is
reached.

If 10 observations cannot be obtained:

```text
status = INCONCLUSIVE_TRAINING_BUDGET_NOT_REACHED
```

There is no per-bit retry, alternate backend, larger budget, larger model, or
same-target recovery path.

During CALIBRATION this rejects the current whole candidate generation.

During frozen runtime inference it returns structural `INCONCLUSIVE` for that
target and does not mutate/reopen the recipe.

Do not:

```text
increase training observations
increase witness count
promote N
invoke maturity
switch backend
retry the same bit with a different seed/budget
```

## 5.3 No synchronized process-wide training depth

Delete:

```text
synchronized_required_depth
synchronize_bit_depth
synchronized_observation_depth
required_low_normal_acc_count as operational state
global depth
depth history
depth promotion
```

A compatibility `required_low_normal_acc_count=1` may be passed into an
unmodified legacy helper only if physically required to enter its vote path,
but it must have no semantic control.

Prefer to remove the compatibility dependency entirely in the wrapper.

## 5.4 One fixed backend per run/candidate — no fallback

Do not recreate the legacy second-backend opportunity after MAX removal.

Use one explicitly selected backend:

```text
--backend phase32
or
--backend phase33_hybrid
```

The selected backend is used for every AI-bit calibration recipe and for every
runtime reconstruction of those recipes.

If that backend cannot produce a structurally valid recipe for a bit, reject
the current whole candidate generation. Do not try the other backend.

The central `MODULES` registry may still contain both exact helpers because the
user may choose either one, but a run never alternates between them as a
fallback.

Persist the selected backend in state/recipe and require reset to change it.

# 6. FIXED WITNESS BANK

Witness count is independent of the fixed 10 accepted trainer observations.

Default:

```text
SUB50_WITNESS_COUNT = 101
```

## 6.1 Witness source

Witness rows must come from the exact deterministic non-private representative domain used by the helper trainer / `normal_acc`.

Expected v21-family pattern:

```text
make_training_representatives(...)
    ->
X_new
    ->
train_normal_model(... target synthetic class ...)
```

Verify exact helper semantics.

## 6.2 Accumulate a representative pool

During the 10 trainer observations, capture private-free representative rows or reproducible identities/digests.

The pool may contain many representative rows per trainer observation.

Do not choose witnesses based on current model correctness.

## 6.3 Deterministic witness selection

After training is finished:

1. freeze model;
2. build a deterministic pool from all eligible representatives;
3. select exactly 101 rows with a deterministic input-only rule.

Example:

```text
stable SHA256 ordering using:
position
backend
model seed
prefix/boundary identity
representative digest
```

Then take first 101.

Do not hash/use:

```text
A_private
expected private bit
MAIN truth
correctness
normal_acc
```

## 6.4 If fewer than 101 rows exist

Do not lower 101 and do not enter a witness-only fallback phase.

The representative pool accumulated during the fixed 10 accepted trainer
observations must contain at least 101 eligible rows.

If it does not:

```text
status = INCONCLUSIVE_WITNESS_BANK_NOT_REACHED
```

During CALIBRATION reject the current whole candidate generation.

Do not generate extra witness rows after training, call the trainer again, or
change 10/101.

## 6.5 Re-score with final model

All selected 101 witnesses must be scored only after the final model is frozen.

No further trainer/model mutation between:

```text
final witness score
SUB50 certificate
legacy raw SUB50_HIGH vote bits
final SUB50_LOW vote bits
vote start
```

---

# 7. POLARITY NORMALIZATION + EXISTING VOTING

The existing weak vote is valuable and must keep its **actual working semantic**.

Current runtime vote code does:

```python
raw_anti = predict_anti_predictions(...)
final_votes = 1 - raw_anti
```

Under exact complementarity:

```text
physical ANTI = 1 - physical NORMAL
```

therefore the legacy fixed-FLIPPED result is:

```text
final_votes = physical NORMAL
```

Tesla was trying to establish physical NORMAL as the below-50 side before this
vote was allowed to run.

Therefore the existing working vote consumes the **below-50 predictor as its
FINAL vote stream**.

SUB50 must preserve that semantic.

## 7.1 Canonical dynamic mapping

Define:

```text
SUB50_LOW  = certified below-50 physical polarity
SUB50_HIGH = 1 - SUB50_LOW
```

To preserve the legacy one-flip vote implementation:

```text
legacy raw source = SUB50_HIGH
legacy fixed flip = 1 - SUB50_HIGH = SUB50_LOW
FINAL_VOTES = SUB50_LOW
```

Do NOT feed `SUB50_LOW` into the legacy raw slot and flip it away.

That would make final votes equal the above-50 side and would reverse the
behavior the existing weak-signal vote was designed/tested around.

## 7.2 Both physical cases must work

Case A — physical NORMAL is certified below 50:

```text
SUB50_LOW  = NORMAL
SUB50_HIGH = ANTI
legacy raw source = ANTI
fixed flip -> NORMAL
FINAL_VOTES = NORMAL = SUB50_LOW
```

This exactly matches the current legacy path.

Case B — physical ANTI is certified below 50:

```text
SUB50_LOW  = ANTI
SUB50_HIGH = NORMAL
legacy raw source = NORMAL
fixed flip -> ANTI
FINAL_VOTES = ANTI = SUB50_LOW
```

This is the dynamic polarity normalization enabled by SUB50.

Never assume physical NORMAL is always low.

Never assume physical ANTI is always the raw source.

The invariant is:

```text
FINAL_VOTES == certified SUB50_LOW
```

## 7.3 Preserve the validated fixed-budget majority vote semantics

The replay-shaped v4 test exposed that the previously specified acceptance gate:

```text
minimum majority share >= 52%
Wilson lower bound > 50%
```

can turn a fully deterministic replay into `INCONCLUSIVE` even when the fixed
vote stream has a stable majority.

That is stricter than the v21-style vote behavior we are trying to preserve.

The validated replacement is:

```text
generate/scan the configured fixed vote budget
apply the existing A_narrow-dependent selection
compute FINAL_VOTES == SUB50_LOW
count ones and zeros
after the fixed budget:
    predicted bit = 1 if ones > zeros else 0
```

A tie therefore deterministically maps to:

```text
bit 0
direction "A < B"
```

matching the v21-style rule:

```python
majority = 1 if vote_ones > vote_zeros else 0
```

Wilson interval and majority share remain **diagnostic only**.

They may be logged:

```text
majority_share
majority_ci_low
majority_ci_high
```

but they must NOT decide whether a bit is accepted.

Do NOT require:

```text
majority_share >= 0.52
Wilson lower > 0.50
ADAPTIVE_CONFIDENT
```

for a valid prediction.

The only vote-stage structural refusal is something like:

```text
INCONCLUSIVE_NO_KEPT_ROWS
```

when the A_narrow-dependent selector produces zero usable vote rows within the
entire fixed generated-row budget.

Preserve:

```text
fixed tried/attempted-row budget
fixed generated-row cap
vote chunking
pair narrow overlap cache
A_narrow-dependent selection
direction mapping:
    ones > zeros -> "A > B" -> bit 1
    ones <= zeros -> "A < B" -> bit 0
```

No early confidence stop.

No adaptive extension because the majority is weak.

No reseeding/retry because the majority is weak.

No training/model/polarity change because the majority is weak.

The final invariant remains:

```text
FINAL_VOTES == certified SUB50_LOW
```

This fixed-budget majority rule is the one validated by
`sub50_replay_exact_v4.py` / `soak_replay_exact_v4.py`:

```text
same frozen recipe
same prefix/boundary
same static A_narrow
-> same SUB50 certificate
-> same fixed vote stream
-> same majority bit
```

## 7.4 Calibration A_private is strictly evaluation-only

The sampled calibration scalar's private relation/current bit must not decide
whether the per-bit recipe is accepted.

A per-bit recipe is structurally ready when:

```text
fixed 10 trainer observations complete
fixed 101-row witness certificate succeeds
fixed-budget majority vote on FINAL_VOTES=SUB50_LOW completes with at least one kept row
all persistence/runtime invariants pass
```

The known calibration truth may be logged afterward as:

```text
calibration_direction_correct_eval_only
calibration_predicted_bit_correct_eval_only
```

but a wrong diagnostic must NOT:

```text
reject the bit recipe
change backend
change seed
change curriculum
trigger another attempt
change SUB50_LOW
change training-observation target
change witness count
```

This preserves the existing v391 intent that the known per-bit calibration
relation is diagnostic only.

The only supervised acceptance gate retained by the outer POC is the **fresh
end-to-end development full-key validation after all required bit recipes are
built**.

If that full-key validation fails:

- reject the whole candidate generation;
- do not identify the failing bit as a repair target;
- do not use the mismatch position/value to tune a bit;
- start a genuinely fresh candidate generation using only monotonic generation
  counters/deterministic fresh seeds and the same fixed constants.

Frozen evaluation remains an even stricter reject-only population.

---

# 8. REMOVE CALIBRATION REPLAY; CREATE RUNTIME INFERENCE

Delete the conceptual "replay calibration" path.

Rename/refactor:

```text
replay.py
```

to:

```text
inference.py
```

Move any non-inference evaluation/target bookkeeping functions to `evaluation.py`
or keep them in coordinator if that produces less code.

## 8.1 Required inference function

Create:

```python
def infer_ai_bit(
    state,
    args,
    position,
    prefix_bits,
    a_narrow_hex,
) -> dict:
    ...
```

It replaces `replay_ai_bit()`.

## 8.2 Required target-specific reconstruction

Because training candidates are prefix-conditioned, `infer_ai_bit()` must:

1. derive the current middle split anchor from the recovered prefix;
2. if `narrower(middle) == current A_narrow`, return
   `INPUT_AMBIGUOUS_NARROW_EQUALITY` without prediction/training/voting;
3. load the bit's private-free inference recipe;
4. calculate current recovered-prefix legal interval;
5. verify the middle boundary lies inside that interval;
6. configure exact backend/helper/version;
7. build a fresh model with deterministic model seed;
8. build optimizer/training buffer if helper training requires them;
9. reproduce candidate/training geometry under the current prefix;
10. continue deterministically until exactly 10 accepted trainer observations;
11. build/select fixed 101 witness rows;
12. freeze final model;
13. SUB50 certify physical low polarity;
14. feed SUB50_HIGH into the legacy raw vote slot so the existing exact flip produces FINAL_VOTES=SUB50_LOW;
15. return predicted bit.

This is runtime inference.

Do not call it replay.

## 8.3 No runtime adaptation

Runtime inference may continue candidate generation only to satisfy the fixed requirements:

```text
10 accepted trainer observations
101 eligible witness rows
the fixed vote tried/generated-row budget
```

It may not adapt:

```text
training observation target
witness count
model capacity/depth
polarity
vote budget / selection geometry
recipe
```

## 8.4 No same-target retry loop

One inference call gets one deterministic execution.

If it returns inconclusive:

```text
return INCONCLUSIVE
```

Do not:

```text
retrain with bigger N
switch polarity
repair recipe using MAIN truth
immediately rerun unchanged inference
```

---

# 9. INFERENCE RECIPE

The recipe is still necessary because runtime reconstructs a target-specific model.

Rename all replay-recipe APIs/files.

Examples:

```text
REPLAY_RECIPE_FILE
    -> INFERENCE_RECIPE_FILE

build_replay_recipe
    -> build_inference_recipe

save_replay_recipe
    -> save_inference_recipe

validate_private_free_replay_artifact
    -> validate_private_free_inference_artifact
```

Suggested file:

```text
data/sub50_inference_recipe.json
```

## 9.1 Recipe content per AI bit

Persist:

```json
{
  "mode": "AI_SUB50_FIXED_FLIP",
  "backend": "phase32",
  "backend_module": "...",
  "backend_script_version": "...",
  "deterministic_model_seed": 123,
  "fixed_model_seed": true,

  "training": {
    "accepted_trainer_observations": 10,
    "candidate_event_hard_cap": 10000,
    "working_curriculum": {},
    "pairing_state_schedule_seed_geometry": []
  },

  "sub50": {
    "version": "SUB50-COMPLEMENT-FIXED-W101-V1",
    "witness_count": 101,
    "witness_selection_rule": "stable_non_private_representative_hash_order",
    "final_model_rescore_required": true,
    "physical_anti_rule": "1-NORMAL",
    "neutral_logit_rule": "NORMAL=0,ANTI=1",
    "private_target_used": false
  },

  "vote": {
    "decision_rule": "FIXED_BUDGET_MAJORITY",
    "raw_source_mode": "DYNAMIC_SUB50_HIGH",
    "transform": "EXACT_COMPLEMENT_TO_SUB50_LOW",
    "final_vote_mode": "DYNAMIC_SUB50_LOW",
    "hard_tried_rows": "...",
    "generated_rows_cap": "...",
    "chunk_rows": "...",
    "tie_rule": "BIT_0",
    "wilson_role": "DIAGNOSTIC_ONLY",
    "majority_share_role": "DIAGNOSTIC_ONLY",
    "confidence_gate_enabled": false
  },

  "runtime": {
    "prefix_conditioned_training": true,
    "a_narrow_used_only_for_vote": true,
    "recipe_adaptation_allowed": false
  }
}
```

Do NOT persist calibration physical low polarity as a runtime instruction.

The runtime final model may certify a different physical low side for a different prefix.

Polarity is computed fresh, privately-free, on every inference call.

Calibration physical polarity may be logged only as diagnostic metadata.

## 9.2 Recipe does not need model weights

Do not persist one calibration model as the universal runtime model.

The current algorithm trains per recovered prefix/boundary.

Persist the deterministic recipe, not one target-specific model state.

---

# 10. `backend.py` CHANGES

This is the largest implementation area.

## 10.1 Remove Tesla imports/patches

Delete:

```text
from tesla import *
Tesla threshold trainer
Tesla prediction-shift bridge
Tesla output shift/bias
Tesla input refusal
Tesla maturity
Tesla release streak
Tesla generalization safe
Tesla reserve/debt/pressure
Tesla edge probes
Tesla final release guard
```

## 10.1A Remove real A_private from the operational backend call boundary

Current `backend_args(...)` accepts:

```python
a_private_hex
```

and stores it as:

```python
ns.a_private
```

before the wrapper invokes legacy backend code.

That is too permissive for the new architecture.

Refactor the active calibration/runtime model-building primitive so the real
private calibration scalar/current private bit is **not an argument**.

Preferred active signature shape:

```python
build_certified_sub50_model(
    *,
    module,
    position,
    prefix_bits,
    boundary,
    execution_domain,
    deterministic_model_seed,
    working_curriculum,
    fixed_training_observations,
    witness_count,
    ...
)
```

No:

```text
a_private
a_private_hex
expected_bit
strict_relation
private truth
```

belongs in that operational primitive.

The current sampled calibration private value may exist in the coordinator only
for:

```text
deriving already-left prefix geometry after sample selection
evaluation-only audit of final predicted relation/bit
freshness identity/hash
```

but it must not be forwarded into training/SUB50/vote logic.

If a legacy helper's top-level `run_once(ns)` fundamentally requires
`ns.a_private`, do not pass the real value merely for convenience.

Instead:

1. prefer calling the helper's lower-level public functions directly:
   `build_model`, candidate generation, pairing, `train_normal_model`,
   prediction, Wilson/vote helpers;
2. or, only if unavoidable, pass a deterministic public/non-secret compatibility
   placeholder whose value is derived solely from allowed public geometry and
   prove that changing the real private calibration value while keeping the same
   public geometry cannot change the operational trace.

Do not let the compatibility placeholder encode the hidden current bit/relation.

Delete stale working-curriculum fields such as:

```text
last_success_a_private
```

from new active state.

## 10.2 Restore original helper trainer

`apply_backend_execution_speed(...)` currently installs Tesla-specific training/prediction behavior.

After refactor:

- use exact helper's original `train_normal_model`;
- keep only real runtime speed configuration;
- do not install a SUB50 optimizer;
- SUB50 is certification around the trained model.

## 10.3 Preserve useful machinery

Keep:

```text
Phase32/Phase33 helper loading
model construction
optimizer construction
HardReplayBuffer
candidate generation
prefix-conditioned mapping
make_training_representatives
working curriculum
pairing schedule
candidate-stream capture
vote candidate scan
select_avb_flip_indices
half_features
Wilson CI
CUDA/CPU behavior
pair narrow overlap cache
```

## 10.3A Remove legacy below-50/MAX ratchet machinery

SUB50 replaces not only Tesla release but also the old below-threshold/MAX
ratchet bookkeeping.

Delete wrapper/coordinator operational code for:

```text
current_backend_max(...)
provisional_max_low_normal_acc_count
max_low_normal_acc_count
legacy_below_50_max_eval_only
below_50_event_count
below_50_event_steps
below_50_events
below_threshold
below_threshold_count_after
below_threshold_streak_after
max_increased_this_run
max_increases_this_run
restart_after_max_increase
MAX_RATCHET
max_ratchet_trials
max_reset_events
last_max_by_backend
last_success_max
max_increases
```

Do not preserve these merely as diagnostics.

They are inherited from the old search-for-below-50 design and are redundant
once SUB50 provides the exact final-model certificate.

Also remove the user-facing:

```text
--normal-acc-threshold
```

unless the exact helper API physically requires a threshold argument.

If the helper requires one for compatibility, supply an internal fixed
non-operational value at the adapter boundary and document that the helper
result is ignored for release/certification.

Do not expose it as a tuning knob.

Backend alternation is now controlled only by the deterministic fresh-attempt
schedule in section 5.4, never by MAX ratcheting.

## 10.3B Rewrite bounded-control exceptions/results around the new semantics

Several backend support classes/functions are not Tesla-named but still encode
the old below-50 / fixed-physical-FLIPPED architecture.

### `CalibrationObservationBudgetReached`

Delete it.

Its fields:

```text
observed_below
required_below
```

belong to the old search-for-below-50 design.

The fixed 10 trainer-observation procedure does not need a second
below-threshold observation budget.

If a dedicated stop exception is useful, replace it with something explicit,
e.g.:

```python
class TrainingObservationTargetReached(RuntimeError):
    observed_trainer_observations: int
    target_trainer_observations: int
```

or simply stop through normal wrapper control flow.

### `CalibrationCandidateEventBudgetReached`

Keep the bounded anti-loop purpose but rename it generically, e.g.:

```text
TrainingCandidateEventBudgetReached
```

Its semantics are:

```text
could not obtain the fixed 10 accepted trainer observations
within the fixed candidate-event cap
```

No below-threshold/depth fields.

### `FixedVoteBudgetReached`

Rename if practical to something such as:

```text
VoteBudgetReached
```

Its semantic fields must be unambiguous under dynamic SUB50 polarity.

Replace ambiguous physical-FLIPPED names such as:

```text
flipped_ones
raw_ones
last_flipped_vote_ones
last_raw_vote_ones
fixed_vote_orientation
```

with canonical fields such as:

```text
final_vote_ones              # FINAL_VOTES == SUB50_LOW
legacy_raw_high_ones         # raw source == SUB50_HIGH
final_vote_direction
final_vote_majority_share
final_vote_majority_ci
raw_vote_source = SUB50_HIGH
final_vote_source = SUB50_LOW
vote_transform = EXACT_COMPLEMENT_TO_SUB50_LOW
```

The `.direction` property must be computed from `final_vote_ones`.


Under v4, this canonical result must carry enough information for **all**
successful vote-budget termination modes:

```text
attempted
generated
kept
final_vote_ones
legacy_raw_high_ones      # optional diagnostic/capture
stop_reason
majority_share            # diagnostic only
majority_ci               # diagnostic only
```

Its direction/bit semantics are exact:

```python
zeros = kept - final_vote_ones
predicted_bit = 1 if final_vote_ones > zeros else 0
direction = "A > B" if predicted_bit == 1 else "A < B"
```

Therefore an exact tie must return:

```text
bit 0
direction "A < B"
```

Never `direction=None`.

The result object must not encode confidence acceptance.

### `_guard_working_update(...)`

Remove old curriculum bookkeeping:

```text
provisional_max_low_normal_acc_count
last_success_a_private
vote_orientation = physical FLIPPED
orientation_locked based on old physical polarity
```

If a private-free working-curriculum update guard is still needed, retain only
the exact structural/training parameters needed by future target-specific
inference.

No correctness/private result may modify it.

### `_fixed_budget_result(...)` and `_generated_cap_result(...)`

Rewrite result dictionaries to the canonical SUB50 naming above.

Delete:

```text
restart_after_max_increase
max_increased_this_run
max_increases_this_run
normal_polarity_fallback_allowed
```

unless a field has a genuinely new non-MAX purpose.

A vote budget/cap result is:

```text
FINAL_VOTES == SUB50_LOW
fixed-budget ones/zeros counts
majority bit = 1 if ones > zeros else 0
Wilson/majority-share diagnostics
```

The result is `OK` whenever at least one usable/kept vote row exists.

Only zero kept rows may return a vote-stage structural inconclusive such as:

```text
INCONCLUSIVE_NO_KEPT_ROWS
```

### `_snapshot_backend_json_files(...)` / `_restore_backend_json_files(...)`

These may remain only if the exact helper still mutates its slot JSON files
inside one bounded attempt.

If lower-level helper calls make those files unnecessary, remove these functions
and the associated slot persistence completely.

Do not keep two overlapping rollback systems without need.

If retained, they must compose correctly with the outer
`begin_pair_transaction` / `commit_pair_transaction` /
`finalize_pair_transaction` mechanism and have a crash-recovery test.

## 10.4 Replace gate semantics

Current wrappers patch `avb_gate_passed` around Tesla/matched-depth logic.

Replace with fixed procedure:

```text
training is complete when accepted_trainer_observations == 10
SUB50 is complete when final witness bank has 101 rows and certificate succeeds
vote may begin only after both
```

Here `accepted_trainer_observations` means exactly the training clock defined in
section 6.3:

```text
one successful invocation of the exact helper train_normal_model(...)
that mutates the behavioral training state
```

Do NOT substitute an internal optimizer-step counter.

`normal_acc` must not control release.

If legacy helper requires a synthetic gate to enter voting:

```text
before certificate -> force gate false
after certificate  -> force gate true
```

This synthetic gate depends only on fixed counters/certificate.

## 10.5 Training trace

Replace Tesla/depth fields with:

```text
training_observations_target = 10
training_observations_observed
training_candidate_events
training_observation_schedule
representative_pool_count
sub50_witness_count = 101
sub50_witness_selection
sub50_polarity_certificate
sub50_certified_low_physical
sub50_certified_high_physical
vote_raw_source_mode = SUB50_HIGH
vote_transform = EXACT_COMPLEMENT_TO_SUB50_LOW
vote_final_mode = SUB50_LOW
```

## 10.6 `_prepare_fixed_flipped_working_row(...)`

Current code hard-locks physical FLIPPED before SUB50 knows which physical side is low.

Refactor.

Do not encode:

```text
physical ANTI always raw
```

Instead encode:

```text
one canonical exact flip that maps dynamic SUB50_HIGH to SUB50_LOW
```

Rename function if needed.

## 10.7 `_enforce_fixed_flipped_result(...)`

Require:

```text
valid SUB50 certificate
valid dynamic physical low side
raw vote source == certified SUB50_HIGH
operational final votes == exact complement of SUB50_HIGH == SUB50_LOW
fixed-budget majority result when kept > 0
```

A_private may be attached only as development/evaluation correctness metadata.

It must not alter result polarity.

## 10.8 New reusable backend execution primitive

Prefer one shared function used by calibration and runtime inference, e.g.:

```python
def build_certified_sub50_model(
    module,
    *,
    position,
    prefix_bits,
    boundary,
    deterministic_model_seed,
    working_curriculum,
    training_geometry,
    fixed_training_observations=10,
    witness_count=101,
    ...
) -> dict:
```

Return:

```text
model
device
training trace
witness certificate
certified low physical
```

Then separate vote code consumes current `a_narrow`, using SUB50_HIGH as the
legacy raw source so the existing fixed flip produces FINAL_VOTES=SUB50_LOW.

This minimizes calibration/runtime drift.

---

# 11. `coordinator.py` CHANGES

## 11.1 Remove direct-core bypass

Delete:

```python
return run_direct_calibration_once(args, state)
```

Delete `run_direct_calibration_once()`.

Remove direct-core imports.

## 11.2 `run_once(...)`

Make the selected Phase32 or Phase33 behavioral backend active again, but simplify it.

Per calibration attempt:

```text
fixed backend/config/seed
exactly 10 accepted trainer observations
fixed 101-row witness bank
final-model SUB50 certificate
dynamic SUB50_LOW/SUB50_HIGH certificate
fixed weak-signal vote with FINAL_VOTES=SUB50_LOW
calibration truth recorded evaluation-only
```

No Tesla.

No global N.

No depth promotion.

## 11.3 Calibration failure

Possible structural per-bit calibration failures:

```text
10 trainer observations not reached within fixed candidate-event cap
fewer than 101 eligible witness rows after the 10 observations
SUB50 structural invariant failure
vote structural failure: zero kept rows within the fixed generated-row cap
backend/helper/runtime invariant failure
```

A wrong known calibration bit/relation diagnostic is NOT a calibration failure
and cannot trigger repair.

There is exactly one calibration attempt for that bit in the current candidate
generation.

On structural failure:

```text
reject current whole candidate generation
start a fresh candidate generation if the outer POC continues
use the same selected --backend
keep fixed 10/101/vote semantics
```

Do not retry the bit, switch backend, enlarge a budget, or modify the recipe.

## 11.4 Remove replay calls

Replace:

```python
replay_ai_bit(...)
```

with:

```python
infer_ai_bit(...)
```

for MAIN/development evaluation.

Delete:

```text
last_replay_attempt_token
IMMEDIATE REPLAY
replay generation
replay retry
replay promotion
return_to_establishment_for_runtime_replay
```

One inference call is enough.

## 11.5 Development/frozen evaluation

Keep the high-level POC only in the finalized four-phase form:

```text
CALIBRATION
DEVELOPMENT_VALIDATION
EVALUATION
EVALUATION_COMPLETE
```

There is no establishment population/phase.

Development validation uses one fresh full-key target through ordinary
`infer_ai_bit()` before entering the fresh frozen evaluation population.

They must not reconstruct calibration for certification purposes.

They must not alter recipe/training constants during frozen evaluation.

## 11.5A Keep only useful runtime controls

Keep the CLI small.

Preserve only controls that are genuinely useful to run/reset/evaluate the
program, for example:

```text
--reset / --reset-all
--clean-full-passes
--evaluation-targets
--exact-suffix-max-candidates
--backend
--fast / --deterministic
```

Use fixed internal constants for the algorithm itself:

```text
FIXED_TRAINING_OBSERVATIONS = 10
SUB50_WITNESS_COUNT = 101
FIXED_VOTE_TRIED_ROWS = 200000
FIXED_VOTE_CHUNK_ROWS = current verified chunk size
```

Do not expose 10, 101, vote confidence, calibration attempts, or fallback
behavior as tuning knobs.

`--backend` must be one exact name from `BACKEND_NAMES` and is fixed for the
run/candidate. Changing it on resume requires reset.

Validation requirements:

```text
clean_full_passes > 0
evaluation_targets > 0
evaluation_targets >= clean_full_passes
exact_suffix_max_candidates >= 2
backend in BACKEND_NAMES
```

`--fast` / `--deterministic` may remain if they are already useful execution
modes, but they must not change the algorithmic 10/101/vote semantics.

## 11.6 CLI cleanup

Remove dead/compatibility CLI flags rather than carrying them forward:

```text
--single-attempt
--skip-initial-calibration
--replay-retries
--successes-per-bit
--successes-per-context
--initial-successes-per-bit
--calibration-trials-per-bit
--normal-acc-threshold
--vote-min-valid-rows
--vote-min-majority
--max-bit-attempts
```

Remove matched-depth/maturity/global-N help/error text everywhere.

Do not keep a user-facing normal-accuracy threshold: SUB50 does not use it.

Remove `--target-bit` from the production coordinator unless there is a
demonstrated external dependency on it.

A partial-bit start is incompatible with the new whole-candidate
development-validation/evaluation lifecycle unless all preceding recipes are
already present and validated.

Use unit/integration tests for focused bit testing instead.

If `--target-bit` is deliberately retained, it must be an explicitly separate
developer-only **single-bit calibration test mode** that:

```text
requires --reset
builds only that bit's structural recipe
does not run development full-key validation
does not enter frozen evaluation
does not emit a deployable full inference artifact
exits after the one bit test
```

Add optional laboratory flags only if useful:

```text
--training-observations 10
--sub50-witnesses 101
```

Validate:

```text
training observations > 0
witness count > 0
witness count odd
```

Do not permit runtime promotion/adaptation.

---

# 12. `inference.py` REPLACING `replay.py`

Create `inference.py`.

Move/refactor useful functions from `replay.py`:

```text
_candidate_numbers_from_replay_row
    -> _candidate_numbers_from_inference_row

_decode_valid_narrows
    -> keep/rename generically

_predict_raw_anti_replay
    -> replace with deterministic NORMAL + dynamic SUB50_HIGH raw-source adapter that yields FINAL_VOTES=SUB50_LOW

The replacement prediction adapter must preserve the exact active helper's
prediction-call contract.

Inspect the real helper callable(s), especially:

```text
predict_normal_predictions
predict_anti_predictions
```

and determine whether the selected helper expects:

```text
(model, features, device)
```

or:

```text
(model, features, device, generator)
```

The current runtime explicitly inspects the callable signature and, for the
four-argument form, constructs a device-appropriate `torch.Generator` and seeds
it deterministically.

Preserve equivalent behavior if the exact helper still needs it.

Requirements:

```text
no implicit unseeded global RNG consumption during vote prediction
generator device matches CPU/CUDA execution
generator seed is deterministic and recipe-derived
calibration/development/runtime reconstruction use the identical generator rule
same frozen recipe + prefix + A_narrow -> same prediction stream
```

If reproducing the current exact behavior, note that the current code creates a
fresh generator for each prediction call/chunk and seeds it with the fixed
deterministic seed before calling the helper.

Do not accidentally change this into one continuously advanced generator unless
the exact helper audit and regression tests deliberately establish that as the
new canonical rule.

Persist/fingerprint the prediction RNG rule/version, for example:

```text
prediction_rng_rule = FRESH_DEVICE_GENERATOR_PER_CALL_FIXED_SEED
prediction_rng_seed_source = deterministic_model_seed
```

or the exact verified replacement.

If the helper is truly deterministic and has no generator argument, record that
fact explicitly:

```text
prediction_rng_rule = NONE_HELPER_DETERMINISTIC
```

Do not infer callable arity from a Tesla wrapper.

After Tesla prediction wrappers are deleted, inspect the **original exact
helper callable**.

If any compatibility wrapper remains, preserve the original callable signature
for introspection or bypass the wrapper entirely.

Failure to determine a supported exact prediction signature is a structural
helper incompatibility, not a reason to guess a call shape.

_middle_boundary_for_recovered_prefix
    -> keep

replay_ai_bit
    -> infer_ai_bit

_replay_detector_recipe
    -> _run_detector_inference

exact_suffix_recover
    -> keep
```

Move target/evaluation bookkeeping functions to `evaluation.py` if that makes the code cleaner:

```text
_new_validation_target
_current_validation_target
record_establishment_target_failure
record_full_target_evaluation_failure
_finish_full_target
...
```

No active function/file should use "replay" terminology for runtime prediction.

## 12.1 `_run_detector_inference(...)`

Remove:

```text
required_observation_depth
normal_acc threshold release
Tesla maturity extension
Tesla release safe
below-50 observation count
replay label-free depth promotion
replay recertification
input-refusal Tesla semantics
saved calibration vote seed batches as certification
```

Implement:

```text
fixed 10 accepted trainer observations
fixed 101 witness certificate
dynamic SUB50_LOW
current A_narrow vote
```

## 12.2 Training candidate continuation

Runtime may need more candidate events than calibration because current prefix geometry differs.

That is allowed.

But continuation serves only to satisfy:

```text
10 accepted trainer observations
101 witness rows
```

within fixed caps.

It does not increase targets.

## 12.3 Fixed-budget vote scan

The v4 rule supersedes the old adaptive-confidence continuation logic.

For each current static `A_narrow`, scan the one deterministic vote stream until
the first fixed structural budget boundary:

```text
fixed tried/attempted-row target reached
or
fixed generated-row cap reached
```

There is **no**:

```text
adaptive confident stop
minimum-valid-row stop
minimum-majority stop
Wilson stop
```

At the stop boundary:

```text
if kept > 0:
    ones = count(FINAL_VOTES == 1)
    zeros = kept - ones
    predicted_bit = 1 if ones > zeros else 0
    status = OK
else:
    status = INCONCLUSIVE_NO_KEPT_ROWS
```

This rule applies identically whether the scan reaches:

```text
the fixed tried-row target
or
the generated-row cap first
```

Therefore:

```text
generated-row cap + kept > 0 -> still return the deterministic majority bit
generated-row cap + kept == 0 -> structural INCONCLUSIVE_NO_KEPT_ROWS
```

A different current `A_narrow` may select a different number of kept rows, but
that does not change the recipe or stop rule.

The vote stream may continue beyond any calibration-time saved seed rows using
the same deterministic candidate continuation geometry, but only until the
fixed structural budget above.

This is ordinary deterministic inference, not replay adaptation.

---

# 13. `state.py` CHANGES

Massively simplify state semantics.

## 13.1 Remove all depth state

Delete:

```text
INITIAL_GLOBAL_SYNC_DEPTH
HARD_MAX_GLOBAL_SYNC_DEPTH
MAX_LABEL_FREE_SYNC_DEPTH
synchronized_required_depth
synchronize_bit_depth
promote_synchronized_depth_from_maturity
promote_synchronized_depth_from_establishment_replay_failures
promote_synchronized_depth_from_direct_calibration_failure
promote_synchronized_depth_after_failed_frozen_candidate
depth histories
required_observation_depth as adaptive state
required_low_normal_acc_count as durable semantic state
```

Do not replace them.

## 13.1A Remove the old adaptive-vote state/artifact schema explicitly

## 13.1B Strict recursive new-schema validation

"Strict new schema" must mean more than checking only required top-level
fields.

`load_state(...)` and inference-artifact validation must use explicit
allowlists for every persisted structural level, including:

```text
top-level run state
validation/evaluation state
bit row
context row if retained
detector/backend row if retained
inference recipe
SUB50 certificate
vote_rule
vote/result diagnostics
transaction metadata if persisted
clean-pass evidence rows
```

Unknown keys must fail closed.

Do NOT keep arbitrary extra fields merely because they are ignored by the
current implementation.

The existing state contains many neutral-looking predecessor fields that are
not all Tesla-named, for example:

```text
required_success
successful_trials
failed_trials
inconclusive_trials
target_attempts
first_success_snapshot
winner_context
winning_detector
attempt_log
candidate_restart_history
evaluation_candidate_passed
failed_evaluation_candidates
failed_full_targets
full_passes_total
calibration_trials_per_bit
successes_per_bit
max_bit_attempts
```

If any of these concepts is retained, it must be explicitly renamed/allowlisted
with one defined new-schema meaning.

It may not survive automatically from predecessor state.

For nested singleton compatibility structures such as:

```text
default_detector(...)
default_context(...)
```

either:

1. rebuild them from a small explicit new-schema allowlist; or
2. remove/collapse the redundant nesting.

Do not copy the old dict and delete selected keys.

A stale predecessor field anywhere in nested state must result in:

```text
SCHEMA_MISMATCH / RESET_REQUIRED
```

rather than silent acceptance.

This recursive schema check is separate from private/evaluation-only scrubbing:

```text
private scrubber -> removes/rejects forbidden information
schema validator -> rejects unknown/obsolete structure
```

Both checks are required.

The current source still persists old confidence-gate semantics even if the
runtime loop is rewritten.

Delete these active fields from the new schema:

```text
vote_min_valid_rows
vote_min_majority_share
adaptive_vote_min_valid_rows
adaptive_vote_min_majority_share
adaptive_vote_rule
adaptive_vote_stop_reached
wilson_majority_lower_must_exceed
fixed_vote_valid_rows_hard_cap
hard_valid_rows_cap
adaptive_vote_stop
```

Also delete/rename stale physical-FLIPPED result names:

```text
last_flipped_vote_ones
last_flipped_vote_direction
last_flipped_majority_share
last_flipped_majority_ci
fixed_flipped_only
fixed_flipped_recipe_ready
fixed_flipped_capture_source
fixed_vote_orientation = "FLIPPED_ONLY"
```

Use one canonical v4 vote schema instead, for example:

```json
{
  "vote_rule": {
    "decision_rule": "FIXED_BUDGET_MAJORITY",
    "fixed_tried_rows": 200000,
    "generated_rows_cap": 800000,
    "candidate_chunk_rows": 8192,
    "tie_rule": "BIT_0",
    "final_vote_source": "SUB50_LOW",
    "wilson_role": "DIAGNOSTIC_ONLY",
    "majority_share_role": "DIAGNOSTIC_ONLY",
    "confidence_gate_enabled": false
  }
}
```

Per-attempt/result diagnostics may use neutral names such as:

```text
final_vote_ones
final_vote_zeros
final_vote_kept
final_vote_direction
final_vote_majority_share
final_vote_majority_ci
vote_stop_reason
```

`vote_stop_reason` may record structural termination such as:

```text
FIXED_BUDGET_MAJORITY
GENERATED_CAP
```

but it must not imply acceptance/rejection by itself.

Final status is derived only as:

```text
kept > 0  -> OK majority bit
kept == 0 -> INCONCLUSIVE_NO_KEPT_ROWS
```

If `vote_guard_triggered` / `vote_guard_outcome` remain, restrict them to true
structural failures only. Prefer replacing them with:

```text
vote_structural_failure
vote_structural_failure_reason
```

They must never represent:

```text
weak majority
Wilson <= 50%
majority < 52%
generated cap with kept > 0
exact tie with kept > 0
```

Old persisted files containing any removed adaptive-vote field must fail strict
schema validation and require `--reset`.

Do not silently migrate those old values into the new recipe.

## 13.2 Fixed constants in state/recipe

At initialization store only global immutable configuration:

```json
{
  "training_observations": 10,
  "sub50_witness_count": 101
}
```

If CLI uses different laboratory constants, a pre-existing state with different constants must fail and require `--reset`.

No in-run mutation.

## 13.3 Default bit state

Remove:

```text
tesla
direct_core_recipe
depth/maturity fields
replay retry counters
recertification counters
legacy below-50/MAX ratchet fields
last_max_by_backend
last_success_max
max_increases
max_ratchet_trials
last_success_a_private
```

Keep:

```text
position
status
attempt counters
working curriculum
deterministic seed/config
inference recipe data
certification generation if still useful
development diagnostics
```

## 13.4 Inference recipe APIs

Rename:

```text
build_replay_recipe
save_replay_recipe
validate_private_free_replay_artifact
```

to:

```text
build_inference_recipe
save_inference_recipe
validate_private_free_inference_artifact
```

## 13.5 AI recipe mode

Use one behavioral mode:

```text
AI_SUB50_FIXED_FLIP
```

Keep:

```text
FIXED_LEGAL
```

for bits that are structurally fixed.

Remove:

```text
DIRECT_CORE_MODE
AI_DIRECT_BOUNDARY_ENSEMBLE
Tesla recipe modes
```

## 13.6 Artifact validation

For every AI bit require:

```text
mode == AI_SUB50_FIXED_FLIP
backend valid
exact helper identity/version valid
deterministic model seed present
fixed trainer observations == immutable run config (default 10)
fixed witness count == global config (default 101)
witness count odd
SUB50 version valid
prefix-conditioned training true
dynamic runtime SUB50 polarity true
physical ANTI = exact complement rule
neutral zero rule deterministic
vote raw source mode == DYNAMIC_SUB50_HIGH
vote transform == EXACT_COMPLEMENT_TO_SUB50_LOW
final vote mode == DYNAMIC_SUB50_LOW
fixed-budget vote rule/caps/chunking/tie rule complete
candidate/training geometry complete
runtime fingerprint complete
no A_private/private material
no Tesla keys
no direct-core keys
no adaptive depth keys
no replay-recertification keys
```

## 13.7 Remove predecessor migrations

Fresh schema only.

Delete:

```text
EVALUATION_ONLY_PREDECESSOR_SOURCE_HASHES
KNOWN_STRUCTURAL_PREDECESSOR_SOURCE_HASHES
_matches_evaluation_only_predecessor_fingerprint
_matches_known_structural_predecessor_fingerprint
_matches_exact_single_file_i10_fingerprint
```

Old state requires `--reset`.

## 13.8 Runtime inconclusive handling

Remove replay-specific reopen/recalibration functions.

Preserve the good anti-loop rule:

```text
one deterministic inference on one target
if inconclusive, do not immediately rerun unchanged input/recipe
```

Rename logic generically.

---

# 13.9 Remove obsolete adaptive/evaluation-intermediate state fields

In addition to Tesla/depth/replay fields already listed, remove state whose only
purpose was runtime adaptation or per-bit supervised establishment scoring:

```text
adjustments_total
target_had_adjustment
last_adjustment
evaluation_batches_aborted_runtime_recalibration
runtime_replay_recert_counts
establishment_no_progress_targets
establishment_progress_signature_start
last_establishment_progress_signature
last_establishment_target_made_progress
establishment_targets_completed
establishment_targets_passed
establishment_targets_failed
establishment_full_replay_verified
establishment_full_replay_verified_target_serial
eval_only_bit_mismatches_current_target
full_replay_log
runtime_recalibrations
establishment_replay_mismatches
calibration_runtime_inconclusives   # if it only drove old target/replay cycling
```

Replace only what is actually needed by the explicit new phase machine.

A compact validation state is preferable:

```json
{
  "phase": "CALIBRATION",
  "candidate_generation": 1,
  "development_full_inference_verified": false,
  "development_full_inference_verified_target_serial": null,
  "evaluation_target_limit": 30,
  "evaluation_targets_completed": 0,
  "evaluation_targets_passed": 0,
  "evaluation_targets_failed": 0,
  "clean_full_pass_target": 5,
  "clean_full_passes": 0,
  "target_serial": 0,
  "current_target": null,
  "cursor_position": 0,
  "recovered_prefix_bits": "",
  "used_main_private_sha256s": [],
  "clean_full_pass_private_sha256s": [],
  "clean_full_pass_pairs": []
}
```

Additional monotonic audit counters are fine if they do not steer the algorithm.

---

# 13A. CLEAN LEGACY STATE/ARTIFACT SUPPORT FUNCTIONS

Several active functions are easy to overlook because they are not named Tesla
but still encode the old architecture.

## 13A.1 `normalize_fixed_success_state(...)`

The new schema explicitly requires `--reset`.

Therefore do not use this function as a broad legacy migration layer.

Prefer to delete it.

If a tiny normalization helper remains for current-schema defaults, it must not
migrate:

```text
legacy replay fields
global/synchronized depth
Tesla state
MAX state
old direct-core recipes
old establishment replay state
old private-material aliases
```

Old schema/version must fail before normalization.

## 13A.2 `progress_summary(...)`

Rewrite it to report only current architecture fields, e.g.:

```text
phase
candidate_generation
current_bit
completed AI recipe count
total required AI recipe count
development_full_inference_verified
evaluation_targets_completed/passed/failed
clean_full_passes
fixed training observations
fixed SUB50 witness count
```

No:

```text
global N
synchronized depth adjustments
Tesla readiness
replay recertification
MAX ratchets
```

### Process-local semantic-hash cache

Rename:

```text
_LAST_REPLAY_SEMANTIC_HASH
    -> _LAST_INFERENCE_SEMANTIC_HASH
```

Clear/reset this cache whenever active inference artifact state is reset or its
file is deliberately removed.

### Nested `no_private(...)` artifact validator

Merge/replace this legacy replay-local recursion with the generic new-schema
private-clean / operational-persistence validators.

Do not maintain a second validator with a narrower old key list.

### `validate_private_free_replay_artifact(...)` -> `validate_private_free_inference_artifact(...)`

Rewrite the old vote-configuration validation completely.

DELETE checks/reads for:

```text
normal_acc_threshold
adaptive_vote_min_valid_rows
adaptive_vote_min_majority_share
fixed_vote_valid_rows_hard_cap
fixed_vote_orientation == FLIPPED_ONLY
```

Require instead:

```text
vote_decision_rule == FIXED_BUDGET_MAJORITY
fixed_vote_tried_rows > 0
fixed_vote_generated_rows_cap >= fixed_vote_tried_rows
vote_candidate_chunk_rows > 0
vote_tie_rule == BIT_0
final_vote_mode == DYNAMIC_SUB50_LOW
wilson_role == DIAGNOSTIC_ONLY
majority_share_role == DIAGNOSTIC_ONLY
confidence_gate_enabled is False
```

The validator must reject any recipe that contains a removed adaptive-vote
field, even if the new fields are also present.

Do not accept a mixed old/new artifact.

## 13A.3 Artifact semantic hash/persistence functions

Rename and update:

```text
_replay_recipe_semantic_hash
save_replay_recipe
persist_and_verify_private_free_replay_artifact
```

to:

```text
_inference_recipe_semantic_hash
save_inference_recipe
persist_and_verify_private_free_inference_artifact
```

The semantic hash must ignore only truly volatile progress metadata.

It must include every correctness-affecting inference setting, including:

```text
backend/helper identity
model seed/config
fixed training observation count
fixed witness count
witness-selection rule/version
SUB50 version
fixed vote budget/caps/chunking/tie-rule/diagnostic policy
prefix-conditioned candidate geometry
narrowing/runtime fingerprints
exact-suffix configuration
```

Changing any of those must change the semantic hash.

## 13A.4 `save_audit_result(...)`

Rename persisted path/key wording from replay to inference.

Audit result may contain redacted/evaluation-only diagnostics, but the embedded
inference artifact reference must point to the new inference recipe file.

## 13A.5 `complete_bit(...)`

Preserve bit-completion bookkeeping but make completion mean:

```text
a structurally valid private-free AI_SUB50_FIXED_FLIP inference recipe exists
```

not:

```text
Tesla ready
common depth reached
supervised calibration bit happened to match
```

Clearing backend slot files at bit completion may remain if required by helper
isolation.

## 13A.6 Candidate restart

`_restart_development_candidate(...)` must reset every candidate-local bit recipe
and calibration state because development full-key failure rejects the whole
candidate.

It must preserve only immutable run configuration and monotonic audit counters.

It must clear:

```text
all AI bit DONE/recipe state
current target
recovered prefix
development validation flag
evaluation population evidence
attempt-local helper slot state
SUB50 certificates
vote traces
```

It must not change:

```text
fixed trainer observation count
fixed witness count
fixed vote budget/selection rules
exact suffix threshold
user configuration
```

---

# 14. `common.py` CHANGES

## 14.1 Version/schema

Bump clearly, e.g.:

```python
SCRIPT_VERSION = "PHASE32-PHASE33-SUB50-FIXED-v500-POC"
SCHEMA_VERSION = <next unused integer>
```

Require `--reset`.

## 14.2 File names

Use Tesla/replay-free names:

```text
data/sub50_state.json
data/sub50_audit_result.json
data/sub50_inference_recipe.json
data/sub50_clean_full_pass_pairs.txt
data/sub50_slot_...
data/sub50_txn_backup/
```

Do not delete user's old Tesla files automatically.

Stop reading/writing them.

## 14.2A Clean-pass evidence file

Update `sync_clean_pass_pairs_file(...)`.

Remove Tesla/adaptation comments such as:

```text
reset whenever Tesla recertification marks a target adjusted
```

The file now represents the current consecutive frozen exact-pass streak.

Persist only private-free evidence:

```text
pass_index
target_serial
main_key_sha256
a_narrow_sha256
completed_at
candidate_generation
```

A frozen candidate failure clears the streak file before the candidate is
retired.

A development-validation pass is not included in the frozen clean-pass streak.

## 14.3 Constants
## 14.3A Exact current constants that must be preserved, renamed, or deleted

### Delete the exact old adaptive vote constants

The current `common.py` still defines:

```text
DEFAULT_ADAPTIVE_VOTE_MIN_VALID_ROWS
DEFAULT_ADAPTIVE_VOTE_MIN_MAJORITY_SHARE
```

DELETE both.

Do not merely stop referencing them from CLI code.

Also remove any derived state/fingerprint fields whose only purpose was those
constants.


The current source has several top-level constants whose names are easy to miss
because they are not all Tesla-named. Handle them explicitly.

### Preserve as correctness-affecting execution geometry

Keep these values unless the exact helper inspection proves a different value is
required:

```text
CONTEXT_FRACTION = {"CANONICAL": 0.50}

RESTORED_TRAIN_MICROBATCH = 65_536
RESTORED_EFFECTIVE_TRAIN_BATCH = 65_536
RESTORED_GRAD_ACCUM_STEPS = 1
RESTORED_PREDICT_BATCH = 262_144
```

They currently affect:

```text
context offset/boundary geometry
helper train microbatch
gradient accumulation
effective training batch
prediction batch size
```

They therefore belong in:

```text
execution_speed_profile
correctness_fingerprint
inference artifact validation where execution geometry is persisted
```

Do not silently change them while removing Tesla.

If renamed away from `RESTORED_*`, use neutral names such as:

```text
TRAIN_MICROBATCH
EFFECTIVE_TRAIN_BATCH
GRAD_ACCUM_STEPS
PREDICT_BATCH
```

but preserve the values/semantics unless deliberately tested.

### Preserve generic private-domain bound

Keep:

```text
MAX_PRIVATE_256 = (1 << 256) - 1
```

or replace it with an equivalent tested generic constant.

It is used only to validate legal 256-bit boundary/domain geometry and is not
Tesla state.

### Validate narrowing for the selected backend only

There is no mixed-backend execution in the new design.

When `--backend` is resolved, validate that selected helper's:

```text
narrower(...)
narrow_batch(...)
```

produce the canonical narrowing representation required by target generation,
ambiguity checks, voting, and exact suffix.

If the selected helper fails that contract, fail closed.

Delete `_NARROWING_CONTRACT_VERIFIED` if it exists only to cache Phase32-vs-
Phase33 equivalence checks. No cross-backend equivalence layer is needed.

### Delete old label-free/depth-derived backend budgets

Delete:

```text
HARD_MAX_LABEL_FREE_MATURITY_OBSERVATIONS
HARD_MAX_CALIBRATION_TRAINING_CANDIDATE_EVENTS
HARD_MAX_CALIBRATION_VOTE_CANDIDATE_EVENTS
```

because all three are currently derived from:

```text
MAX_LABEL_FREE_SYNC_DEPTH = 512
```

and therefore carry the removed depth architecture.

Replace them with fixed, independently named anti-loop budgets, for example:

```python
FIXED_TRAINING_CANDIDATE_EVENT_CAP = 10_000
FIXED_VOTE_GENERATED_EVENT_CAP = <derived only from fixed vote limits, not N/depth>
MAX_CANDIDATE_GENERATIONS = 512
MAX_CONSECUTIVE_AMBIGUOUS_TARGET_SKIPS = 64
```

Exact values should preserve existing practical boundedness/performance where
possible, but no new budget may be computed from a deleted N/maturity/depth
constant.

### Delete old retry/depth ceilings

Delete:

```text
HARD_ONE_CALIBRATION_ATTEMPT_PER_BIT
HARD_MAX_RUNTIME_RECALIBRATIONS_PER_BIT_PER_SYNC_DEPTH
HARD_MAX_ESTABLISHMENT_REPLAY_MISMATCHES_PER_BIT_PER_SYNC_DEPTH
DEFAULT_MAX_BIT_ATTEMPTS
```

There is exactly one structural calibration attempt per AI bit in a candidate
generation, using the fixed selected backend.

If that attempt is structurally inconclusive, reject the whole candidate
generation. Do not retry the bit.

### Rename semantic-hash write cache

Current state module:

```text
_LAST_REPLAY_SEMANTIC_HASH
```

Rename to:

```text
_LAST_INFERENCE_SEMANTIC_HASH
```

and update:

```text
save_inference_recipe(...)
persist_and_verify_private_free_inference_artifact(...)
reset_files(...)
```

so the cache never causes a stale file to be skipped after:

```text
--reset
candidate restart
recipe file deletion
schema/version mismatch
```

The cached hash is process-local only and is not persisted.


Audit every current top-level control constant in `common.py`.

Remove/rename old architecture constants:

```text
MAX_LABEL_FREE_SYNC_DEPTH                 -> DELETE
INITIAL_REQUIRED_BELOW50_OBSERVATIONS     -> DELETE
DEFAULT_REPLAY_RETRIES                    -> DELETE
DEFAULT_REPLAY_TRAINING_EVENT_CAP         -> DEFAULT_INFERENCE_TRAINING_EVENT_CAP
DEFAULT_MAX_BIT_ATTEMPTS                  -> DELETE
```

Preserve and fingerprint correctness-affecting non-Tesla constants:

```text
DEFAULT_FIXED_VOTE_TRIED_ROWS
VOTE_GENERATED_CAP_MULTIPLIER
DEFAULT_CONTEXT_SPAN_ROWS
DEFAULT_CLEAN_FULL_PASSES
DEFAULT_SAMPLE_TRIES
DEFAULT_EXACT_SUFFIX_MAX_CANDIDATES
DEFAULT_VOTE_CANDIDATE_CHUNK_ROWS
DEFAULT_PAIR_NARROW_CACHE_ENTRIES
```

`DEFAULT_SAMPLE_TRIES` is a bounded input-generation safeguard. It may not
adapt based on correctness.

`VOTE_GENERATED_CAP_MULTIPLIER` affects runtime vote boundedness/cost and
therefore belongs in the correctness/runtime fingerprint if it remains a
constant rather than an explicit persisted recipe value.

Delete adaptive-confidence constants whose only purpose was the old
minimum-majority / Wilson acceptance gate.


Add the new fixed SUB50/training constants:

```python
FIXED_TRAINING_OBSERVATIONS = 10
SUB50_WITNESS_COUNT = 101
FIXED_TRAINING_EVENT_CAP = ...
FIXED_WITNESS_GENERATION_EVENT_CAP = ...
```

Retain only the fixed vote-budget/candidate-chunk/generated-cap/cache constants
that remain meaningful under v4.

Delete adaptive-confidence/min-valid/min-majority/scaled-confidence constants
and their CLI/state aliases.

## 14.4 Fingerprints

Active modular source fingerprint should include:

```text
common.py
sub50.py
run_logging.py
backend.py
state.py
inference.py
evaluation.py if created
coordinator.py
main.py
```

plus genuinely active helpers/modules.

Remove:

```text
tesla*.py
direct_core.py
replay.py
reference_i10_single.py
```

from active source fingerprint.

Keep exact helper identity/fingerprint and runtime correctness fingerprint.

---

# 15. LOGGING

Rename:

```text
tesla_logging.py
```

to:

```text
run_logging.py
```

The current logger is not just a filename wrapper. It contains a large
Tesla/replay/depth-specific summary schema and its own independent privacy
scrubber. Rewrite it explicitly.

## 15.0 Update every logger import and source fingerprint reference

Current active imports include:

```text
backend.py      -> from tesla_logging import extract_tesla_stats, log_event
state.py        -> from tesla_logging import log_event
replay.py       -> from tesla_logging import extract_tesla_stats, log_event
coordinator.py  -> from tesla_logging import environment_snapshot, finalize_run,
                   log_event, log_paths, set_run_context
```

After refactor:

```text
replay.py is deleted
extract_tesla_stats is deleted
backend.py imports only the generic logging functions it still uses from run_logging
state.py imports generic logging from run_logging
coordinator.py imports environment_snapshot/finalize_run/log_event/log_paths/
set_run_context from run_logging
```

No active Python file may import `tesla_logging`.

Update every modular/source fingerprint list and packaging list to reference:

```text
run_logging.py
```

not `tesla_logging.py`.

The old logger file must not remain beside the new file, because Python import
resolution could otherwise mask an incomplete migration.

## 15.1 Preserve only generic logging primitives

Preserve/rename as appropriate:

```text
LOG_DIR
_RUN_STARTED_MONO
_RUN_STARTED_UTC
_RUN_ID
_EVENT_FILE
_SUMMARY_FILE
_LOCK
_SEQ
_CONTEXT
_safe_scalar(...)
_scrub(...)
set_run_context(...)
log_paths(...)
_write_summary_locked(...)
log_event(...)
finalize_run(...)
environment_snapshot(...)
```

The logger remains passive:

```text
logging output may never feed back into calibration,
backend choice,
SUB50 certification,
vote result,
inference,
candidate acceptance,
or evaluation decisions
```

Rename log files from Tesla naming, e.g.:

```text
tesla_run_<id>.jsonl
    -> sub50_run_<id>.jsonl

tesla_run_<id>_summary.json
    -> sub50_run_<id>_summary.json
```

## 15.2 Delete `extract_tesla_stats(...)`

DELETE it.

Do not replace it with a generic function that continues collecting keys by
prefix such as:

```text
tesla_*
coordinator_* legacy depth fields
replay_*
```

If backend diagnostics need extraction, use an explicit new-schema allowlist
containing only current non-private diagnostics.

## 15.3 Rebuild `_SUMMARY` from a new-schema allowlist

Do not mutate the existing Tesla summary dict by deleting a few fields.

Create a fresh compact `_SUMMARY` containing only current architecture metrics,
for example:

```text
run_id
started_at_utc
status
events
training_observations
sub50_certificates
sub50_normal_low
sub50_anti_low
vote_results
vote_fixed_budget_stops
vote_generated_cap_stops
vote_no_kept_inconclusives
calibration_attempts
calibration_recipes_completed
calibration_structural_failures
candidate_generation
development_full_key_passes
development_full_key_failures
evaluation_targets_completed
evaluation_targets_passed
evaluation_targets_failed
consecutive_pass_goal
consecutive_passes
candidate_evaluation_failed
full_targets_completed
cuda_memory_events
cuda_max_allocated_bytes
cuda_max_reserved_bytes
cuda_min_free_bytes
cuda_cleanup_reclaimed_reserved_bytes
```

Delete old logger summary fields including the families:

```text
tesla_*
replay_*
recertification*
depth_*
global_depth_*
label_free_depth_*
maturity_*
establishment_*
runtime_replay_*
runtime_recalibration_*
calibration_batch_max_ratchet_*
max_required_depth
bit_reopens
recalibrated_bits
evaluation_batches_aborted_runtime_recalibration
rejected_synchronized_depth
development_target_restarts_after_depth_promotion
```

Do not preserve obsolete fields merely for backwards-compatible log parsing.
New run logs use the new schema/version.

## 15.4 Rewrite `_update_summary(...)` around new event names

The current function contains a large `if/elif` dispatcher for Tesla, replay,
maturity, depth promotion, establishment, recertification, and runtime
recalibration events.

Rewrite it from scratch using only new events.

Recommended events:

```text
training_observation
sub50_witness_pool_ready
sub50_final_model_certificate
sub50_vote_start
sub50_vote_result
calibration_attempt_start
calibration_recipe_result
candidate_restart
inference_start
inference_training_complete
inference_sub50_certificate
inference_vote_result
inference_inconclusive
development_full_key_result
frozen_target_result
evaluation_candidate_result
cuda_memory
runtime_error
```

### 15.4B Exact migration of currently emitted source event literals

Rewriting only `run_logging._update_summary(...)` is insufficient.

The emitters in `backend.py`, `state.py`, old `replay.py`, and
`coordinator.py` must also be rewritten so obsolete event literals cannot
survive as inert JSONL noise or later become active again.

Handle the current source events explicitly.

#### `backend.py`

```text
tesla_training_observation
    -> training_observation

tesla_training_input_refused
    -> training_candidate_refused
       only if the refusal is still structurally meaningful;
       otherwise delete the event

tesla_maturity_observation
    -> DELETE

tesla_release_streak_update
    -> DELETE
```

`training_candidate_refused` is diagnostic only and must not advance the fixed
10-observation training clock.

#### `state.py`

```text
label_free_runtime_recipe_budget_exhausted
    -> DELETE

label_free_runtime_recipe_invalidated
    -> DELETE

supervised_establishment_replay_mismatch_budget_exhausted
    -> DELETE

supervised_establishment_replay_recipe_rejected
    -> DELETE
```

Runtime recipe repair/recalibration and establishment replay no longer exist.

Whole-candidate rejection is logged only from the explicit development or
evaluation boundary.

#### old `replay.py` -> new `inference.py`

```text
candidate_evaluation_complete
    -> evaluation_candidate_result

candidate_restart_requested
    -> candidate_restart

cuda_replay_memory
    -> cuda_memory

establishment_progress_check
    -> DELETE

establishment_target_failure
    -> development_full_key_result
       with failure status

establishment_target_result
    -> development_full_key_result

full_target_evaluation_failure
    -> frozen_target_result
       with failure/candidate-rejected status

full_target_result
    -> phase-aware:
       DEVELOPMENT_VALIDATION -> development_full_key_result
       EVALUATION             -> frozen_target_result

supervised_establishment_global_depth_promotion
    -> DELETE

synthetic_target_abandoned_after_restart
    -> scoring_target_discarded
       only if a generic discard diagnostic is useful;
       otherwise delete

tesla_maturity_observation
    -> DELETE

tesla_training_observation
    -> training_observation
```

The new `inference.py` must never emit an active event containing:

```text
replay
establishment
maturity
depth_promotion
runtime_recalibration
```

#### `coordinator.py`

```text
calibration_start
    -> calibration_attempt_start

calibration_result
calibration_detector_result
    -> calibration_recipe_result
       or a smaller calibration_attempt_result diagnostic

calibration_batch_progress
    -> calibration_progress
       optional diagnostic only

calibration_candidate_budget_exhausted
    -> calibration_recipe_result
       status=STRUCTURAL_INCONCLUSIVE

calibration_duplicate_sample_skipped
    -> calibration_sample_skipped

calibration_exhausted_batch_recovery
    -> DELETE old recovery semantics;
       use candidate_restart only if the whole candidate actually restarts

calibration_runtime_inconclusive
    -> calibration_recipe_result
       status=STRUCTURAL_INCONCLUSIVE

candidate_development_restart
    -> candidate_restart

development_target_restart_after_depth_promotion
    -> DELETE

direct_calibration_certified
direct_calibration_global_depth_promotion
direct_calibration_trial
    -> DELETE with `direct_core.py`

eval_only_first_bit_mismatch_terminates_frozen_target
    -> DELETE
       per-bit hidden-truth scoring is forbidden

exact_suffix_evaluation_diagnostic
    -> exact_suffix_result
       diagnostic only

failed_frozen_candidate_global_depth_promotion
    -> DELETE

fixed_bit_runtime_advance
    -> inference_fixed_bit_advance
       optional diagnostic only

flow_stall_guard_tripped
    -> runtime_error
       or neutral `flow_stall`

immediate_replay_establishment_complete
    -> development_full_key_result
       only if it represented the development full-key success boundary;
       otherwise DELETE

label_free_global_depth_promotion
label_free_global_depth_promotion_from_replay
supervised_establishment_global_depth_promotion
zero_tolerance_establishment_exact_suffix_depth_promotion
zero_tolerance_establishment_runtime_failure_depth_promotion
    -> DELETE

replay_check_result
    -> DELETE

run_start
    -> run_start

runtime_error
    -> runtime_error

```

#### `run_logging.py`

```text
run_end
    -> run_end
```

`run_start` and `run_end` are generic lifecycle events and belong in the new
logger schema even though they are not algorithmic phases.

### Event naming rule

Production event names must describe only the new architecture.

Allowed architectural vocabulary includes:

```text
calibration
development
evaluation
inference
sub50
fixed_budget
exact_suffix
candidate_restart
scoring_target
runtime_error
cuda_memory
```

Forbidden architectural vocabulary in active event literals includes:

```text
tesla
maturity
release_streak
replay
establishment
global_depth
depth_promotion
runtime_recalibration
label_free_sync
direct_calibration
```

An obsolete event must not be retained merely because the new summary
dispatcher ignores it.


For v4 vote logging, record:

```text
stop_reason
attempted
generated
kept
final_vote_ones
final_vote_zeros
predicted_bit
majority_share             # diagnostic only
majority_ci_low            # diagnostic only
majority_ci_high           # diagnostic only
sub50_low_physical         # current certificate diagnostic
```

The logger must not reinterpret Wilson/share as success criteria.

In particular:

```text
GENERATED_CAP + kept > 0
```

must be summarized as a valid vote result, not an inconclusive/failure.

An exact tie must be logged as:

```text
predicted_bit = 0
direction = A < B
```

not missing/None.

## 15.4A Rewrite `log_event(...)` hot-loop throttling

Current logger avoids rewriting the summary on every hot-loop event using the
literal event name:

```text
tesla_training_observation
```

Replace that special case with the new event name:

```text
training_observation
```

or a generic explicit set of high-frequency events.

This throttling is performance-only.

It must not:

```text
drop JSONL events
change counters
change SUB50/vote behavior
change phase state
```

No Tesla event literal may remain in `log_event(...)`.

## 15.5 Logger privacy scrubber must match the new persistence boundary

The logger has its own `_SENSITIVE_KEY_FRAGMENTS` / `_scrub(...)` path, separate
from state persistence.

Update it so new aliases cannot leak raw private/supervised material into JSONL
or summary files.

At minimum reject raw values under names/aliases such as:

```text
a_private
a_private_hex
a_private_num
expected_bit
expected_private_bit
private_bit
private_relation
strict_relation
main_private
main_private_hex
development_private
calibration_private
runtime_main_private
```

and any key containing `a_private`.

Prefer sharing one generic key-classification helper with `common.py` rather
than maintaining two drifting deny lists.

Permitted target/sample identity fields must be explicitly hash-only, e.g.:

```text
main_key_sha256
a_narrow_sha256
private_sample_sha256
```

Never log the source scalar together with its hash.

For scoring targets, do not persist per-bit hidden-truth correctness in logs.
Log only the completed full-key development/evaluation result.

Calibration truth may remain in explicitly named `*_eval_only` diagnostics only
if it is already permitted by the calibration audit policy and cannot feed back
into execution.

## 15.6 Logger context must be new-schema only

`set_run_context(...)` may contain immutable/public run configuration such as:

```text
script_version
schema_version
training_observations = 10
sub50_witness_count = 101
vote_decision_rule = FIXED_BUDGET_MAJORITY
vote_fixed_tried_rows
vote_generated_rows_cap
exact_suffix_max_candidates
backend
fast/deterministic mode
```

Do not put into persistent logger context:

```text
private scalar
hidden bit
hidden relation
Tesla state
maturity
global/synchronized depth
adaptive vote minimums
normal_acc_threshold
replay/establishment state
```

## 15.7 `finalize_run(...)` must summarize the four-phase lifecycle

Final status/summary may report:

```text
CALIBRATION
DEVELOPMENT_VALIDATION
EVALUATION
EVALUATION_COMPLETE
candidate generation
development full-key result
evaluation totals
clean consecutive passes
final pass/fail
```

Delete final-summary dependencies on:

```text
synchronized depth
establishment verification
replay artifact verification naming
adjustments_total
runtime recalibration counters
```

Rename deployable artifact wording to `inference` rather than `replay`.

## 15.7B Runtime diagnostics only

Keep ordinary environment/runtime information diagnostic only.

Do not build a package/GPU compatibility matrix or make Python/NumPy/PyTorch/GPU
model versions a separate artifact-gating subsystem. The active source/helper
hashes and explicit execution mode are sufficient for this implementation.

## 15.8 `environment_snapshot(...)`

Also include, where available:

```text
effective PYTORCH_CUDA_ALLOC_CONF
resolved Phase32 helper path
resolved Phase33 helper path
Phase32 helper source SHA256
Phase33 helper source SHA256
```

These are diagnostics.

Do not dump the entire environment or expose unrelated secrets.

If `PHASE32_HELPERS_DIR` contains a user-specific path, logging the resolved
selected helper files is sufficient; do not serialize the whole environment.

Preserve environment/runtime diagnostics that are genuinely useful and
private-free, such as:

```text
Python
platform
PyTorch
CUDA availability/device
```

Do not add environment data that exposes secrets or helper search credentials.

## 15.9 Logging source cleanup

After migration, active logger source must have no Tesla/replay/depth control
vocabulary except in comments/tests that explicitly assert its absence.

Run a source check such as:

```bash
grep -Rni "tesla_\\|replay_\\|maturity\\|synchronized_depth\\|recertification\\|runtime_recalibration" run_logging.py
```

Expected: no active old-schema logger fields/events/functions.

Also scan all production emitters:

```bash
grep -RniE 'log_event\("[^"]*(tesla|maturity|release_streak|replay|establishment|global_depth|depth_promotion|runtime_recalibration|direct_calibration)' \
  backend.py state.py inference.py coordinator.py run_logging.py
```

Expected no matches.

The absence of old handlers in `run_logging.py` is not sufficient if an old
event literal is still emitted elsewhere.

---

---

# 16. HELPER INTEGRATION

Do not silently modify exact Phase32/Phase33 algorithms.

Prefer wrappers.

Before implementation, inspect exact helpers and document in code/tests:

```text
whether top-level run_once consumes ns.a_private anywhere
whether lower-level model/training/vote functions require private truth
synthetic training target value/semantics
normal logit extraction
normal prediction semantics
anti prediction semantics
representative pool semantics
A_private exclusion
```

## 16.0A Exact helper I/O contracts must be audited and normalized

The current engine depends on several exact helper return contracts, not just
function names.

Before using an exact Phase32/Phase33 helper, record and test the actual
contracts for:

```text
narrow_batch(numbers)
decode_narrow_matrix(narrows)
half_features(decoded_bytes)
select_avb_flip_indices(a_bytes, valid_bytes)
predict_normal_predictions(...)
predict_anti_predictions(...)
make_training_representatives(...)
train_normal_model(...)
wilson_ci(...)
```

At runtime fail closed on structural mismatch.

At minimum:

### `narrow_batch(...)`

```text
one output slot per input candidate
row/order correspondence preserved
None semantics documented from exact helper
non-None outputs canonicalizable
```

### `decode_narrow_matrix(...)`

```text
one decoded row per supplied valid narrow
2-D shape expected by the exact helper
no silent row drop/reorder
```

### `select_avb_flip_indices(...)`

Determine from the exact helper whether it returns:

```text
integer indices
boolean mask
other documented selector representation
```

Normalize only according to that verified contract.

If boolean mask:

```text
mask length == number of valid candidate rows
selected row count = count_true(mask)
```

If integer indices:

```text
1-D integer indices
all indices in bounds
selected row count = resulting selected candidate rows
```

Do not use `len(selector_output)` as the number of kept votes unless that is
actually the verified representation.

`attempted` and `kept` remain different counters:

```text
attempted += number of valid decoded candidate narrows before AVB selection
kept      += number of final prediction rows after AVB selection
```

A selector that chooses zero rows is valid; it does not call prediction on a
fabricated row.

### `half_features(...)`

```text
row count preserved
feature shape compatible between A_narrow and candidate rows
finite numeric output required
```

### prediction output

For the exact NORMAL/HIGH adapter:

```text
one prediction per selected feature row
1-D or canonically flattenable according to verified helper contract
binary 0/1 after the helper's documented threshold semantics
no NaN/Inf/extra rows
```

Do not silently truncate, broadcast, or reshape an incompatible prediction
result.

### Training representatives

`make_training_representatives(...)` must return the exact structure expected by
`train_normal_model(...)`.

The wrapper may capture representatives for the witness pool, but may not
reorder/relabel them or synthesize missing rows to satisfy 101.

All of these structural failures are helper/runtime incompatibilities.

They are not evidence that a candidate is bad and must not trigger a
correctness-driven backend/polarity repair.

## 16.1 Canonical normal logits

If helper exposes model forward logits, use them directly for SUB50.

If helper only exposes binary normal predictions, use those if deterministic.

Do not use helper anti function when exact-zero fallback is random.

Always derive canonical ANTI as:

```text
1 - canonical NORMAL
```

## 16.2 Witness target semantics

If expected target is synthetic class 0:

```python
synthetic_target = 0
```

Do not hard-code until exact helper confirms it.

If Phase32 and Phase33 differ, implement backend-specific adapter:

```python
witness_target_for_backend(module) -> int
```

and test both.

---

# 17. REMOVE TESLA/DIRECT/REPLAY-SPECIFIC FUNCTIONS

Delete or replace active functions including as applicable:

```text
record_tesla_calibration_retry
record_tesla_recertification_failure
tesla_record_clean_replay_success
reopen_bit_after_tesla_failure

promote_synchronized_depth_from_maturity
promote_synchronized_depth_from_establishment_replay_failures
promote_synchronized_depth_from_direct_calibration_failure
promote_synchronized_depth_after_failed_frozen_candidate

run_direct_calibration_once

_replay_detector_recipe
replay_ai_bit
```

The last two are replaced by inference functions, not merely deleted.

Remove Tesla reset behavior from:

```text
_prepare_next_fixed_calibration_trial
```

Rename if its remaining purpose is generic.

Remove/rename:

```text
_return_to_establishment_for_runtime_replay
last_replay_attempt_token
replay_generation
replay_retry
```

Also delete the supervised per-bit repair path:

```text
invalidate_bit_after_supervised_establishment_replay_mismatch(...)
```

or replace every call with whole-candidate rejection.

Fresh full-key development truth may reject a complete candidate but may not
reopen/tune one bit.

Delete any counters/state whose only purpose was that per-bit supervised repair,
including:

```text
establishment_replay_mismatches
runtime_recertification counts tied to supervised bit repair
```

---

# 17A. REWRITE THE COORDINATOR AS AN EXPLICIT PHASE MACHINE

The current `adaptive_main()` interleaves calibration, synchronized-depth
checking, establishment replay, and frozen evaluation.

After Tesla/depth/replay removal, make the control flow explicit.

Use phases equivalent to:

```text
CALIBRATION
DEVELOPMENT_VALIDATION
EVALUATION
EVALUATION_COMPLETE
```

No hidden depth-dependent transition is allowed.

## 17A.1 CALIBRATION

During `CALIBRATION`:

1. do not create or consume a MAIN/development validation target;
2. advance structurally fixed bits automatically;
3. for each unresolved pre-suffix AI bit:
   - run bounded private-independent calibration attempts;
   - train exactly 10 accepted trainer observations;
   - build fixed 101-row witness bank;
   - certify dynamic physical SUB50_LOW/HIGH;
   - run the bounded weak-signal vote with FINAL_VOTES=SUB50_LOW;
   - persist the resulting private-free bit inference recipe;
4. when every required pre-suffix AI bit has a structurally valid recipe,
   transition to `DEVELOPMENT_VALIDATION`.

Calibration samples used to build bit recipes are separate from the later
end-to-end validation target.

Do not keep a partially inferred validation target alive while bit recipes are
still being calibrated.

## 17A.2 DEVELOPMENT_VALIDATION

On entry:

```text
current_target = None
cursor_position = 0
recovered_prefix_bits = ""
```

Generate one completely fresh validation target.

Recover it end-to-end using only:

```text
FIXED_LEGAL bits
infer_ai_bit() for behavioral AI bits
exact_suffix_recover() at suffix takeover
```

If the full key matches:

```text
development_full_inference_verified = True
transition -> EVALUATION
```

If it fails:

```text
reject the entire candidate generation
reset all bit recipes/candidate-local state
candidate_generation += 1
transition -> CALIBRATION
```

Do not reopen one mismatching bit.

## 17A.3 EVALUATION

On entry, create a fresh target population and reset all evaluation counters.

Use the exact same inference path as development validation.

Default success criterion:

```text
5 consecutive exact full-key passes
zero failures
within evaluation target limit 30
```

Any scored frozen target failure rejects the candidate.

Input-ambiguous/unscorable targets are skipped according to the fixed ambiguity
skip cap and do not increment scored-target counters.

## 17A.4 EVALUATION_COMPLETE

Write final audit/result/inference artifact and terminate normally.

No transition from `EVALUATION_COMPLETE` back into calibration.

## 17A.5 Replace synchronized-completion helper

Delete:

```python
_all_ai_bits_synchronized(...)
```

Replace with something semantically accurate, e.g.:

```python
def _all_required_ai_recipes_complete(state, args) -> bool:
    """
    True iff every unresolved pre-exact-suffix AI position has a valid
    AI_SUB50_FIXED_FLIP inference recipe under the current immutable run config.
    No depth comparison.
    """
```

The completion predicate must validate:

```text
status DONE
recipe mode correct
fixed trainer observations match immutable config
fixed witness count match immutable config
recipe passes private-free structural validation
```

## 17A.6 Rewrite `_enter_frozen_evaluation_if_ready(...)`

It must no longer require:

```text
_all_ai_bits_synchronized
synchronized_required_depth
evaluation_depth_frozen
frozen_evaluation_depth
establishment_full_replay_verified
```

Instead require:

```text
phase == DEVELOPMENT_VALIDATION
no active current target
_all_required_ai_recipes_complete(...)
development_full_inference_verified == True
```

Then reset a fresh evaluation population and set:

```text
phase = EVALUATION
```

No depth is frozen because there is no adaptive depth.

## 17A.7 Rewrite calibration seed derivation

Current:

```python
_calibration_attempt_seed(
    position,
    synchronized_n,
    calibration_epoch,
    attempt_serial,
    detector_name,
    backend_name,
)
```

must lose the removed depth argument.

Use a seed material contract such as:

```text
script/schema version
candidate_generation
bit position
calibration epoch
attempt serial
detector/context name
backend name
fixed training observation count
fixed witness count
```

Example signature:

```python
_calibration_attempt_seed(
    *,
    candidate_generation: int,
    position: int,
    calibration_epoch: int,
    attempt_serial: int,
    detector_name: str,
    backend_name: str,
    training_observations: int,
    witness_count: int,
) -> int
```

No private sample value, correctness, bit truth, or prior failure label may enter
the seed.

## 17A.8 Clean calibration batch/snapshot helpers

Rewrite or delete:

```text
_calibration_batch_state
_capture_success_snapshot
_restore_success_snapshot
_prepare_next_fixed_calibration_trial
```

Remove fields such as:

```text
max_ratchet_trials
last_success_max
Tesla readiness
depth/N
below-50 counters
```

If a success snapshot remains useful, it should contain only the private-free
structural recipe candidate:

```text
winning context/detector if still meaningful
backend
training/witness/vote trace
SUB50 certificate metadata
```

A known calibration correctness diagnostic must not be part of the snapshot
selection rule.

---

# 18. HIGH-LEVEL POC VALIDATION / EVALUATION FLOW — PRESERVE IT

The outer POC lifecycle is independent of Tesla and must remain.

Do not delete it while removing replay terminology.

Required lifecycle:

```text
develop/certify all required pre-suffix AI bit inference recipes
        |
        v
ONE fresh end-to-end DEVELOPMENT FULL-KEY VALIDATION
using the same infer_ai_bit() path that runtime will use
        |
        v
if exact full key succeeds:
freeze candidate/configuration
        |
        v
start completely fresh FROZEN evaluation population
        |
        v
require clean_full_pass_target consecutive exact full-key passes
(default 5)
with ZERO failures
within evaluation_target_limit
(default 30)
```

The current defaults are:

```text
DEFAULT_CLEAN_FULL_PASSES = 5
evaluation target limit = 30
```

Preserve those defaults and CLI configurability unless there is a concrete
source-level incompatibility.

This is not calibration replay.

It is normal end-to-end validation/inference on fresh targets.

Use `infer_ai_bit()` everywhere.

## 18.1 Development full-key validation before freeze

The current source calls this an "establishment full replay."

Rename it to something like:

```text
development_full_inference_verified
development_full_inference_verified_target_serial
```

A candidate may enter frozen evaluation only after one completely fresh target
has been recovered end-to-end exactly using:

```text
fixed legal bits
infer_ai_bit() for AI bits
exact suffix enumeration
```

No A_private enters prediction.

A_private may only score the final recovered full key after inference is
complete.

A failed development full-key validation rejects the **entire** development
candidate generation.

Do not reopen/recalibrate only the mismatching bit.

The replacement candidate must start fresh per-bit model/recipe/calibration
state using:

```text
candidate_generation += 1
fresh deterministic per-attempt seeds derived from generation/position/attempt
the same fixed training-observation count
the same fixed witness count
the same fixed vote budget/selection geometry
```

The failed target may be recorded only as aggregate/evaluation evidence.

Its mismatch position, expected bit, predicted bit, or A_private must not choose
the next backend/seed/curriculum/witness rule.

It must not:

```text
promote training observations
promote witness count
switch physical polarity based on truth
repair an existing recipe with target truth
reopen only the failed bit for supervised correction
```

## 18.2 Frozen evaluation

Once the candidate enters frozen evaluation:

```text
recipe constants cannot change
training-observation target cannot change
witness count cannot change
backend/seed/curriculum cannot change
fixed vote budget/selection geometry cannot change
candidate-generation rules cannot change
SUB50 witness selection rule cannot change
```

The first frozen target failure rejects that candidate.

Do not repair it.

The successful POC condition remains the existing clean-run rule:

```text
5 consecutive fresh exact full-key passes with zero failures
```

by default, subject to `--clean-full-passes`.

The target population is bounded by `--evaluation-targets` (default 30).

If the outer POC starts a new development candidate after rejection, the new
candidate still uses exactly the same fixed 10/101 constants.

There is no N+1/N+2.

### Fixed whole-candidate generation ceiling

Removing synchronized N also removes the old finite 512-depth ceiling that
incidentally bounded repeated candidate rebuilds.

Do not leave:

```text
candidate_generation += 1
-> CALIBRATION
```

as an unbounded outer loop.

Add one explicit depth-independent safety cap:

```python
MAX_CANDIDATE_GENERATIONS = 512
```

This is **not** training depth, model capacity, maturity, or a parameter that
changes the 10/101 algorithm.

Semantics:

```text
candidate_generation starts at 1
candidate generations 1..512 may run
a request to start generation 513 terminates the POC fail-closed
status = INCONCLUSIVE_CANDIDATE_GENERATION_CAP
no deployable candidate/artifact is declared successful
```

Persist `candidate_generation` and the cap/version in run state so restart
cannot reset the anti-loop counter.

Changing this cap between resumes requires `--reset`.

The cap belongs in run/control fingerprinting but does not need to be embedded
as a prediction parameter inside an already frozen per-bit inference recipe.

Do not adapt the cap based on pass/fail history or hidden truth.

## 18.3 Evaluation independence

When a candidate is changed/restarted, reset frozen-evaluation counters and
fresh-target evidence.

Do not carry prior candidate's:

```text
clean pass streak
evaluation target hashes
pass/fail counters
current recovered prefix
current target
```

into the replacement candidate.

Preserve the source's intent that frozen confirmation targets are independent
of candidate development.


---

# 18.4 REWRITE TARGET/EVALUATION SUPPORT FUNCTIONS EXPLICITLY

When `replay.py` is split into `inference.py` plus optional `evaluation.py`,
do not leave the old establishment/replay support functions behind.

## 18.4.1 Delete obsolete establishment-progress watchdogs

Delete:

```text
HARD_MAX_ESTABLISHMENT_TARGETS_WITHOUT_PROGRESS
_establishment_progress_signature(...)
_record_establishment_progress(...)
```

There is no longer an establishment phase that cycles fresh targets while
recipes/depth change.

The explicit phase machine already provides bounded progress:

```text
CALIBRATION has bounded per-bit attempts
DEVELOPMENT_VALIDATION has one scored fresh target per candidate
EVALUATION has a fixed scored-target limit
input ambiguity has its own fixed skip cap
```

Do not recreate an establishment no-progress watchdog.

## 18.4.2 `_new_validation_target(...)`

Move/rename to generic evaluation terminology, for example:

```python
_new_scoring_target(...)
```

It may be called only in:

```text
DEVELOPMENT_VALIDATION
EVALUATION
```

Never in `CALIBRATION`.

Target role metadata should say:

```text
development_full_key_validation
or
frozen_evaluation
```

not:

```text
continuous adaptive replay/calibration target
establishment target
```

Preserve:

```text
fresh unique random legal private scalar
process-memory-only private truth
persisted SHA-256 identity
persisted A_narrow
finite duplicate-draw loop
```

## 18.4.3 `_current_validation_target(...)`

Move/rename generically.

It should:

- return the existing active scoring target when its process-memory truth still
  exists;
- discard a partial unscorable target after process restart;
- create a fresh target only in DEVELOPMENT_VALIDATION/EVALUATION;
- never create one during CALIBRATION.

## 18.4.4 `_discard_unscorable_resumed_target(...)`

Keep the behavior but rename all Tesla/depth/replay fields/messages.

A discarded partial target:

```text
is not pass
is not failure
does not increment evaluation_targets_completed
does not change clean streak
does not reject candidate
```

## 18.4.5 `_finish_full_target(...)`

Rewrite around the explicit phase.

This must be the **first scoring boundary** where hidden target truth is compared
with the fully recovered private key.

During `DEVELOPMENT_VALIDATION`:

```text
exact full-key match -> development_full_inference_verified=True
mismatch -> reject whole candidate
```

During `EVALUATION`:

```text
exact full-key match -> increment completed/passed/clean consecutive streak
mismatch -> increment completed/failed and reject candidate immediately
```

Delete per-bit truth scoring/steering.

Delete obsolete fields:

```text
target_had_adjustment
eval_only_bit_mismatches_current_target
clean_no_adjustments
last_establishment_full_pass
establishment_targets_*
establishment_full_replay_*
```

Because runtime recipe adaptation is gone, every scored successful target is
"clean" by construction.

## 18.4.6 `record_full_target_evaluation_failure(...)`

Rename if desired to:

```text
record_frozen_target_failure(...)
```

It must terminate/reject the frozen candidate after the first scored failure.

Do not draw a replacement frozen target for the same rejected candidate.

The next target may be generated only after a whole fresh candidate has been
developed and validated.

## 18.4.7 `_finish_candidate_evaluation_batch(...)`

Rename to something like:

```text
_finish_evaluation_candidate(...)
```

Semantics:

```text
if any scored frozen failure -> candidate failed
elif clean streak >= goal -> candidate passed
elif scored target limit reached without goal -> candidate failed
else -> evaluation continues
```

No N promotion.

No recipe repair.

## 18.4.8 Runtime private-memory helpers

Keep generic equivalents of:

```text
_target_narrow_hex
_target_serial
_remember_runtime_main_private
_runtime_main_private_for_target
```

because they enforce process-memory-only hidden truth.

Rename "MAIN replay" wording to target/evaluation wording.

## 18.4.9 Logs

Rename/remove state/log collections such as:

```text
full_replay_log
replay_check_result
establishment_target_result
establishment_target_failure
establishment_progress_check
```

Use:

```text
inference_bit_result          # contains no private expected bit
development_full_key_result   # final scoring boundary only
frozen_target_result          # final scoring boundary only
evaluation_candidate_result
```

Do not persist per-bit expected truth or per-bit correctness for scoring
targets.

---

# 18A. PRESERVE NON-TESLA CORE SAFETY / CORRECTNESS INFRASTRUCTURE

Tesla removal must not accidentally delete unrelated correctness machinery.

## 18A.1 Exact suffix is mandatory

Preserve the exact suffix takeover:

```text
when remaining recovered-prefix legal candidate universe
<= EXACT_SUFFIX_MAX_CANDIDATES
```

enumerate every legal candidate and require exactly one candidate whose
`narrower(candidate)` equals current `A_narrow`.

Keep fail-closed outcomes:

```text
NO_MATCH
AMBIGUOUS
INCONCLUSIVE malformed narrowing output
```

The exact suffix path must not train, vote, or use SUB50.

### Exact-suffix bounded scanning contract

Preserve the current bounded-memory enumeration behavior.

Do not materialize/narrow the full configured suffix universe in one call when
it may contain millions of candidates.

Scan legal candidates in deterministic ascending numeric order:

```text
low, low+1, ..., high
```

using bounded batches.

Use one fixed bounded batch size in the new engine:

```python
EXACT_SUFFIX_BATCH_ROWS = 50_000
```

Do not branch on an optional helper batch constant and do not provide a second
batch-size fallback path.

This constant affects memory/performance only; exact-suffix output must be
invariant to batching.

For every batch:

```text
numbers = contiguous ascending candidate range
narrows = canonical_narrowing_module.narrow_batch(numbers)
len(narrows) must equal len(numbers)
normalize every non-None output through the shared canonical normalizer
```

Bound memory:

```text
do not retain all candidate narrows
retain at most the first two matching candidate numbers
retain counters/diagnostics only
```

Outcome proof rules:

```text
second valid match found
    -> AMBIGUOUS immediately; uniqueness is already disproven

one match + any malformed non-null narrowing output anywhere in the full scan
    -> structural INCONCLUSIVE
       because uniqueness cannot be proven

zero matches + zero malformed outputs after the full scan
    -> NO_MATCH

exactly one match + zero malformed outputs after the full scan
    -> OK
```

A helper `None` output is handled according to the exact verified helper
contract; a malformed non-None output is never silently treated as a valid
non-match.

The batch size affects memory/performance only and must not affect:

```text
candidate order
match set
status
recovered private candidate
```

### Exact-suffix outcome lifecycle semantics

Do not route every non-`OK` exact-suffix result through one generic failure
branch.

Handle them exactly:

```text
OK
    -> use the unique recovered private candidate and finish the target normally

AMBIGUOUS
    -> input-only unscorable narrowing collision
    -> discard target without pass/fail
    -> increment the same consecutive ambiguous-target skip counter
    -> draw a fresh target under the same frozen candidate
    -> never retrain/repair/change backend/recipe

NO_MATCH
    -> deterministic inference self-consistency failure
    -> the recovered prefix contains no legal candidate matching supplied A_narrow
    -> DEVELOPMENT_VALIDATION: reject the whole candidate generation
    -> EVALUATION: count the target as failed/completed and reject the frozen candidate
    -> no hidden truth is needed to make this decision

INCONCLUSIVE caused by:
    empty/invalid prefix interval
    invalid internally generated target A_narrow encoding
    exact-suffix universe unexpectedly above configured threshold
    narrow_batch length mismatch
    malformed non-null narrowing output
    other helper-contract/invariant failure
    -> infrastructure/structural runtime failure
    -> fail closed; do not blame the candidate and do not silently skip/retry
```

For an external/manual inference API receiving a malformed `A_narrow`, return a
clear invalid-input/structural status rather than crashing if that is the public
API contract.

For internally generated development/evaluation targets, malformed `A_narrow`
is an invariant violation because target creation already uses the shared
canonical normalizer.

`NO_MATCH` is deliberately different from `AMBIGUOUS`:

```text
NO_MATCH proves the current predicted prefix is incompatible with A_narrow.
AMBIGUOUS proves A_narrow does not uniquely identify one suffix candidate.
```

Do not inspect A_private to distinguish those two cases.

Rename console/docs from:

```text
REPLAY exact suffix
```

to:

```text
INFERENCE exact suffix
```

or simply:

```text
EXACT SUFFIX
```

Preserve:

```text
--exact-suffix-max-candidates
EXACT_SUFFIX_MAX_CANDIDATES
EXACT_SUFFIX_START_POSITION
configure_exact_suffix_threshold(...)
```

## 18A.2 Update dynamic exact-suffix module synchronization

`common._sync_modular_exact_suffix_globals()` currently mirrors runtime values
into:

```python
("backend", "state", "replay", "coordinator")
```

After `replay.py` becomes `inference.py`, update this to the actual active
modules, e.g.:

```python
("backend", "state", "inference", "coordinator")
```

Add `evaluation` only if that module directly imports the configurable exact
suffix globals.

This is easy to miss and can cause CLI exact-suffix settings to differ between
modules.

## 18A.3 Preserve legal-domain / boundary invariants

Do not alter the non-Tesla geometry rules in `common.py` unless necessary.

Preserve:

```text
CONTEXT_ORDER = canonical context
BOUNDARY_NAMES = middle
build_middle_boundary(...)
prefix_legal_interval_bits(...)
execution_domain_for_boundary(...)
forced_boundary_domain(...)
detector_truth(...)
```

The backend execution shell must remain private-independent.

The legacy private argument passed by helper APIs must continue to be ignored
for candidate-shell sizing/selection.

Do not allow current/future private bits to enter candidate generation.

## 18A.4 Preserve FIXED bits and exact-suffix state transitions

Keep:

```text
possible_bits_global(...)
FIXED_LEGAL behavior
auto_advance_non_ai_bits(...)
EXACT_SUFFIX_ENUMERATION / exact-suffix takeover
```

The SUB50 path applies only to unresolved AI bits before exact-suffix takeover.

Do not send structurally fixed bits through training/SUB50/voting.

## 18A.5 Preserve transaction atomicity and backend slot rollback

Current calibration uses durable transaction semantics around backend helper
state files:

```text
begin_pair_transaction(...)
patch_backend_files(...)
commit_pair_transaction(...)
finalize_pair_transaction(...)
recover_pair_transaction(...)
```

and per-context/backend slot files via:

```text
slot_paths(...)
WATERMARK_FILE
RUN_STATE_FILE
RESULT_FILE
```

Preserve this behavior unless the new implementation proves the helper is fully
stateless and removes the slot files entirely.

If helper slot/state files remain:

- a process crash during an attempt must roll back PREPARED slot files;
- a COMMITTED attempt must finalize cleanly;
- a restarted process must not continue from half-written helper state;
- new SUB50/inference filenames must be used consistently.

Rename transaction comments/messages away from "replay" where applicable, but
do not remove crash consistency.

## 18A.6 No witness-only continuation

There is no post-training witness-generation phase.

All 101 witnesses must come from the eligible representative pool accumulated
during the fixed 10 accepted trainer observations. If fewer than 101 exist,
return `INCONCLUSIVE_WITNESS_BANK_NOT_REACHED` and reject the current candidate
generation during calibration.

## 18A.7 Preserve process-restart handling for private evaluation targets

The current program intentionally does not persist raw private MAIN target
values.

Preserve that privacy property.

If the process restarts while a development/evaluation target is only partially
inferred and its private truth exists only in process memory:

- do not invent or reconstruct that private truth from persisted state;
- discard the unscorable partial target safely;
- start a fresh target;
- do not count the discarded target as pass/fail evidence.

Rename old replay-specific fields while keeping the behavior.

## 18A.8 Preserve private-free persistence scrubbing
## 18A.8A Rewrite the evaluation-only operational-key classifier

Current `common.py` contains:

```python
_EVALUATION_ONLY_OPERATIONAL_KEYS
_is_evaluation_only_operational_key(...)
```

This is a critical persistence boundary and must be explicitly rewritten.

Remove old architecture-specific names such as:

```text
fixed_flipped_expected_relation
fixed_flipped_direction_correct
fixed_flipped_direction_correct_eval_only
below_50*
below_threshold*
```

from the active schema unless they are needed solely to reject stale input.

Define the new evaluation-only diagnostic key contract explicitly.

At minimum, any key representing known calibration/development/frozen truth or
correctness must be classified evaluation-only, including names such as:

```text
calibration_direction_correct_eval_only
calibration_predicted_bit_correct_eval_only
development_full_key_correct_eval_only
frozen_full_key_correct_eval_only
normal_acc_eval_only             # if retained for diagnostics at all
private_relation_eval_only
```

Also keep a generic suffix rule:

```python
normalized_key.endswith("_eval_only")
```

so newly added audit diagnostics cannot accidentally enter operational
persistence.

Do NOT classify structural SUB50 certificate fields as evaluation-only:

```text
witness_count
normal_correct_on_synthetic_witnesses
anti_correct_on_synthetic_witnesses
certified_low_physical
certified_high_physical
witness_target_semantics
private_target_used=False
```

Those are operationally reproducible from the non-private witness construction.

`_operational_persistence_copy(...)` must remove every evaluation-only field.

`_assert_operational_persistence_clean(...)` must fail closed if any
evaluation-only field survives.

A key being hashed is not enough if it still carries supervised/private truth
that the runtime algorithm could branch on.

## 18A.8B Tighten forbidden persisted private-key aliases

Review:

```python
_FORBIDDEN_PERSISTED_PRIVATE_KEYS
```

Do not limit it to the old four names.

At minimum reject direct persisted values for:

```text
a_private
a_private_hex
a_private_num
expected_bit
expected_private_bit
private_bit
private_relation
strict_relation
main_private
main_private_hex
development_private
calibration_private
```

and continue rejecting keys containing `a_private`.

If a private scalar is intentionally persisted only as a one-way uniqueness
digest, use a narrowly named hash-only field such as:

```text
main_key_sha256
private_sample_sha256
```

and never persist the source scalar alongside it.

The operational inference recipe must not contain even evaluation-only private
digests unless they are genuinely required for artifact identity. Prefer to
keep target/sample uniqueness hashes in validation/audit state, not the
deployable inference recipe.


Keep and extend the existing persistence guards:

```text
_assert_private_clean_for_persistence(...)
_assert_operational_persistence_clean(...)
_private_clean_persistence_copy(...)
_operational_persistence_copy(...)
```

The new inference recipe/state must continue rejecting persisted private keys
such as:

```text
a_private
a_private_num
a_private_hex
expected_bit
```

Also prohibit newly introduced aliases that would leak private target truth.

Development/evaluation correctness values may live in state only where the
existing privacy policy permits aggregate/evaluation metadata, never in the
private-free inference recipe.

## 18A.9 Preserve source/runtime correctness fingerprints

Do not reduce artifact validation to only a SUB50 version check.

Keep fingerprints/contracts for:

```text
exact Phase32 helper
exact Phase33 helper
narrowing implementation
execution geometry
CUDA/CPU correctness-affecting settings
vote chunking/caps
pair narrow cache semantics
exact suffix configuration
active modular source hash
```

Update names/files but retain the fail-closed mismatch behavior.

## 18A.10 Preserve split-anchor narrowed-equality ambiguity handling

Current `replay_ai_bit()` contains an important fail-closed check:

```text
narrower(middle split anchor) == supplied A_narrow
```

does NOT prove:

```text
hidden private scalar == middle split anchor
```

because narrowing is many-to-one.

Preserve this in `infer_ai_bit()` before behavioral training/voting.

Return a dedicated status such as:

```text
INPUT_AMBIGUOUS_NARROW_EQUALITY
```

with no predicted bit.

This condition is detectable from:

```text
current recovered prefix
middle split anchor
supplied A_narrow
narrowing function
```

and does not require private truth.

Treat it as an **unscorable input**, not as evidence that the inference recipe is
wrong.

Required outer behavior:

```text
discard this target
do not increment evaluation_targets_completed
do not count pass
do not count failure
do not alter the clean-pass streak
do not mutate/retrain recipe
do not switch backend
do not alter training/witness constants
start a fresh target
```

This resolves the current source inconsistency where the low-level comment says
the target should advance without recipe invalidation while the generic
non-OK coordinator branch can currently treat every non-OK as a failure.

Use this exact fixed input-only safeguard:

```python
MAX_CONSECUTIVE_AMBIGUOUS_TARGET_SKIPS = 64
```

Maintain a candidate-local counter such as:

```text
consecutive_ambiguous_target_skips
```

It increments for input-only unscorable target conditions, including:

```text
INPUT_AMBIGUOUS_NARROW_EQUALITY
exact-suffix AMBIGUOUS from multiple legal candidates mapping to the same A_narrow
```

It resets to zero after a target reaches a normal deterministic inference
outcome (pass or genuine inference failure), and whenever a whole fresh
candidate generation begins.

After 64 consecutive unscorable target skips, terminate fail-closed as:

```text
INCONCLUSIVE_TOO_MANY_AMBIGUOUS_TARGETS
```

Do not count skipped targets as development/evaluation pass/fail evidence.

Do not repair/retrain/switch backend because of an ambiguous target.

Persist the counter so a process restart cannot evade the cap.

This cap is input-only and must not depend on hidden truth/correctness.

## 18A.11 Preserve calibration-sample freshness without target-bit selection

Current `run_once()` draws a fresh legal calibration scalar before deriving its
current bit and skips rare duplicate samples by SHA-256 identity.

Preserve the important semantics:

```text
sample complete legal scalar first
verify public/input geometry
do not inspect current bit while deciding whether to keep sample
derive current bit/relation only afterward for evaluation-only logging
skip previously used calibration sample identities without consulting correctness
finite fresh-draw ceiling
```

A duplicate sample skip must not count as a calibration failure or trainer
observation.

If the private scalar hash is persisted as an opaque freshness identifier, keep
the existing private-persistence policy and never persist the scalar itself.

## 18A.12 Preserve CUDA inference-boundary cleanup and cache lifetime

Current runtime reconstruction contains explicit coarse CUDA cleanup because
repeated target inference previously exhausted GPU memory.

When `replay.py` becomes `inference.py`, rename/preserve equivalents of:

```text
_cuda_replay_memory_snapshot
_cuda_replay_boundary_cleanup
```

to:

```text
_cuda_inference_memory_snapshot
_cuda_inference_boundary_cleanup
```

or equivalent generic names.

Preserve:

```text
pair-local narrowing cache statistics
drop cache references before coarse GPU cleanup
gc.collect()
torch.cuda.empty_cache() at coarse inference boundaries only
no allocator cleanup inside hot training/vote loops
```

The cleanup must not alter model outputs.

Add a bounded multi-bit/multi-target smoke test that exercises repeated
inference calls and proves cache objects do not survive across bit boundaries.

## 18A.12B Replace the neutral `direct_core.narrow_private_hex(...)` dependency

`coordinator.py` currently obtains:

```text
narrow_private_hex(...)
```

only because it imports `direct_core.py` with `*`.

That helper is **not** direct-core prediction logic. It is a small generic
narrowing-normalization adapter still needed when creating calibration/scoring
`A_narrow`.

Because `direct_core.py` is deleted, relocate this behavior explicitly to
`common.py`, for example:

```python
def canonical_narrow_hex(narrower, source_hex: str) -> str:
    source = str(source_hex).strip().lower()
    if source.startswith("0x"):
        source = source[2:]
    if len(source) != 64:
        raise ValueError("source value must be exactly 256 bits / 64 hex chars")
    bytes.fromhex(source)  # validate
    normalized = normalize_narrow_value(narrower(source))
    if normalized is None:
        raise RuntimeError("narrower() returned an unsupported/malformed value")
    return normalized
```

The exact name is flexible, but there must be one shared implementation.

Use it for:

```text
calibration sample A_narrow creation
new DEVELOPMENT_VALIDATION target A_narrow creation
new EVALUATION target A_narrow creation
any other conversion of a 256-bit source value through helper.narrower(...)
```

Do not re-import `direct_core.py` merely to keep this helper.

Do not duplicate normalization logic in coordinator/evaluation/inference.

The shared helper must call the same canonical narrowing-output normalizer used
by split-anchor ambiguity checks and exact suffix enumeration.

## 18A.13 Preserve canonical narrowing-output normalization

Current runtime/exact-suffix code has `_normalize_narrow_value(...)` because
exact helper variants may return narrowing values as:

```text
48-character hex string
ASCII bytes containing 48 hex characters
raw 24-byte value
1-D uint8/numeric array representing 24 raw bytes or 48 ASCII hex bytes
```

Preserve this compatibility helper, moving it to `common.py` if convenient so
target generation and exact-suffix inference share one implementation.

Required contract:

```text
valid value -> canonical lowercase 48-character hex string
None/malformed/wrong-shape/wrong-length/non-hex -> None
```

Do not compare `str(container)` representations.

Use this normalization for:

```text
new scoring target A_narrow creation
current supplied A_narrow validation
exact-suffix candidate narrowing
split-anchor ambiguity comparison
selected-backend narrowing-contract validation
```

Add tests for every supported representation plus malformed inputs.

## 18A.14 Preserve bounded CPU narrowing prefetch correctly

Current backend has `_SequentialNarrowPrefetch`.

This is a performance optimization, not Tesla logic.

Preserve it if the exact helper/runtime still benefits from CPU narrowing
prefetch.

Important invariants:

```text
only contiguous non-wrapping ranges are eligible
prefix-conditioned wrapped/non-contiguous batches bypass the prefetch
at most one future job
prefetch result must equal direct narrowing exactly
close() waits/cancels so no background worker survives an attempt
```

The shared backend primitive must call `close()` in a `finally` path even if:

```text
candidate generation raises
training raises
SUB50 scoring raises
vote raises
```

Do not let worker threads accumulate over long runs.

If the implementation removes prefetch entirely, that is acceptable only if
correctness is unchanged and performance regression is consciously accepted.

## 18A.15 Preserve bounded pair-vote narrowing overlap cache

Current backend has `_PairVoteNarrowOverlapCache`.

Keep its useful semantics:

```text
CPU-only reuse
exact overlapping rows only
non-contiguous ranges bypass reuse
bounded entries per cache key
missing left/right edges are narrowed normally
cached values are never approximated
```

Create a fresh cache at the appropriate bit/target inference scope.

Do not reuse cache entries across incompatible:

```text
prefix/boundary
backend/narrowing implementation
candidate key/domain
candidate generation
```

Drop cache references at the inference/bit boundary before coarse CUDA cleanup.

Persist/cache only statistics, never the cached narrowing rows themselves.

## 18A.16 Preserve backend slot cleanup explicitly

Current state module has:

```python
clear_current_bit_backend_slots()
```

If helper slot files remain, preserve/rename this helper and call it at the same
logical isolation boundaries:

```text
full reset
completion/retirement of a bit recipe
whole-candidate restart when old helper state must not contaminate the new candidate
transaction rollback/recovery as applicable
```

It must delete only the active SUB50/helper slot namespace, not unrelated files.

If helper persistence is fully eliminated, delete the function and prove no
active helper slot path remains.

## 18A.17 Remove `--skip-initial-calibration`

Remove the CLI option and `_prepare_skip_initial_calibration(...)` completely.

Normal resume already loads a valid current-schema state. A separate bypass path
is unnecessary and would duplicate lifecycle validation.

Do not keep a second path that jumps directly into evaluation.

# 18B. REPLAY-v4 RESULT THAT MUST BE PRESERVED IN THE IMPLEMENTATION

The static-A_narrow replay test was refined until it matched the intended
post-Tesla reconstruction semantics:

```text
fresh target:
    random A_narrow
    random prefix/boundary context

within one target:
    A_narrow static
    prefix/boundary static
    frozen inference recipe static
    model/candidate/witness/vote seeds static
```

Repeated reconstruction of the same target must therefore reproduce the same:

```text
model state
101-row witness certificate
SUB50_LOW
vote stream
ones/zeros
predicted bit
replay digest
```

The earlier ambiguity was caused by incorrectly regenerating training data on
every reconstruction.

That is forbidden.

The subsequent stable inconclusives were caused by an extra confidence gate:

```text
majority >= 52%
and
Wilson lower > 50%
```

That gate is also forbidden.

The validated v4 behavior is:

```text
fixed deterministic vote budget
FINAL_VOTES = SUB50_LOW
at least one kept row -> OK
bit = 1 if ones > zeros else 0
Wilson/majority share diagnostic only
```

Previously inconclusive seeds:

```text
3, 6, 42, 55, 86, 88, 125, 127
```

must resolve deterministically under this rule without:

```text
changing the model
changing 10 trainer observations
changing 101 witnesses
changing SUB50 polarity
changing the recipe
retraining
reseeding
retrying
```

This replay-shaped test is still a surrogate until the exact external Phase32
and Phase33 helper files are available.

When those exact helpers are supplied, rerun the same static-A_narrow/frozen-
recipe regression against the real helper functions before claiming final
production equivalence.

---

# 19. REQUIRED TESTS — CORE ONLY

Do not spend time preserving or polishing the old test suite. Add/update only
tests directly required by this refactor.

## 19.1 SUB50 theorem and polarity

Verify on odd `W=101` that NORMAL and exact ANTI are complements and exactly one
physical side is below 50%.

Cover both cases:

```text
SUB50_LOW = NORMAL
SUB50_LOW = ANTI
```

## 19.2 Fixed training clock

Verify training stops after exactly 10 successful `train_normal_model(...)`
invocations that mutate behavioral training state, regardless of internal
optimizer-step count.

No per-bit retry or alternate backend is allowed.

## 19.3 Witness-bank construction

Verify the 101 witnesses:

```text
come only from representatives accumulated during those 10 observations
are selected deterministically without A_private/MAIN truth/correctness
are all rescored by the final frozen model
```

If fewer than 101 eligible rows exist, require
`INCONCLUSIVE_WITNESS_BANK_NOT_REACHED`; do not enter a witness-only phase.

## 19.4 V4 fixed-budget vote

Verify:

```text
FINAL_VOTES == SUB50_LOW
fixed vote budget is consumed
bit = 1 iff ones > zeros
exact tie -> bit 0
Wilson/share are diagnostic only
```

Re-run the previously inconclusive seeds:

```text
3, 6, 42, 55, 86, 88, 125, 127
```

They must resolve deterministically with no ambiguity.

## 19.5 Exact replay/reconstruction determinism

For the same:

```text
frozen recipe
backend
prefix/boundary
static A_narrow
```

require identical:

```text
training trace/model state
101 witnesses
SUB50_LOW
vote counts
predicted bit
```

Different prefixes must reconstruct their own target-specific models.

## 19.6 Private-data isolation

Verify A_private/MAIN truth is absent from:

```text
model build/training inputs
witness selection
SUB50 certification
vote control
persisted inference recipe/state
```

Hidden truth is used only for completed full-key development/evaluation scoring.

## 19.7 Single-backend/no-fallback behavior

Select one backend with `--backend`.

Force a structural calibration failure and verify:

```text
other backend is never tried
bit is not retried
budget/10/101 are not changed
current whole candidate generation is rejected
```

## 19.8 Phase lifecycle

Verify exactly:

```text
CALIBRATION
-> DEVELOPMENT_VALIDATION
-> EVALUATION
-> EVALUATION_COMPLETE
```

Development full-key failure rejects the whole candidate. First frozen
evaluation failure rejects the candidate. No individual bit repair occurs.

## 19.9 Fixed/legal bits and exact suffix

Verify fixed/legal bits bypass SUB50 and exact suffix takes over at the configured
threshold.

Exact suffix must produce distinct:

```text
OK
NO_MATCH
AMBIGUOUS
structural INCONCLUSIVE
```

and use fixed `EXACT_SUFFIX_BATCH_ROWS = 50_000` with bounded memory.

## 19.10 Split-anchor ambiguity

Verify narrowed equality with the split anchor returns an unscorable input
without training/voting/candidate mutation and without counting pass/fail.

## 19.11 Restart/privacy/transaction

If helper slot files remain, simulate a crash and verify transaction rollback.
A partially evaluated private target must be discarded after process restart;
private target material must not be persisted.

## 19.12 Fresh state/artifact schema

Verify old Tesla/direct/replay/depth state requires reset and the new inference
recipe is private-free and contains fixed:

```text
backend
10 training observations
101 witnesses
SUB50 rule
fixed-budget vote rule
exact-suffix configuration
```

## 19.13 Source cleanup

Require no active production imports/branches for:

```text
tesla.py
tesla_algorithm.py
tesla_integration.py
direct_core.py
replay.py
global/synchronized N
maturity/depth promotion
adaptive vote confidence
backend fallback/alternation
witness-only continuation
```

## 19.14 Build and smoke

Run:

```bash
python -m py_compile *.py
pytest -q
```

Then run one short end-to-end smoke covering calibration, one development full
key, and frozen evaluation entry.

Do not add unrelated test cleanup or broad test-suite polishing.

# 20. SOURCE-FUNCTION EDIT MAP

Use this as a checklist against the current source.

## `backend.py`

### `_update_label_free_release_streak(...)`

Delete it.

There is no release streak under fixed SUB50 certification.

### `_install_tesla_prediction_shift_bridge(...)`

Delete it.

Do not replace it with another prediction-shift hack.

SUB50 polarity normalization happens explicitly after final-model certification.

### `apply_backend_execution_speed(...)`

Remove Tesla trainer/prediction patches.

Keep genuine speed config.

### Legacy MAX helpers/fields

Delete `current_backend_max(...)` and all wrapper/coordinator MAX-ratchet state
listed in section 10.3A.

Do not use MAX growth to switch backends.

### `backend_args(...)`

Prefer deleting this legacy namespace builder in favor of the explicit
private-free shared primitive.

If retained as a compatibility adapter:

- remove real `a_private_hex` from its signature;
- never set `ns.a_private` to the real calibration private value;
- remove synchronized-depth/maturity/MAX fields;
- pass fixed trainer-observation target and witness count explicitly through
  the wrapper/context;
- keep `required_low_normal_acc_count` only as a non-operational compatibility
  sentinel if the exact helper physically requires it.

### `_prepare_fixed_flipped_working_row(...)`

Refactor so the canonical legacy raw source is dynamic `SUB50_HIGH` and the one exact flip produces `SUB50_LOW`.

### `_enforce_fixed_flipped_result(...)`

Require SUB50 certificate + completed fixed-budget majority vote whose final
vote stream is `SUB50_LOW`.

Do not gate acceptance on Wilson or a minimum majority share.

Do not choose physical polarity from A_private.

### Backend bounded-control/result helpers

Rewrite/delete:

```text
CalibrationObservationBudgetReached      -> DELETE / fixed trainer target logic
CalibrationCandidateEventBudgetReached   -> generic fixed training-event cap
FixedVoteBudgetReached                   -> canonical vote-budget result
_guard_working_update                    -> remove MAX/private fields
_fixed_budget_result                     -> canonical SUB50_LOW final-vote fields
_generated_cap_result                    -> canonical SUB50_LOW final-vote fields
```

`VoteGeneratedCapReached` in its current form is insufficient for v4 because
it stores only:

```text
generated
attempted
kept
```

and therefore cannot determine the majority bit at generated-cap termination.

Preferred implementation:

```text
DELETE VoteGeneratedCapReached
```

and raise/return the same canonical `VoteBudgetReached` result with:

```text
stop_reason = GENERATED_CAP
generated
attempted
kept
final_vote_ones
legacy_raw_high_ones if available
diagnostic majority/share CI
```

If a separate generated-cap class is retained, it must carry exactly the same
vote-count information and expose the same bit/direction semantics.

Generated cap behavior:

```text
kept > 0  -> OK deterministic majority bit
kept == 0 -> INCONCLUSIVE_NO_KEPT_ROWS
```

Do not let a generated-cap control-flow exception discard the accumulated
`FINAL_VOTES == SUB50_LOW` count.


### `_SequentialNarrowPrefetch`

Preserve or deliberately remove as specified in section 18A.14.

If preserved, guarantee `close()` on every exit path.

### `_PairVoteNarrowOverlapCache`

Preserve bounded exact overlap reuse as specified in section 18A.15.

Its statistics may remain in traces under generic names.

### `_BASE_RUN_BACKEND_IN_CONTEXT`

Current backend stores:

```python
_BASE_RUN_BACKEND_IN_CONTEXT = _base_run_backend_in_context
```

and the outer wrapper later calls that alias.

Do not leave the alias pointing at the old Tesla/MAX implementation after the
refactor.

Preferred options:

1. delete the alias and call the new shared private-free backend primitive
   directly; or
2. rename it to a neutral alias such as:

```python
_BASE_RUN_CERTIFIED_MODEL = build_certified_sub50_model
```

and ensure every caller uses the new implementation.

Add a source test proving no callable alias still references the deleted
Tesla/MAX/depth-aware execution core.

### Nested vote/control helpers inside `_base_run_backend_in_context(...)`

The current backend implements important control flow as nested functions.
They must be handled explicitly; top-level symbol cleanup is not enough.

#### `_adaptive_vote_confident(...)`

DELETE.

There is no confidence-based release/stop in v4.

#### `_majority_evidence(...)`

May remain only as a diagnostic helper.

It may compute:

```text
majority_share
Wilson CI
```

but its outputs cannot affect:

```text
stop
status
predicted_bit
retry
backend choice
recipe
```

#### `_flipped_count_from_voting_locals(...)`

Rename to neutral dynamic-SUB50 terminology if retained, for example:

```text
_final_low_ones_from_voting_locals(...)
```

Do not preserve the assumption that physical FLIPPED/ANTI is always the final
vote polarity.

#### `traced_make_candidate(...)`

Rewrite its voting stop logic exactly:

```text
NO adaptive_ready branch
NO vote_min_valid_rows
NO vote_min_majority_share

if attempted >= fixed_vote_tried_rows:
    stop = FIXED_BUDGET_MAJORITY

elif generated >= generated_cap:
    stop = GENERATED_CAP
```

At either stop, carry the captured `FINAL_VOTES == SUB50_LOW` ones count into
the fixed-budget result.

A generated-cap stop with `kept > 0` is a valid majority result.

Before terminating for generated cap, capture the current:

```text
kept
FINAL_VOTES ones
raw HIGH ones if available
```

from the same voting locals/counters used by the fixed tried-row stop.

Do not raise the old count-less `VoteGeneratedCapReached`.


#### `guarded_wilson(...)`

Rewrite or delete its voting-control behavior.

The current implementation explicitly says Wilson can trigger an early vote
stop. That is obsolete.

If retained:

```text
non-voting helper Wilson calls -> preserve exact helper behavior
voting Wilson calculation -> private-independent diagnostic only
```

It must never cause an early stop or acceptance/rejection.

Do not pass private/raw-oracle correctness into operational persistence or
control flow.

#### `coordinator_avb_gate_passed(...)`

Rewrite the training-release condition around:

```text
accepted_trainer_observations == 10
and
101-row SUB50 certificate structurally complete
```

No Tesla maturity.

No synchronized depth.

No normal-accuracy result.

If the helper needs this gate only to enter its vote loop, it is a compatibility
shim, not an independent certification rule.

#### `coordinator_avb_confidently_above_gate(...)`

Keep only as a compatibility neutralizer if the exact helper requires the
callable.

It must always prevent the legacy private/accuracy-aware rejection shortcut
from steering the run, e.g. return `False`.

It is unrelated to the v4 vote-majority decision.

#### `traced_train(...)`

Use it only to count/capture the exact trainer-observation clock and
representatives needed for the 101-row witness bank.

Do not count arbitrary internal optimizer steps as observations.

#### `traced_pairing(...)`, `prefix_conditioned_make(...)`, `_take_contiguous(...)`

Preserve the deterministic private-independent candidate/pairing geometry.

`prefix_conditioned_make(...)` must consume the rewritten execution-only
`scaled_prefix_workload(...)` contract and must not restore an adaptive
minimum-vote threshold.

### Other nested compatibility helpers in `backend.py`

Handle these explicitly when refactoring the parent functions.

#### `_call_original(...)`, `_normal_sign_predictions(...)`,
#### `bridged_predict_anti_predictions(...)`

These exist only inside the Tesla prediction-shift bridge.

DELETE them together with:

```text
_install_tesla_prediction_shift_bridge(...)
_tesla_original_predict_anti_predictions
_tesla_runtime_output_shift
_tesla_preserve_behavioral_vote
```

The new exact NORMAL/ANTI behavior is implemented directly from the frozen
model and exact complement rule, not through a Tesla shift bridge.

#### `configured_runtime(...)` / `built_optimizer(...)`

These wrappers may remain only if needed to preserve genuine `--fast` runtime
behavior.

Remove Tesla/legacy wrapper attributes and rename them neutrally if retained.

They may change execution mode/performance only.

They must not change:

```text
model seed
training-observation count
witness selection
SUB50 polarity
vote decision rule
```

#### `_record_flipped_vote(...)` / `character_print(...)`

Prefer structural capture of vote counts from the actual final vote arrays/result
rather than parsing console text.

If a specific exact helper omits the needed counts and compatibility print
capture is unavoidable, rewrite this layer around dynamic SUB50 terminology:

```text
FINAL_VOTES == SUB50_LOW
final_vote_ones
final_vote_kept
```

Do not infer physical polarity from the word `FLIPPED`.

An exact tie must remain a valid captured result:

```text
ones == zeros -> bit 0
```

not `direction=None -> inconclusive`.

Console parsing must never be the authority for SUB50 certification or hidden
truth.

#### `captured_build_model_fn(...)`

Prefer returning the frozen model explicitly from the new shared primitive.

If the legacy helper constructs the model internally and capture is still
required, this wrapper may remain only to retain a reference to that exact model
for final 101-row re-scoring.

It must not modify the model.

#### `backend_private_clean_atomic_json_write(...)`

Preserve the private-clean write interception if the exact helper still writes
JSON during a bounded attempt.

It must use the new private/evaluation-only scrubbers and fail closed.

#### `pair_cached_narrow(...)`

Preserve only as the attempt-local exact narrowing-cache adapter described in
section 18A.15.

No cached row may cross an incompatible prefix/backend/candidate-generation
scope.

#### `_below_count_label(...)` / `_below_count_deferred_label(...)`

DELETE with the old below-threshold/MAX log relabeling.

Do not cosmetically rename obsolete below-threshold logic into SUB50 language.

### `_base_run_backend_in_context(...)`

This is the current patched execution core.

Refactor it into the shared private-free training/SUB50/vote primitive rather
than leaving an old Tesla-aware implementation behind an outer wrapper.

All monkey patches installed inside its `try/finally` block must be audited:

```text
midpoint_skip_to_iteration
make_candidate_batch
build_model
make_training_representatives
train_normal_model
wilson_ci
avb_gate_passed
avb_confidently_above_gate
atomic_json_write
print
narrow_batch
```

After the function returns or raises, every patched helper symbol must still be
restored exactly.

Add a test that forces an exception mid-run and verifies helper symbols are
restored.

### `_relabel_backend_log_text(...)`

Rewrite or delete.

It currently rewrites old:

```text
below-threshold counts
MAX ratchet text
replay text
physical FLIPPED wording
```

No such text should survive.

If retained, it should only relabel harmless helper iteration text into current
bit/training/inference terminology.

### `_backend_narrow_gpu_available(...)`

Keep as a generic capability check if still used.

No semantic change.

### `run_backend_in_context(...)` / wrapper

Use shared:

```text
fixed 10 accepted trainer observations
representative pool
fixed 101 witness selection
final-model score
certificate
dynamic low adapter
vote
```

## `coordinator.py`

### `parse_args(...)`

Remove dead compatibility flags and all Tesla/depth/replay wording.

Resolve `--target-bit` exactly as section 11.6 requires.

### `_reset_evaluation_population(...)`

Preserve as a generic helper, but reset only new evaluation counters/target
state. No frozen depth fields.

### `_prepare_skip_initial_calibration(...)`

DELETE with the removed `--skip-initial-calibration` option.

### `_print_auto_advance(...)`

Keep if useful; update wording only. It must describe FIXED/legal and exact
suffix behavior, not Tesla/replay.

### `run_once(...)`

Remove direct-core early return.

Use fixed SUB50 behavioral calibration.

### `_prepare_next_fixed_calibration_trial(...)`

Remove Tesla/depth resets.

Fresh attempt only.

### `adaptive_main(...)`

Rewrite around the explicit four-phase state machine in section 17A.

Replace replay calls with `infer_ai_bit`.

Delete depth promotion branches.

Delete replay retry/recertification branches.

Do not create a validation target while phase is CALIBRATION.

### `_all_ai_bits_synchronized(...)`

Delete and replace with `_all_required_ai_recipes_complete(...)` or equivalent.

### `_enter_frozen_evaluation_if_ready(...)`

Rewrite to use development-full-inference verification and recipe completeness,
with no depth fields.

### `_calibration_attempt_seed(...)`

Remove synchronized N from signature/material and use candidate-generation +
attempt/config fields only.

### `_calibration_batch_state(...)`, `_capture_success_snapshot(...)`,
`_restore_success_snapshot(...)`

Remove MAX/depth/Tesla semantics or delete if no longer needed.

### `main(...)`

Use new logger/context.

No Tesla/global N metadata.

Preserve a deterministic initialization order:

```text
1. parse CLI
2. configure EXACT_SUFFIX_MAX_CANDIDATES from --exact-suffix-max-candidates
3. synchronize that configured threshold into active generic modules, or
   eliminate duplicated module globals entirely
4. if --reset: clear only the new active SUB50 state/artifacts/slots
5. load and recursively validate state using the already-configured threshold
6. recover any PREPARED/COMMITTED helper-slot transaction
7. initialize run logging/context
8. auto-advance fixed/legal/exact-suffix state as appropriate
9. enter the four-phase coordinator
```

The exact-suffix CLI value must be installed **before `load_state(...)`** because
it is correctness-affecting and participates in state/fingerprint validation.

Do not load state under the default threshold and apply the user's configured
threshold afterward.

### Top-level failure handling

Keep `KeyboardInterrupt` handling explicit.

For runtime failures after state has been loaded, do not catch only
`RuntimeError`.

Unexpected ordinary exceptions such as:

```text
ValueError
TypeError
OSError
helper-specific Exception subclasses
```

must also pass through one fail-closed cleanup path.

Use an `except Exception as exc` boundary (or equivalent) that:

```text
attempts helper-slot transaction recovery
does not invent a pass/fail result
best-effort persists only the validated/recovered coordinator state
best-effort emits runtime_error
best-effort finalizes run logging
returns a nonzero exit code
preserves the original exception type/message in diagnostics
```

Logging/finalization failures must not replace the original runtime failure.

Do not catch `SystemExit` from argparse/schema-reset requirements as an ordinary
runtime candidate failure.

Do not catch `KeyboardInterrupt` in the generic `Exception` branch.

A fatal unexpected exception must not leave helper monkey patches, prefetch
threads, transaction backups, or process-memory target entries in a state that
can contaminate the next run.

## `evaluation.py` (recommended) / evaluation helpers moved from old `replay.py`

Explicitly handle:

```text
_establishment_progress_signature        -> DELETE
_record_establishment_progress           -> DELETE
_new_validation_target                   -> _new_scoring_target
_current_validation_target               -> _current_scoring_target
_discard_unscorable_resumed_target       -> keep generic behavior
_finish_candidate_evaluation_batch       -> _finish_evaluation_candidate
record_establishment_target_failure      -> DELETE
record_full_target_evaluation_failure    -> record_frozen_target_failure
_finish_full_target                      -> _finish_full_target (new phase semantics)
```

Keep process-memory-only target truth helpers.

## `inference.py`

Create from useful portions of current `replay.py`.

### `_run_detector_inference(...)`

Target-specific reconstruction with fixed 10/101.

### `infer_ai_bit(...)`

Public runtime bit inference.

Preserve the split-anchor narrowed-equality ambiguity guard before model
training/voting and return a dedicated unscorable-input status.

### CUDA/cache helpers

Rename/preserve coarse replay-boundary memory cleanup as inference-boundary
cleanup. Ensure pair-local caches are dropped before GPU allocator cleanup.

### `_process_vote_row(...)` from old `replay.py`

When refactoring this nested helper into `inference.py`, rewrite its stop
contract.

Current old behavior contains:

```text
ADAPTIVE_CONFIDENT
HARD_VALID_TARGET
GENERATED_CAP
tie/no-kept -> INCONCLUSIVE
generated cap -> INCONCLUSIVE
```

New behavior:

```text
process deterministic candidate row
update generated / attempted / kept / FINAL_VOTES ones
compute Wilson/share only for diagnostics

if attempted >= fixed_vote_tried_rows:
    stop = FIXED_BUDGET_MAJORITY

elif generated >= generated_cap:
    stop = GENERATED_CAP

else:
    continue
```

After stopping:

```text
if kept == 0:
    INCONCLUSIVE_NO_KEPT_ROWS

else:
    zeros = kept - ones
    bit = 1 if ones > zeros else 0
    direction = "A > B" if bit == 1 else "A < B"
    status = OK
```

Therefore both of these are valid:

```text
GENERATED_CAP with kept > 0 -> OK majority bit
ones == zeros with kept > 0 -> OK bit 0
```

No confidence stop.

No tie retry.

No generated-cap retry.

No recipe mutation.

### `_normalize_narrow_value(...)`

Move to a generic shared module or keep under inference, but preserve its full
canonicalization contract from section 18A.13.

Target generation, ambiguity checks, and exact suffix must use the same
normalizer.

### `exact_suffix_recover(...)`

Keep exact suffix behavior.

### candidate/narrow helpers

Keep/rename generically.

## `state.py`

### `_reset_for_new_sync_regime(...)`

DELETE.

This nested helper exists only to reset candidate state after synchronized N
promotion.

There is no synchronized N regime in the new architecture.

Whole-candidate reset is handled only by the explicit candidate restart helper.

### `default_detector(...)` / `default_context(...)`

If the singleton:

```text
CONTEXT_ORDER = ("CANONICAL",)
BOUNDARY_NAMES = ("middle",)
```

hierarchy is retained for low-risk compatibility, simplify these records.

Remove:

```text
last_max_by_backend
last_success_max
max_increases
Tesla/depth/replay counters
```

Keep only private-free structural attempt/backend/curriculum data.

Do not add extra contexts/detectors.

If the implementation can safely collapse the redundant singleton nesting,
that is acceptable, but tests and recipe format must remain deterministic.

### `default_bit_state(...)`

Rewrite exactly to the new schema described in section 13.

Keep:

```text
FIXED
PENDING AI
EXACT_SUFFIX_ENUMERATION
EXACT_SUFFIX_MEMBER
```

Remove all Tesla/depth/replay/MAX/supervised-repair fields.

### `default_state(...)`

Build the explicit phase-machine validation state and immutable fixed 10/101
configuration only.

### `load_state(...)`

In addition, validate recursively against the exact current schema before using
any nested record.

Do not use patterns such as:

```python
row.update(old_row)
state.setdefault(...)
```

to preserve unknown predecessor fields.

Current-schema defaults may fill a missing optional field only after:

```text
schema version matches
all supplied keys are known
immutable configuration matches
```

A state containing all valid new fields plus one obsolete extra field must be
rejected.

Strict new-schema load only.

Required order:

```text
read JSON
validate exact script/schema
validate immutable run config
validate correctness/source fingerprints
private-persistence validation
recover transaction if needed
```

No predecessor migration.

### `save_state(...)`

Preserve:

```text
progress_summary refresh
updated_at
private-clean persistence copy
private-clean assertion
atomic JSON write
clean-pass evidence synchronization
```

using the new fields/file names.

### transaction backup internals

Keep generic equivalents of:

```text
_clear_transaction_backup_dir
_backup_current_slot_files
_restore_transaction_slot_files
```

only if helper slot JSON persistence remains.

### `clear_current_bit_backend_slots(...)`

Preserve if helper slot persistence remains.

Rename the slot prefix/files to the new active SUB50 namespace.

Call it only at explicit helper-state isolation boundaries.

If helper slots are eliminated, delete this function and all slot-file
constants/transaction logic together rather than leaving dead cleanup code.

### `reset_files(...)`

Rewrite for the new filenames.

Delete current state/audit/inference recipe/clean-pass evidence and active slot
files/transaction backup.

Do not delete historical old Tesla files outside the new active filenames.

### `current_bit_state(...)` / `current_ai_bit(...)`

Keep generic behavior but require new-format bit rows.

### `rotate_context(...)`

With one canonical context, this should normally be deleted.

Do not create artificial context rotation after Tesla removal.

### `clear_calibration_attempt_state(...)`

If retained, clear only private-free attempt-local structural fields.

No Tesla/MAX/depth/replay fields.

### `detector_recipe(...)`

Rewrite its serialized vote fields exactly.

Current old recipe emits:

```text
fixed_vote_orientation = FLIPPED_ONLY
fixed_vote_valid_rows_hard_cap
adaptive_vote_min_valid_rows
adaptive_vote_min_majority_share
fixed_vote_generated_rows_cap
calibration_vote_stop_reason
```

New recipe must emit only neutral v4 fields, e.g.:

```text
vote_decision_rule = FIXED_BUDGET_MAJORITY
fixed_vote_tried_rows
fixed_vote_generated_rows_cap
vote_candidate_chunk_rows
vote_tie_rule = BIT_0
final_vote_mode = DYNAMIC_SUB50_LOW
wilson_role = DIAGNOSTIC_ONLY
majority_share_role = DIAGNOSTIC_ONLY
confidence_gate_enabled = False
```

Do not serialize a calibration-time physical polarity as a runtime instruction.

Runtime recomputes `SUB50_LOW` from the current reconstructed final model.

The recipe's stop description must state:

```text
scan the fixed deterministic vote stream to the fixed tried-row target or
generated-row cap; if kept > 0 return the majority; otherwise no-kept
inconclusive
```

No adaptive/minimum-confidence language.

### `completed_bit_recipe(...)`

Rename/merge into the new inference recipe builder.

It must emit:

```text
FIXED_LEGAL
AI_SUB50_FIXED_FLIP
exact-suffix metadata
```

only.

### `invalidate_bit_after_label_free_runtime_inconclusive(...)`

Delete it.

Runtime inference is frozen/non-adaptive.

An inference inconclusive returns `INCONCLUSIVE`; it does not mutate/reopen the
bit recipe.

### `reopen_bit_for_runtime_replay_inconclusive(...)`

Delete it.

Do not replace it with a runtime reopen path.

### `mark_bit_unresolved(...)`

Keep only for bounded **development calibration structural failure** if useful.

It may mark the current candidate/bit unresolved and cause whole-candidate
rejection/restart.

It must not trigger N/depth growth or supervised repair.

### default state

No Tesla/direct/depth/replay counters.

### recipe build/save/validate

Inference recipe terminology.

### migrations

Delete old predecessor migrations.

### candidate restart/evaluation state

Use explicit CALIBRATION / DEVELOPMENT_VALIDATION / EVALUATION /
EVALUATION_COMPLETE phases.

No depth changes.

`_restart_development_candidate(...)` must clear the whole candidate's AI
recipes/evidence while retaining immutable run configuration.

Rewrite/delete `normalize_fixed_success_state(...)`.

Rewrite `progress_summary(...)`.

Rename replay semantic hash/persistence/audit path functions to inference
terminology.

Preserve transaction/slot crash consistency:

```text
begin_pair_transaction
commit_pair_transaction
finalize_pair_transaction
recover_pair_transaction
slot_paths
patch_backend_files
```

unless helper persistence is completely removed and equivalently tested.

Rename `establishment_full_replay_verified` fields to development full-inference
terminology while preserving the one-full-key-before-freeze gate.

## `common.py`

### Persistence classifiers/scrubbers

Explicitly rewrite and test:

```text
_FORBIDDEN_PERSISTED_PRIVATE_KEYS
_EVALUATION_ONLY_OPERATIONAL_KEYS
_is_evaluation_only_operational_key
_private_clean_persistence_copy
_operational_persistence_copy
_assert_operational_persistence_clean
_assert_private_clean_for_persistence
```

The new classifier must understand the new SUB50/evaluation naming and must not
depend on Tesla/below-threshold prefixes as its primary safety mechanism.

### Active helper/module and data-path registries

Current `common.py` defines:

```text
MODULES
DATA_DIR
CLEAN_PASS_PAIRS_FILE
SLOT_PREFIX
TRANSACTION_BACKUP_DIR
_RUNTIME_MAIN_PRIVATE_BY_SERIAL
```

Handle them explicitly.

`MODULES`:

```python
MODULES = {
    "phase32": <exact Phase32 helper>,
    "phase33_hybrid": <exact Phase33 helper>,
}
```

must remain the single authoritative backend-name -> exact-helper registry if
the two-backend architecture is retained.

Do not leave a deleted Tesla/direct module in that registry.

Do not create an alternate registry in `inference.py` that can drift from
calibration.

The same `MODULES` mapping must be used by:

```text
calibration
runtime inference
artifact validation
helper fingerprinting
backend alternation
```

Rename active paths to the SUB50 namespace exactly once in `common.py`.

The complete coordinator-level registry must include:

```text
DATA_DIR
STATE_FILE
RESULT_FILE
INFERENCE_RECIPE_FILE
CLEAN_PASS_PAIRS_FILE
SLOT_PREFIX
TRANSACTION_BACKUP_DIR
```

For example:

```text
STATE_FILE
    -> data/sub50_run_state.json

RESULT_FILE
    -> data/sub50_audit_result.json

REPLAY_RECIPE_FILE
    -> INFERENCE_RECIPE_FILE
    -> data/sub50_inference_recipe.json

CLEAN_PASS_PAIRS_FILE
    -> data/sub50_clean_full_pass_pairs.txt

SLOT_PREFIX
    -> sub50_helper_slot_

TRANSACTION_BACKUP_DIR
    -> data/sub50_txn_backup/
```

Choose the exact filenames once and use those constants everywhere.

Do not reconstruct them independently in `state.py`, `coordinator.py`,
`evaluation.py`, or `inference.py`.

### Do not confuse coordinator paths with helper slot-local paths

The exact Phase32/Phase33 helpers may themselves expose attributes named:

```text
WATERMARK_FILE
RUN_STATE_FILE
RESULT_FILE
```

Those are **helper-local slot files**, temporarily redirected by
`slot_paths(...)` / transaction code.

They are not the same object as the coordinator-level:

```text
STATE_FILE
RESULT_FILE
INFERENCE_RECIPE_FILE
```

Use explicit terminology/comments in the new code so an implementing refactor
does not accidentally:

```text
point a helper RESULT_FILE at the coordinator audit RESULT_FILE
include helper slot-local RUN_STATE_FILE in the coordinator state registry
delete helper rollback files when clearing only coordinator output
```

The transaction layer owns helper-local slot paths.

The coordinator persistence layer owns the top-level SUB50 files.

All state/backend/transaction code must import/use those central constants
rather than reconstructing filenames independently.

`_RUNTIME_MAIN_PRIVATE_BY_SERIAL` may remain only as the process-memory-only
target-truth map described elsewhere. Rename to a generic form such as:

```python
_RUNTIME_PRIVATE_BY_SERIAL
```

if desired, but never serialize it and always remove an entry when a target is:

```text
completed
discarded as ambiguous/unscorable
discarded after restart
candidate rejected
run terminated
```

### Generic atomic/hash/narrowing utilities

Preserve generic utilities unless their names are intentionally cleaned:

```text
atomic_json_write
atomic_text_write
_sha256_text
_sha256_file
_normalized_key_name
_callable_source_fingerprint
_backend_fingerprint
_canonical_narrow_contract_value
verified_narrowing_module
```

These are not Tesla code.

`_backend_fingerprint(...)` must continue to bind a recipe to the actual loaded
helper content.

At minimum include:

```text
module name
module source SHA256
script version
deterministic seed
narrower callable fingerprint
narrow_batch callable fingerprint
```

The resolved helper source path may be logged diagnostically, but absolute path
equality must not be required for portability.

A same-named helper with different source bytes must fail correctness
fingerprint validation.

`verified_narrowing_module()` should be simplified to validate/return the currently
selected backend's canonical narrowing implementation. It must not compare or
switch to the other backend.

Move `_normalize_narrow_value(...)` from old `replay.py` into this shared
utility layer or an equivalent generic location.

### `CONTEXT_FRACTION` and restored execution batch constants

Preserve the exact current canonical fraction and execution batch geometry as
specified in section 14.3A and include them in correctness fingerprints.

### `MAX_PRIVATE_256`

Preserve as generic legal-domain validation.

### `_NARROWING_CONTRACT_VERIFIED`

DELETE if it exists only for cross-backend narrowing-equivalence verification.

### Runtime performance settings

Keep existing performance settings that are already required by the current
runtime, but do not turn allocator/environment details into algorithmic state,
fallback logic, or separate compatibility machinery.

### `execution_speed_profile(...)`

Preserve the runtime geometry fields.

Rewrite stale scope text so it describes:

```text
execution geometry
CUDA fast runtime
optional CPU narrowing prefetch/cache
no effect on fixed 10 trainer observations
no effect on fixed 101 witness count
no effect on SUB50/vote semantics
```

### `_modular_source_sha256(...)`

Rewrite the active source list exactly.

Include the new active implementation files and exclude deleted Tesla/direct/
replay files.

A missing active source file must still affect/fail the fingerprint rather than
being silently omitted from correctness validation.

### `correctness_fingerprint(...)`

Expand the fingerprint to include every correctness-affecting immutable
inference setting, including at minimum:

```text
active modular source SHA-256
exact Phase32 fingerprint
exact Phase33 fingerprint
verified narrowing contract
execution geometry
fast/deterministic runtime mode if retained
fixed model seeds
canonical context policy
context span rows
fixed trainer observations (default 10)
fixed witness count (default 101)
SUB50 version
witness-selection rule/version
prediction callable/signature identity
prediction RNG rule/version and deterministic seed source
verified helper I/O contract/version for selector/decode/features/predictions
vote decision rule = FIXED_BUDGET_MAJORITY
vote tried-row ceiling
vote generated-row cap/multiplier
vote chunk rows
vote tie rule = BIT_0
Wilson/majority-share diagnostic-only policy
pair narrowing cache entry limit
vote generated-cap multiplier
prefix candidate policy
sample/fresh-draw hard limit
exact suffix max candidates/start position
split-anchor ambiguity policy/version
```

If any correctness-affecting field changes, persisted state/inference artifacts
must fail closed or require `--reset`.

### Prefix/domain utilities

Preserve:

```text
bit_at
_interval_has_bit_value
possible_bits_global
prefix_legal_interval_bits
possible_bits_for_prefix
context_offset_rows
build_middle_boundary
execution_domain_for_boundary
detector_truth
forced_boundary_domain
```

unless a function is deliberately collapsed into an equivalent tested helper.

No private current/future bit may enter the execution shell.

### `sample_context(...)`

Preserve the important input-only sampling order:

```text
sample complete legal scalar
validate prefix geometry
skip equality/degenerate geometry
only then derive calibration current bit/relation for evaluation-only audit
```

Return private fields only to the coordinator-side audit scope.

Do not pass the returned real private scalar into the operational backend
primitive.

### `detector_context(...)`

Remove private `strict_relation` from the operational backend context.

The operational context should contain only:

```text
position
prefix bits / legal interval
middle boundary
private-independent execution shell
public context geometry
backend/runtime configuration
```

Known relation belongs in an evaluation-only audit object outside the model
call.

### `forced_boundary_domain(...)`

Keep the invariant that its legacy private argument is ignored.

### Persisted `prefix_candidate_policy.workload_scaling` text

The current state/recipe metadata says:

```text
earliest adaptive confidence-check row count scales down ...
Wilson >50% criterion ...
```

DELETE that wording and any corresponding persisted semantics.

New metadata must describe only execution geometry, for example:

```text
candidate batch size may scale with recovered-prefix span for efficiency;
fixed vote tried-row budget and fixed-budget-majority decision rule do not
scale with prefix span
```

### `scaled_prefix_workload(...)`

Rewrite this helper because its current API includes the obsolete adaptive
confidence threshold.

Current form:

```python
scaled_prefix_workload(prefix_span, base_vote_min, base_vote_hard, base_batch)
```

must become a neutral execution-only form such as:

```python
scaled_prefix_workload(prefix_span, fixed_vote_hard, base_batch)
```

or be split into simpler helpers.

Preserve only private-independent execution geometry:

```text
prefix_span
candidate_batch
fixed vote tried-row ceiling
exact-suffix threshold
```

The fixed vote tried-row ceiling must remain the configured fixed hard budget;
it must not shrink because the prefix is smaller.

Delete outputs/logic such as:

```text
vote_min_valid_rows
SCALED_VOTE_MIN_FLOOR
SCALED_VOTE_FULL_SPAN_MULTIPLIER
earliest confidence-check scaling
```

The helper must not change:

```text
fixed 10 trainer observations
fixed 101 witness count
FIXED_BUDGET_MAJORITY decision rule
tie -> bit 0
Wilson/majority-share diagnostic-only role
```

`prefix_conditioned_make(...)` may still use the returned `candidate_batch` to
fit contiguous candidate batches inside the recovered-prefix interval.

It must no longer write:

```text
ns.vote_min_valid_rows
```

because that control does not exist in v4.

### `verified_narrowing_module(...)`, fingerprint helpers, atomic writers

Preserve their fail-closed correctness/persistence behavior unless renamed
generically.


New schema/version/files/constants/fingerprints.

Also explicitly update:

```text
_sync_modular_exact_suffix_globals()
```

from `replay` to `inference`, and preserve:

```text
forced_boundary_domain()
execution_domain_for_boundary()
build_middle_boundary()
detector_truth()
```

without introducing private-dependent candidate geometry.

## `main.py`

Thin entry point only.

## `__init__.py`

No stale Tesla/direct description.

### Module exports / `__all__`

Current modules use dynamic exports such as:

```python
__all__ = [name for name in globals() if not name.startswith("__")]
```

After deleting Tesla/direct/replay imports, verify those deleted symbols cannot
remain exported accidentally.

Prefer explicit `__all__` lists for the final small public surface, or at
minimum add a source/import test proving active modules export only current
SUB50/inference APIs.

`main.py` must import only the new coordinator entry point and its module
docstring must describe the SUB50 engine rather than "modular I10".

`__init__.py` docstring/package description must no longer describe the package
as Tesla/I10 replay architecture.


---

# 21. README / ARCHITECTURE DOCUMENTATION

Rewrite both around the final architecture.

README should explain:

```text
1. Train target-specific behavioral model for fixed 10 accepted trainer observations.
2. Freeze model.
3. Build deterministic 101-row non-private witness bank.
4. Score NORMAL and exact ANTI complement.
5. Odd witness count identifies exact below-50 physical polarity.
6. That polarity is SUB50_LOW; its exact complement is SUB50_HIGH.
7. Existing legacy raw vote source is SUB50_HIGH, and its fixed flip produces FINAL_VOTES=SUB50_LOW.
8. The fixed vote budget returns bit 1 iff SUB50_LOW ones > zeros; tie returns bit 0. Wilson/majority share are diagnostic only.
9. Persist the private-free inference recipe.
10. For each new target/prefix, runtime reconstructs its own model using the fixed recipe.
11. Split-anchor narrowed equality is handled as an unscorable input, never guessed.
12. Calibration sample freshness remains input-only and finite.
13. Exact-suffix enumeration takes over when the legal candidate universe is within the configured threshold.
14. The lifecycle is CALIBRATION -> DEVELOPMENT_VALIDATION -> EVALUATION -> EVALUATION_COMPLETE.
15. No Tesla, no adaptive depth, no replay recertification.
```

Architecture should distinguish:

```text
CALIBRATION
DEVELOPMENT_VALIDATION
EVALUATION
EVALUATION_COMPLETE
RUNTIME TARGET-SPECIFIC INFERENCE
SUB50 LOCAL CERTIFICATE
FIXED-BUDGET WEAK VOTE
EXACT-SUFFIX ENUMERATION
```

Explicitly state:

```text
SUB50 certainty is local to the deterministic witness bank.
Vote generalization remains empirical.
```

---

# 22. STATE MIGRATION POLICY

Fresh reset required.

Expected command:

```bash
python main.py --reset
```

If old state is found without reset:

```text
fail clearly
```

Do not interpret old:

```text
Tesla maturity
global N
direct-core capacity
replay recipe
below-50 counters
```

as new SUB50 state.

---

# 23. THINGS NOT TO DO

Do NOT:

- keep Tesla, direct-core, replay recertification, global N, maturity, or depth promotion;
- add a secondary/fallback backend path;
- retry an individual bit with another backend, seed, larger budget, or changed constants;
- add witness-only continuation after the fixed 10 training observations;
- change fixed 10 training observations or 101 witnesses after failure;
- wait for measured `normal_acc < 0.5`;
- use A_private/MAIN truth to choose polarity, recipe, backend, retry, or repair;
- assume physical NORMAL or ANTI is always SUB50_LOW;
- change `FINAL_VOTES = SUB50_LOW` or reintroduce 52%/Wilson acceptance gates;
- reuse one calibration model across different runtime prefixes;
- retry/reseed/retrain an unchanged runtime target;
- silently migrate old Tesla/direct/replay/depth state;
- send FIXED/legal or exact-suffix bits through SUB50;
- collapse exact-suffix `NO_MATCH` and `AMBIGUOUS` into the same outcome;
- persist private target material or per-bit hidden correctness;
- reopen one bit after a full-key development/evaluation mismatch;
- leave helper monkey patches/transactions dirty after failure;
- create alternative helper variants, fallback import paths, or compatibility layers that are not required by the exact active helpers;
- build extra portability/dependency/environment frameworks unrelated to the core behavior;
- spend time polishing unrelated legacy tests.

# 24. ACCEPTANCE CRITERIA

Implementation is complete when all of the following are true.

## Removal

- [ ] Tesla files/imports/state/logic are gone.
- [ ] `direct_core.py` is gone after relocating the still-needed canonical narrowing helper.
- [ ] `replay.py` is replaced by ordinary `inference.py`.
- [ ] global/synchronized N, maturity, depth promotion, MAX/below-threshold ratchets, and adaptive vote-confidence gates are gone.

## Fixed SUB50 algorithm

- [ ] one selected `--backend` is used; there is no alternate-backend fallback.
- [ ] each AI-bit calibration attempt trains for exactly 10 accepted trainer observations.
- [ ] there is no per-bit retry after structural failure.
- [ ] the 101-row witness bank comes only from representatives accumulated during those 10 observations.
- [ ] fewer than 101 witnesses is structural inconclusive; there is no witness-only continuation.
- [ ] the final frozen model rescoring identifies dynamic `SUB50_LOW` / `SUB50_HIGH` exactly.
- [ ] A_private/private truth is absent from operational certification.

## Voting/runtime

- [ ] `FINAL_VOTES == SUB50_LOW`.
- [ ] fixed-budget majority decides every vote with at least one kept row.
- [ ] tie deterministically maps to bit 0.
- [ ] Wilson/share are diagnostic only.
- [ ] same recipe + backend + prefix + A_narrow reconstructs identically.
- [ ] different prefixes reconstruct their own target-specific model.
- [ ] runtime never repairs/reopens a persisted bit recipe.

## Lifecycle

- [ ] lifecycle is exactly CALIBRATION -> DEVELOPMENT_VALIDATION -> EVALUATION -> EVALUATION_COMPLETE.
- [ ] development full-key failure rejects the whole candidate; no individual bit repair.
- [ ] frozen evaluation uses fresh targets and first failure rejects the candidate.
- [ ] candidate-generation loop is bounded and does not change 10/101/backend semantics.
- [ ] fixed/legal bits bypass SUB50.
- [ ] exact suffix remains exact, bounded-memory, and distinguishes OK/NO_MATCH/AMBIGUOUS/structural-INCONCLUSIVE.

## State/privacy

- [ ] new state/recipe schema is private-free and old architecture state requires reset.
- [ ] private scoring targets are never persisted.
- [ ] helper-slot transaction rollback remains correct if helper files still mutate.
- [ ] canonical narrowing normalization is shared by target generation, ambiguity checks, and exact suffix.

## Verification

- [ ] the compact tests in section 19 pass.
- [ ] source cleanup finds no active Tesla/direct/replay/depth/fallback/witness-only branches.
- [ ] short end-to-end smoke passes.

# 25. DESIRED CONSOLE OUTPUT

Calibration:

```text
================================================================================
SUB50 BIT CALIBRATION
================================================================================
Bit 187/256
Training target: 10 accepted trainer observations
SUB50 witness bank: 101 deterministic non-private representatives

  training observations 1/10
  ...
  training observations 10/10

  final model frozen
  witness bank 101/101

  SUB50 CERTIFIED
    NORMAL = 46/101 = 45.545%
    ANTI   = 55/101 = 54.455%
    SUB50_LOW  = NORMAL
    SUB50_HIGH = ANTI
    legacy raw vote source = ANTI
    final vote source = NORMAL (SUB50_LOW)

  Starting fixed-budget weak-signal vote...
  vote tried=200000
  vote kept=...
  ones=...
  zeros=...
  majority=...
  Wilson CI=...   # diagnostic only
  stop=FIXED_BUDGET_MAJORITY

BIT CERTIFIED
================================================================================
```

Runtime:

```text
================================================================================
SUB50 INFERENCE
================================================================================
Bit 187/256
Recovered prefix: ...
Training: 10 accepted trainer observations
Witness bank: 101

SUB50_LOW = ANTI
SUB50_HIGH = NORMAL
Legacy raw source = NORMAL
Final vote source = ANTI (SUB50_LOW)
Vote stop = FIXED_BUDGET_MAJORITY
Vote majority = ...   # Wilson diagnostic only
Predicted bit = 1
================================================================================
```

No:

```text
Tesla
maturity
global N
depth promotion
replay attempt
replay retry
recertification
```

---

# 26. FINAL DELIVERY

After implementing:

1. create `sub50_engine.zip`;
2. exclude logs, caches, `__pycache__`, old state, old Tesla files;
3. include updated `README.md` and `ARCHITECTURE.md`;
4. include `test_sub50.py`;
5. include exact Phase32/Phase33 helpers and required local companions under
   `helpers/` if available; otherwise explicitly document `PHASE32_HELPERS_DIR`
   dependency and do not claim standalone execution;
6. report files added/modified/deleted;
7. report exact test commands and outputs;
8. provide run command:

```bash
python main.py --reset
```

Do not return only prose or a patch. Return the complete runnable zip.
