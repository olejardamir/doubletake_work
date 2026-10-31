# LLM Coding Agent Prompt: Build AudioFrameMosaic v2.3 — 10/10 Complete Local Prototype

You are an expert Python coding agent. Build a complete, runnable local Python project called **AudioFrameMosaic**.

This prompt is an execution contract, not a brainstorming document. Implement the project as working code.

The project generates a new music-driven video from:

1. A **source video** containing both frames and audio.
2. A **target song/audio file**.
3. An optional **image-to-image refinement stage**.

The system uses the source video's own audio-visual relationship as a database. It then navigates that database using the target song's audio features, retrieves source frames whose audio context resembles each target-song moment, blends those source frames, optionally refines the blended frame using img2img, and renders the final video with the target song as the audio track.

This is **retrieval-based audiovisual recomposition** with optional generative cleanup. It is not pure text-to-video generation.

---

# 0. Required Outcome

At the end, the repository must contain a working project that can run like this:

```bash
python run.py \
  --source-video source.mp4 \
  --target-audio song.wav \
  --output output.mp4 \
  --max-frames 120
```

The command must produce a playable MP4 using the target song as audio.

The base pipeline must work **without img2img**.

Do not stop after scaffolding. Do not leave core methods as TODOs. Do not provide only pseudocode. Implement the actual working system.

---

# 0.1 Coding Agent Execution Protocol

Follow this protocol while implementing:

1. Inspect the repository before editing.
2. If files already exist, modify them instead of overwriting blindly.
3. Keep changes focused on this project.
4. Implement in vertical slices:
   - config + CLI,
   - media extraction,
   - database,
   - matcher,
   - compositor,
   - renderer,
   - diagnostics,
   - tests.
5. After each major slice, run the most relevant tests or a syntax check.
6. Prefer small working modules over large monolithic files.
7. Avoid introducing unused abstractions.
8. Do not add network dependencies.
9. Do not require GPU.
10. Do not require a real img2img backend for the base pipeline.
11. Do not hide failures behind broad `except Exception` blocks.
12. Do not leave placeholder logic in the core retrieval/compositing/rendering pipeline.
13. Use type hints where practical.
14. Use `pathlib` for paths.
15. Use logging for operational progress and diagnostics.
16. Keep generated artifacts inside the configured work directory unless the output path is explicitly set elsewhere.
17. At the end, run tests and provide a concise implementation report.

If a requirement cannot be completed because of the local environment, implement the code path anyway and report the exact limitation.

---

# 0.2 Self-Verification Requirements

Before declaring the task complete, run:

```bash
python -m compileall .
pytest
```

If `pytest` cannot run because dependencies are missing, still run `python -m compileall .` and report the missing dependency clearly.

The repository must also include a smoke-test path using synthetic media generation. Implement one of these:

```bash
python run.py --make-demo-media
```

or:

```bash
python scripts/make_demo_media.py
```

The demo media generator should create a tiny source video and target audio using ffmpeg test sources when ffmpeg is available.

Demo media target:

```text
5–8 second source video
5–8 second target audio
small resolution, such as 320x180
low fps, such as 12 or 15
```

Then the README must show a smoke test equivalent to:

```bash
python run.py --make-demo-media --work-dir demo_work
python run.py --source-video demo_work/demo_source.mp4 --target-audio demo_work/demo_target.wav --output demo_work/demo_output.mp4 --max-frames 60 --work-dir demo_work/run
```

---

# 1. Core Pipeline

Implement:

```text
source video + target song
→ source audio/video feature database
→ continuity-aware audio matching
→ weighted / dominant frame compositing
→ optional img2img refinement
→ final video with target song
```

The source video provides the visual material.

The target song provides the navigation signal.

Img2img, if enabled, provides visual cleanup and coherence.

---

# 2. Visual Target

Without img2img, the output should look like:

```text
a ghostly, layered, audio-reactive recomposition of the source video
```

With img2img, the output should look more like:

```text
a cleaner, more coherent, generated-looking music video whose motion and content skeleton still comes from the source video
```

The most important visual property is **continuity**. The output should feel like it moves through the source video, guided by the target song, rather than flickering randomly across unrelated source frames.

---

# 3. Non-Negotiable Technical Requirements

The implementation must:

1. Work with img2img disabled.
2. Use local continuity-aware source-frame retrieval, not global random retrieval.
3. Build and save a source audio-vector database.
4. Generate composite frames.
5. Render an MP4 using the target audio.
6. Include tests for core algorithmic pieces.
7. Be deterministic by default.
8. Support practical resumability.
9. Validate ffmpeg and ffprobe availability.
10. Validate source media and target media.
11. Fail clearly when inputs, ffmpeg, ffprobe, or streams are invalid.
12. Save diagnostics files.
13. Keep img2img as an optional backend.
14. Use source-fitted feature standardization before cosine similarity.
15. Keep paths configurable.
15. Avoid hardcoded absolute paths.
16. Avoid silent failures.

---

# 4. Key Design Rules

## 4.1 Do not use one-frame audio duration as the feature window

At 30 fps, one visual frame represents about 0.033 seconds of audio. That is too short for reliable matching.

Use:

```text
output frame duration = 1 / fps
audio analysis window = 0.25s to 0.50s
```

Default:

```text
analysis_window_sec = 0.35
```

Each output video frame corresponds to one visual frame, but its audio vector is extracted from a wider centered audio window.

---

## 4.1b Standardize feature dimensions before cosine similarity

Raw audio features have very different numeric scales. For example, spectral centroid can have much larger values than RMS or MFCC deltas. If vectors are only L2-normalized, high-scale dimensions can dominate similarity.

Correct behavior:

```text
extract raw source feature vectors
→ compute source feature mean/std per dimension
→ z-score source vectors using source stats
→ L2-normalize standardized source vectors
→ save feature_standardization stats
```

For every target audio window:

```text
extract raw target feature vector
→ apply the same source-fitted mean/std
→ L2-normalize
→ compare with source vectors using dot product
```

Do not fit standardization separately on target audio. The target must use the source database's saved feature statistics.

Guard against zero standard deviation:

```python
std = np.where(std < 1e-8, 1.0, std)
```

This requirement is important for matching quality.

---

## 4.2 Do not globally search the whole source video for every target frame

Global search will cause chaotic flicker.

Use a moving **source cursor** and search locally around it.

Example:

```text
current source index = 5000
search radius = 180 frames
search range = 4820–5180
```

This preserves continuity.

---

## 4.3 Rescue search must use audio similarity only

Rescue search exists only to escape a bad local region.

Do not decide rescue based on `final_score`, because `final_score` includes continuity and forward-motion terms and can create false jumps.

Correct rule:

```text
if best_local.audio_similarity < min_local_audio_similarity:
    perform wider rescue search

accept rescue only if:
    best_rescue.audio_similarity > best_local.audio_similarity + rescue_audio_margin
```

---

## 4.4 Use Gaussian forward preference

Do not reward candidates simply because they are far forward.

Reward candidates close to the ideal next source position:

```python
forward_score = exp(-((delta - ideal_step) ** 2) / (2 * sigma ** 2))
```

Where:

```text
delta = candidate_index - current_source_index
ideal_step = 1
sigma = forward_sigma_frames
```

---

## 4.5 Keep composite and refined temporal smoothing separate

Keep separate histories:

```text
previous_composite
previous_refined
```

Correct order:

```text
current composite
→ smooth with previous composite
→ save composite
→ optional img2img
→ optional tiny refined-frame smoothing with previous refined
→ save final frame
```

Do not mix an unrefined composite with a previous img2img-refined frame before img2img.

---

## 4.6 Img2img must be optional and abstracted

Do not hardwire the pipeline to one img2img backend.

Create this interface:

```python
class Img2ImgBackend:
    def refine(
        self,
        input_image_path: str,
        output_image_path: str,
        prompt: str = "",
        negative_prompt: str = "",
        denoise_strength: float = 0.30,
        seed: int = 12345,
        previous_image_path: str | None = None,
    ) -> str:
        raise NotImplementedError
```

Implement:

1. `NoOpImg2ImgBackend`, which copies input to output.
2. A documented placeholder backend for future real img2img integration.
3. Clean extension points for ComfyUI, Automatic1111, or another backend later.

The main pipeline must work without img2img.

---

# 5. Project Structure

Create this structure:

```text
audio_frame_mosaic/
  run.py
  requirements.txt
  README.md
  default_config.yaml
  .gitignore

  scripts/
    make_demo_media.py

  afm/
    __init__.py
    config.py
    video_probe.py
    extract.py
    audio_io.py
    audio_features.py
    database.py
    matcher.py
    blender.py
    img2img.py
    temporal.py
    render.py
    diagnostics.py
    utils.py
    pipeline.py

  tests/
    test_audio_features.py
    test_audio_window.py
    test_matcher.py
    test_blender.py
    test_temporal.py
    test_database.py
    test_config.py
```

Generated files should go under a configurable work directory, defaulting to:

```text
work/
  manifest.json
  state.json
  logs/
    run.log
  source_frames/
    frame_000000.png
    frame_000001.png
  source_audio.wav
  target_audio.wav
  db/
    vectors.npy
    metadata.json
    feature_stats.json
    feature_standardization.json
  composites/
    frame_000000.png
  refined/
    frame_000000.png
  diagnostics/
    frame_matches.csv
    run_summary.json
  final/
```

---

# 6. Dependencies

Use:

```text
numpy
librosa
soundfile
Pillow
opencv-python
PyYAML
tqdm
pytest
```

Use `ffmpeg` and `ffprobe` as external command-line dependencies.

Optional only:

```text
faiss-cpu
```

Do not require FAISS for the first version. Sliding-window NumPy search is enough.

---

# 7. CLI

Implement:

```bash
python run.py \
  --source-video SOURCE_VIDEO \
  --target-audio TARGET_AUDIO \
  --output OUTPUT_MP4 \
  [--config CONFIG_YAML] \
  [--work-dir WORK_DIR] \
  [--fps FPS] \
  [--max-frames N] \
  [--start-source-index N] \
  [--use-img2img] \
  [--prompt PROMPT] \
  [--negative-prompt NEGATIVE_PROMPT] \
  [--rebuild-db] \
  [--resume] \
  [--no-clean] \
  [--debug] \
  [--make-demo-media]
```

Behavior:

- `--source-video`: required.
- `--target-audio`: required.
- `--output`: required.
- `--config`: optional YAML config.
- `--work-dir`: optional, default `work`.
- `--fps`: optional override.
- `--max-frames`: useful for testing.
- `--start-source-index`: override initial source cursor.
- `--use-img2img`: enables img2img stage.
- `--prompt`: optional global img2img prompt.
- `--negative-prompt`: optional global negative prompt.
- `--rebuild-db`: force rebuilding vectors and metadata.
- `--resume`: continue from saved `state.json` when possible.
- `--no-clean`: keep existing work files.
- `--debug`: verbose logging and diagnostics.
- `--make-demo-media`: generate tiny demo source/target media using ffmpeg test sources, then exit unless source/target/output are also supplied.

CLI values override config values.

---

# 8. Default Config

Create `default_config.yaml`:

```yaml
video:
  output_fps: null
  max_frames: null
  width: null
  height: null

audio:
  sample_rate: 22050
  mono: true

features:
  analysis_window_sec: 0.35
  mfcc_count: 20
  normalize_vectors: true

  use_mfcc: true
  use_chroma: true
  use_rms: true
  use_spectral_centroid: true
  use_spectral_bandwidth: true
  use_zcr: true

  use_delta_features: true
  use_onset_strength: true
  standardize_features: true

matching:
  top_k: 4
  search_radius_frames: 180
  rescue_radius_frames: 900

  min_local_audio_similarity: 0.12
  rescue_audio_margin: 0.06

  audio_weight: 0.78
  continuity_weight: 0.17
  forward_weight: 0.05

  softmax_temperature: 0.07

motion:
  initial_source_index: 0
  ideal_forward_step: 1
  forward_sigma_frames: 24
  max_cursor_step: 18
  cursor_velocity_smoothing: 0.85

blend:
  mode: weighted_average
  dominant_threshold: 0.82
  opacity_gamma: 1.4

  composite_temporal_mix: 0.05
  refined_temporal_mix: 0.02

img2img:
  enabled: false
  prompt: ""
  negative_prompt: ""
  denoise_strength: 0.25
  seed: 12345
  seed_mode: fixed
  use_previous_frame_reference: true

render:
  codec: libx264
  crf: 18
  preset: medium

diagnostics:
  write_frame_matches_csv: true
  write_run_summary_json: true
```

---

# 9. Config Implementation

Implement typed config loading.

Requirements:

1. Use dataclasses for config sections.
2. Load `default_config.yaml`.
3. Merge user config if provided.
4. Apply CLI overrides last.
5. Validate values.
6. Save final config snapshot into `run_summary.json`.

Validation examples:

```text
analysis_window_sec > 0
top_k >= 1
search_radius_frames >= 1
rescue_radius_frames >= search_radius_frames
0 <= composite_temporal_mix <= 1
0 <= refined_temporal_mix <= 1
0 < softmax_temperature
0 <= denoise_strength <= 1
max_cursor_step >= 1
0 <= cursor_velocity_smoothing < 1
standardize_features is boolean
```

Fail early with clear messages.

---

# 10. Media Probing

Implement `video_probe.py` using `ffprobe`.

Probe:

- FPS.
- Duration.
- Width.
- Height.
- Video stream exists.
- Audio stream exists.

Handle fractional FPS:

```text
30000/1001
24000/1001
25/1
30/1
```

If source video has no audio stream, fail clearly:

```text
Source video has no audio stream. AudioFrameMosaic requires source video audio for the source audio-visual database.
```

If target audio cannot be decoded, fail clearly.

Before extraction, check that `ffmpeg` and `ffprobe` are available.

---

# 11. FFmpeg Integration

Use:

```python
subprocess.run([...], check=True, capture_output=True, text=True)
```

If command fails, include stderr in the raised exception.

## Extract frames

```bash
ffmpeg -y -i source.mp4 -vf fps=30 work/source_frames/frame_%06d.png
```

If width and height are provided:

```text
fps=30,scale=WIDTH:HEIGHT
```

## Extract source audio

```bash
ffmpeg -y -i source.mp4 -vn -ac 1 -ar 22050 work/source_audio.wav
```

## Convert target audio

```bash
ffmpeg -y -i song.mp3 -ac 1 -ar 22050 work/target_audio.wav
```

## Render final video

Without img2img:

```bash
ffmpeg -y \
  -framerate 30 \
  -i work/composites/frame_%06d.png \
  -i work/target_audio.wav \
  -c:v libx264 \
  -pix_fmt yuv420p \
  -c:a aac \
  -shortest \
  output.mp4
```

With img2img:

```bash
ffmpeg -y \
  -framerate 30 \
  -i work/refined/frame_%06d.png \
  -i work/target_audio.wav \
  -c:v libx264 \
  -pix_fmt yuv420p \
  -c:a aac \
  -shortest \
  output.mp4
```

---

# 12. SourceDatabase

Implement:

```python
class SourceDatabase:
    def __init__(
        self,
        vectors: np.ndarray,
        metadata: list[dict],
        feature_mean: np.ndarray | None = None,
        feature_std: np.ndarray | None = None,
    ):
        self.vectors = vectors
        self.metadata = metadata
        self.feature_mean = feature_mean
        self.feature_std = feature_std
        self.count = len(metadata)

    def get_vector(self, index: int) -> np.ndarray:
        return self.vectors[index]

    def get_frame_path(self, index: int) -> str:
        return self.metadata[index]["frame_path"]

    def save(self, db_dir: str) -> None:
        ...

    @classmethod
    def load(cls, db_dir: str) -> "SourceDatabase":
        ...
```

Validate on load:

- vectors are 2D.
- metadata length matches vector count.
- every metadata record has required fields.
- frame paths exist.
- vectors contain finite values.
- feature standardization stats exist when `standardize_features` is enabled.
- feature mean/std dimensions match raw feature vector dimension.

Each metadata record:

```python
{
    "index": 1520,
    "frame_path": "work/source_frames/frame_001520.png",
    "time_sec": 50.6667,
    "audio_start_sec": 50.4917,
    "audio_end_sec": 50.8417,
    "vector_id": 1520
}
```

---

# 13. Candidate Object

Implement:

```python
from dataclasses import dataclass

@dataclass
class Candidate:
    source_index: int
    frame_path: str
    audio_similarity: float
    continuity_score: float
    forward_score: float
    final_score: float
    weight: float = 0.0
```

---

# 14. Audio Window Extraction

Implement:

```python
def get_audio_window(y, sr, center_time, window_sec):
    ...
```

Requirements:

- Center window around `center_time`.
- Pad with zeros before start or after end.
- Always return the same sample length for a given `window_sec`.
- Return `np.float32`.
- Handle very short audio.
- Avoid off-by-one length variation.

Recommended:

```python
target_len = int(round(window_sec * sr))
center_sample = int(round(center_time * sr))
start = center_sample - target_len // 2
end = start + target_len
```

Copy overlapping audio into a zero-filled output buffer.

---

# 15. Audio Feature Extraction

Implement:

```python
def extract_audio_features(y, sr, n_mfcc=20):
    ...
```

Features must include:

1. MFCC mean and std.
2. Chroma mean and std.
3. RMS mean and std.
4. Spectral centroid mean and std.
5. Spectral bandwidth mean and std.
6. Zero-crossing rate mean and std.
7. Delta features:
   - RMS second half minus first half.
   - Spectral centroid second half minus first half.
   - MFCC second-half mean minus first-half mean.
8. Onset strength mean and max.

Requirements:

- Always return a fixed-length 1D `np.float32` vector.
- Return finite values.
- Silence must not crash.
- Very short windows must not crash.
- Use `np.nan_to_num`.

Normalize:

```python
def normalize_vector(vec):
    vec = np.nan_to_num(vec, nan=0.0, posinf=0.0, neginf=0.0).astype(np.float32)
    norm = np.linalg.norm(vec)
    if norm < 1e-8:
        return np.zeros_like(vec, dtype=np.float32)
    return vec / norm
```

Similarity:

```python
audio_similarity = float(np.dot(target_vec, source_vec))
```

Assume both vectors are standardized with the same source-fitted stats and then normalized.

---

# 15.1 Feature Standardization

Implement:

```python
def fit_feature_standardizer(raw_vectors: np.ndarray) -> tuple[np.ndarray, np.ndarray]:
    mean = raw_vectors.mean(axis=0).astype(np.float32)
    std = raw_vectors.std(axis=0).astype(np.float32)
    std = np.where(std < 1e-8, 1.0, std).astype(np.float32)
    return mean, std


def apply_feature_standardizer(vec_or_matrix, mean, std):
    out = (vec_or_matrix - mean) / std
    return np.nan_to_num(out, nan=0.0, posinf=0.0, neginf=0.0).astype(np.float32)
```

Source DB build procedure:

```text
1. Extract all raw source feature vectors.
2. Fit mean/std from raw source vectors.
3. Standardize all source vectors with that mean/std.
4. L2-normalize standardized source vectors.
5. Save normalized vectors in vectors.npy.
6. Save mean/std in feature_standardization.json or npy files referenced by JSON.
```

Target frame procedure:

```text
1. Extract raw target feature vector.
2. Apply source DB mean/std.
3. L2-normalize.
4. Search.
```

Do not standardize each vector independently. Do not fit stats on target audio.

---

# 16. Build Source Database

Implement:

```python
def build_source_database(
    frames_dir,
    source_audio_path,
    fps,
    analysis_window_sec,
    config,
):
    ...
```

For each extracted frame index:

```python
time_sec = index / fps
```

Then:

1. Extract centered source audio window.
2. Extract a **raw** audio feature vector.
3. Add metadata record.
4. Add raw vector to a temporary list.

After all raw source vectors are extracted:

1. Fit source feature mean/std.
2. Standardize all raw source vectors using source mean/std.
3. L2-normalize standardized vectors.
4. Save normalized vectors.

Save:

```text
work/db/vectors.npy
work/db/metadata.json
work/db/feature_stats.json
work/db/feature_standardization.json
```

`feature_stats.json` should include:

- vector count.
- vector dimension.
- zero vector count.
- source fps.
- analysis window length.
- source audio duration.
- number of frame files.
- whether standardization was enabled.
- raw feature dimension.
- normalized vector dimension.

If DB exists and `--rebuild-db` is not provided, load and validate it instead of rebuilding.

---

# 17. Candidate Scoring

Implement:

```python
import math

def gaussian_forward_score(delta, ideal_step, sigma):
    sigma = max(float(sigma), 1e-6)
    return math.exp(-((delta - ideal_step) ** 2) / (2 * sigma ** 2))
```

Full score:

```python
def score_candidate(
    candidate_index,
    current_index,
    audio_similarity,
    search_radius,
    config,
):
    distance = abs(candidate_index - current_index)
    continuity_score = 1.0 - min(distance / search_radius, 1.0)

    delta = candidate_index - current_index

    forward_score = gaussian_forward_score(
        delta=delta,
        ideal_step=config.motion.ideal_forward_step,
        sigma=config.motion.forward_sigma_frames,
    )

    final_score = (
        audio_similarity * config.matching.audio_weight
        + continuity_score * config.matching.continuity_weight
        + forward_score * config.matching.forward_weight
    )

    return final_score, continuity_score, forward_score
```

---

# 18. Search Range

Implement:

```python
def search_range(target_vec, db, current_source_index, radius, config):
    ...
```

Requirements:

- Clamp start and end to DB range.
- Use vectorized NumPy similarity.
- Return `Candidate` objects.
- Include candidate frame paths.
- Score with `score_candidate`.
- Sort deterministically.

Recommended:

```python
start = max(0, current_source_index - radius)
end = min(db.count, current_source_index + radius + 1)

sub = db.vectors[start:end]
sims = sub @ target_vec
```

Tie-breaking order:

1. Higher final score.
2. Higher audio similarity.
3. Smaller distance from cursor.
4. Lower source index.

---

# 19. Candidate Search v2

Implement:

```python
def find_candidates_v2(target_vec, db, current_source_index, config):
    ...
```

Required behavior:

1. Clamp `current_source_index` inside `[0, db.count - 1]`.
2. Search local range.
3. Sort local candidates by deterministic ranking.
4. If best local audio similarity is below threshold:
   - search wider rescue range,
   - sort rescue candidates by audio similarity,
   - accept rescue only if rescue audio similarity beats local audio similarity by margin.
5. Select top-k from accepted pool by deterministic final ranking.
6. Apply softmax weights.
7. Return `(selected_candidates, rescue_used)`.
8. Never return empty candidates unless DB is empty; if DB is empty, fail clearly.

Implement:

```python
def should_accept_rescue(best_local, best_rescue, config):
    if best_local.audio_similarity >= config.matching.min_local_audio_similarity:
        return False

    return (
        best_rescue.audio_similarity
        > best_local.audio_similarity + config.matching.rescue_audio_margin
    )
```

---

# 20. Softmax Weights

Implement:

```python
def softmax_weights(scores, temperature=0.07):
    scores = np.array(scores, dtype=np.float32)
    if len(scores) == 0:
        return np.array([], dtype=np.float32)

    temperature = max(float(temperature), 1e-6)

    scores = scores - scores.max()
    exp = np.exp(scores / temperature)
    denom = exp.sum()

    if denom <= 1e-8:
        return np.ones_like(scores) / len(scores)

    return exp / denom
```

---

# 21. Dominant-Frame Fallback

Implement:

```python
def apply_dominant_fallback(candidates, dominant_threshold):
    if not candidates:
        return candidates

    candidates = sorted(candidates, key=lambda c: c.weight, reverse=True)

    if candidates[0].weight >= dominant_threshold:
        candidates[0].weight = 1.0
        return [candidates[0]]

    return candidates
```

This reduces constant ghosting.

Behavior:

```text
strong match → sharp single frame
several close matches → ghostly blended frame
```

---

# 22. Frame Blending

Implement weighted-average blending:

```python
def blend_candidate_frames(candidates):
    if not candidates:
        raise ValueError("Cannot blend frames: no candidates provided.")

    acc = None
    target_size = None

    for c in candidates:
        img = Image.open(c.frame_path).convert("RGB")

        if target_size is None:
            target_size = img.size
        elif img.size != target_size:
            img = img.resize(target_size, Image.Resampling.LANCZOS)

        arr = np.asarray(img).astype(np.float32) / 255.0

        if acc is None:
            acc = arr * c.weight
        else:
            acc += arr * c.weight

    acc = np.clip(acc, 0.0, 1.0)
    return Image.fromarray((acc * 255).astype(np.uint8))
```

Keep blend mode modular, but only weighted average is required for the first working version.

---

# 23. Temporal Smoothing

Implement:

```python
def temporal_smooth(current, previous, amount=0.05):
    if previous is None or amount <= 0:
        return current

    amount = min(max(float(amount), 0.0), 1.0)

    a = np.asarray(current.convert("RGB")).astype(np.float32)
    b_img = previous.convert("RGB")

    if b_img.size != current.size:
        b_img = b_img.resize(current.size, Image.Resampling.LANCZOS)

    b = np.asarray(b_img).astype(np.float32)

    out = a * (1.0 - amount) + b * amount
    out = np.clip(out, 0, 255).astype(np.uint8)

    return Image.fromarray(out)
```

Use composite smoothing before img2img and refined smoothing after img2img.

---

# 24. Cursor Movement

Use velocity-based cursor movement.

```python
def update_cursor_with_velocity(cursor, velocity, best_index, config, db_count):
    desired_move = best_index - cursor

    max_step = config.motion.max_cursor_step
    desired_move = max(-max_step, min(max_step, desired_move))

    smoothing = config.motion.cursor_velocity_smoothing

    velocity = (
        velocity * smoothing
        + desired_move * (1.0 - smoothing)
    )

    cursor = cursor + velocity
    cursor = min(max(cursor, 0), db_count - 1)

    return int(round(cursor)), velocity
```

---

# 25. Manifest and Cache Fingerprints

Implement:

```text
work/manifest.json
```

The manifest should record enough information to detect stale cached files:

```json
{
  "source_video": {
    "path": "...",
    "size": 123456,
    "mtime": 1234567890.0
  },
  "target_audio": {
    "path": "...",
    "size": 123456,
    "mtime": 1234567890.0
  },
  "fps": 30.0,
  "width": 1280,
  "height": 720,
  "sample_rate": 22050,
  "config_hash": "...",
  "db_feature_dim": 123,
  "standardize_features": true
}
```

When cached frames/audio/database exist:

1. Check the manifest.
2. If source media, fps, dimensions, sample rate, or relevant feature config changed, fail clearly unless `--rebuild-db` or a clean run is requested.
3. Do not silently reuse stale vectors.

This prevents subtle bugs where the DB belongs to a different source video or feature configuration.

---

# 26. Resume and State

Implement practical resumability using:

```text
work/state.json
```

Save after each generated frame:

```json
{
  "last_completed_frame": 119,
  "cursor": 1234,
  "velocity": 1.25,
  "previous_composite_path": "work/composites/frame_000119.png",
  "previous_refined_path": null,
  "config_hash": "...",
  "source_video": "...",
  "target_audio": "..."
}
```

When `--resume` is used:

1. Load `state.json`.
2. Verify source path, target path, config hash, fps, and img2img mode match.
3. Resume from `last_completed_frame + 1`.
4. Restore cursor and velocity.
5. Load previous composite/refined frame if present.

If state cannot be safely resumed, fail clearly and tell the user to run without `--resume` or use `--rebuild-db`.

---

# 27. Main Generation Loop

Implement generation in `pipeline.py`.

Required behavior:

1. Compute output frame count from target audio duration and fps.
2. Respect `max_frames`.
3. Use target frame time as `out_idx / fps`.
4. Extract target audio window.
5. Extract raw target vector.
6. Apply source-fitted feature standardization from the DB.
7. Normalize target vector.
8. Find candidates using v2 matcher.
7. Apply dominant fallback.
8. Blend candidates.
9. Smooth composite with previous composite.
10. Save composite.
11. Optionally run img2img.
12. Optionally smooth refined with previous refined.
13. Save frame.
14. Update cursor and velocity.
15. Save diagnostics row.
16. Save state after each completed frame.

The loop must work when img2img is disabled.

---

# 28. Diagnostics

Write:

```text
work/diagnostics/frame_matches.csv
work/diagnostics/run_summary.json
```

`frame_matches.csv` columns:

```text
out_idx
target_time
cursor_before
best_index
cursor_after
velocity
best_audio_similarity
best_final_score
top_weight
candidate_count
rescue_used
final_frame_path
```

`run_summary.json` fields:

```text
source_video
target_audio
output
fps
frame_count_requested
frame_count_generated
source_db_count
analysis_window_sec
top_k
search_radius_frames
rescue_radius_frames
img2img_enabled
prompt_used
config_snapshot
config_hash
started_at
finished_at
```

---

# 29. Rendering

Before rendering:

1. Verify selected frame directory exists.
2. Verify at least one frame exists.
3. Verify `frame_000000.png` exists.
4. Verify `target_audio.wav` exists.
5. Verify output parent directory exists or create it.

Render from:

```text
work/refined/
```

if img2img is enabled, otherwise:

```text
work/composites/
```

Use `-shortest`.

---

# 30. Img2Img Backend

Implement:

```python
class NoOpImg2ImgBackend(Img2ImgBackend):
    def refine(...):
        shutil.copyfile(input_image_path, output_image_path)
        return output_image_path
```

When `--use-img2img` is passed but no real backend is configured, use `NoOpImg2ImgBackend` and log:

```text
Img2img enabled, but no real backend is configured. Using NoOpImg2ImgBackend.
```

Do not break the pipeline.

---

# 31. Determinism

Default runs must be deterministic.

Requirements:

- No random frame selection.
- Stable ordering for equal scores.
- Fixed default img2img seed.
- Save config snapshot and hash.
- Sort frame filenames numerically.
- Tie-breaking must be deterministic.

Tie-breaking order:

1. Higher final score.
2. Higher audio similarity.
3. Smaller distance from cursor.
4. Lower source index.

---

# 32. Edge Cases

Handle:

1. Source video has no audio stream → fail clearly.
2. Target audio shorter than one output frame → generate at least one frame if possible.
3. Source video has fewer frames than search radius → clamp range.
4. Audio window extends before start or after end → zero pad.
5. Silent audio windows → finite zero-safe vectors.
6. Existing work directory → respect `--no-clean`, `--rebuild-db`, and `--resume`.
7. Missing ffmpeg/ffprobe → fail clearly.
8. Invalid FPS parse → fail clearly.
9. Frame extraction produces zero frames → fail clearly.
10. Different image sizes → resize secondary frames during blending.
11. Output directory does not exist → create parent directories.
12. DB exists but does not match source video/config → rebuild only if `--rebuild-db`, otherwise fail clearly.
13. Target audio duration is zero → fail clearly.
14. Source audio duration is shorter than video duration → zero padding should handle windows beyond audio end.
15. Feature standardization std contains zeros → replace with 1.0.
16. Cached DB manifest does not match current source/config → fail clearly unless rebuilding.

---

# 33. Demo Media Generator

Implement a demo-media generator so the project can be smoke-tested without user-supplied files.

Preferred location:

```text
scripts/make_demo_media.py
```

Also expose it through:

```bash
python run.py --make-demo-media --work-dir demo_work
```

Requirements:

1. Use ffmpeg test sources if ffmpeg is available.
2. Create a short source video with both video and audio.
3. Create a separate short target audio file.
4. Keep output small and fast.
5. Save paths clearly:
   - `demo_work/demo_source.mp4`
   - `demo_work/demo_target.wav`
6. If ffmpeg is missing, fail clearly.

Example ffmpeg source ideas:

```text
testsrc or smptebars for video
sine waves / anoisesrc / aevalsrc for audio
```

Do not require internet access.

---

# 34. Dependency and Environment Behavior

The project should not require GPU.

The base pipeline should not require any image-generation model.

If optional dependencies are missing:

1. Base pipeline should still work.
2. The error message should identify which feature requires the missing package.
3. The README should explain optional vs required dependencies.

If `librosa` warns about short audio windows, handle or suppress only narrowly where safe. Do not suppress all warnings globally.

---

# 35. Final Report Format for Coding Agent

When finished, provide a final report with this structure:

```text
Implemented:
- ...

Validation:
- python -m compileall .: pass/fail
- pytest: pass/fail
- demo media generation: pass/fail
- demo pipeline run: pass/fail

Generated/changed files:
- ...

Known limitations:
- ...

How to run:
- ...
```

Do not claim tests passed unless they were actually run.

---

# 36. README Requirements

Write a README explaining:

1. What the project does.
2. Why it is retrieval-based rather than pure AI video generation.
3. Required dependencies.
4. How to install Python dependencies.
5. Requirement for ffmpeg/ffprobe.
6. Minimal command.
7. Config file usage.
8. How to run a small test with `--max-frames`.
9. How img2img is currently handled.
10. Expected visual result:
    - without img2img: ghostly audio-reactive composite video,
    - with img2img: cleaner, more coherent, generated-looking frames.
11. Known limitations:
    - img2img temporal consistency is hard,
    - ghosting is possible,
    - feature matching is approximate,
    - output quality depends strongly on source video/audio.
12. Troubleshooting:
    - ffmpeg missing,
    - no source audio stream,
    - too much flicker,
    - too much ghosting,
    - output too slow.
13. Description of diagnostics files.
14. Description of resume behavior.
15. How to generate demo media.
16. How to run the demo smoke test.
17. Explanation that img2img is optional and NoOp by default unless a real backend is later configured.
18. Explanation that source-fitted feature standardization is used for stable audio matching.

---

# 37. Tests

Create tests.

## `test_config.py`

Test:

- Default config loads.
- User config overrides default.
- CLI overrides config.
- Invalid values raise clear errors.

## `test_audio_features.py`

Test:

- Feature vector has stable length.
- Feature vector contains finite values.
- Normalization does not produce NaN.
- Silence input does not crash.
- Very short input does not crash.
- Feature standardization uses source mean/std and preserves finite values.

## `test_audio_window.py`

Test:

- Returned window length is stable.
- Beginning padding works.
- Ending padding works.
- Middle extraction works.

## `test_matcher.py`

Test:

- Gaussian forward score is highest near ideal step.
- Local search returns candidates.
- Rescue is not accepted when local similarity is above threshold.
- Rescue is accepted only when audio similarity margin is satisfied.
- Candidate weights sum approximately to 1.
- Tie-breaking is deterministic.

## `test_blender.py`

Test:

- Blending returns a PIL image.
- Dominant fallback returns one candidate when top weight exceeds threshold.
- Weighted blend output has expected dimensions.
- Blending raises clear error on empty candidates.

## `test_temporal.py`

Test:

- Smoothing with `previous=None` returns current.
- Smoothing preserves image size.
- Smoothing amount 0 returns current.
- Smoothing handles different image sizes.

## `test_database.py`

Test:

- Database saves and loads.
- Metadata count matches vector count.
- Invalid database raises a clear error.
- Feature standardization stats save/load correctly.

## `test_demo_and_render.py`

Test where practical without requiring heavy media:

- Demo media command construction is valid.
- Render function checks for missing frames and audio.
- Output parent directory creation works.

---

# 38. Development Phases

Implement in this exact order.

## Phase 1: Skeleton and config

- Create package structure.
- Add requirements.
- Add default config.
- Add typed config loader.
- Add validator.
- Add CLI parser.
- Add logging.

## Phase 2: Media extraction

- Check ffmpeg/ffprobe availability.
- Probe source video.
- Extract source frames.
- Extract source audio WAV.
- Convert target audio WAV.
- Validate extracted files.

## Phase 3: Source database

- Load source audio.
- Extract source frame list.
- Build raw vectors and metadata.
- Fit feature standardization stats.
- Save normalized vectors.
- Save/load database.
- Add feature stats and standardization stats.

## Phase 4: Minimal output

- Generate output using local best-frame-only matching.
- Render MP4.
- Confirm complete pipeline works.

## Phase 5: v2 matching

Add:

- Gaussian forward score.
- Velocity cursor.
- Rescue based on audio similarity only.
- Top-k candidates.
- Softmax weights.

## Phase 6: Blending and smoothing

Add:

- Dominant-frame fallback.
- Weighted frame blending.
- Composite temporal smoothing.
- Diagnostics CSV.

## Phase 7: Manifest, state, and resume

Add:

- `manifest.json`.
- stale-cache checks.
- `state.json`.
- Config hash.
- Safe resume checks.
- Cursor/velocity restoration.

## Phase 8: Optional img2img

Add:

- Img2ImgBackend abstraction.
- NoOpImg2ImgBackend.
- Optional prompt and negative prompt.
- Optional previous-frame reference argument.
- Tiny refined-frame smoothing.

## Phase 9: Tests and README

- Add tests.
- Add README.
- Run tests.
- Verify minimal CLI command.

---

# 39. Acceptance Criteria

The task is complete when:

1. `python run.py --source-video source.mp4 --target-audio song.wav --output output.mp4 --max-frames 120` runs successfully on valid local files.
2. The program checks for ffmpeg and ffprobe.
3. The program probes source FPS, duration, width, height, and audio stream.
4. The program extracts source frames.
5. The program extracts source audio WAV.
6. The program converts target audio WAV.
7. The program builds `vectors.npy`, `metadata.json`, `feature_stats.json`, and `feature_standardization.json`.
8. Source features are standardized using source-fitted mean/std before L2 normalization.
9. Target features use the saved source-fitted mean/std before L2 normalization.
10. The program generates composite frames.
11. The program renders a playable MP4 with the target song as audio.
12. The program works with img2img disabled.
13. The code is modular and keeps img2img as an optional backend.
14. Composite temporal smoothing uses previous composite, not previous refined frame.
15. Rescue search is accepted based on audio similarity margin, not final score.
16. Forward preference uses a Gaussian around the ideal step.
17. The matcher uses local continuity-aware search around a moving cursor.
18. Dominant-frame fallback is implemented.
19. Diagnostics are written to `frame_matches.csv` and `run_summary.json`.
20. `manifest.json` prevents stale DB reuse.
21. `state.json` supports safe resume.
22. Unit tests for config, audio features, audio windows, matching, blending, temporal smoothing, and database save/load pass.
23. README exists and explains usage, limitations, diagnostics, feature standardization, demo media, and resume.
24. Errors are clear and actionable.
25. No core TODOs remain.
26. Demo media generation exists and is documented.
27. The coding agent runs or reports `python -m compileall .`.
28. The coding agent runs or reports `pytest`.
29. Final report distinguishes completed work from limitations.

---

# 40. Quality Bar

Do not leave TODOs in core functionality.

Acceptable placeholders:

- A documented non-functional real img2img backend.
- A working `NoOpImg2ImgBackend`.

Not acceptable:

- A pipeline that only works with img2img.
- A pipeline that globally jumps across source frames randomly.
- Missing ffmpeg error handling.
- Missing media validation.
- Missing tests for core logic.
- Silent failures.
- Hardcoded paths.
- Inconsistent frame naming.
- Non-deterministic candidate selection.
- Temporal smoothing that mixes composite with refined images.
- A README that does not explain how to run the project.
- Claiming validation passed without running it.
- Requiring internet, GPU, or a real img2img backend for the base pipeline.
- Comparing raw unstandardized feature vectors when standardization is enabled.
- Reusing cached DB files without manifest validation.

---

# 41. Final Implementation Notes

The most important implementation details are:

```text
1. Wider audio feature windows, not per-frame audio only.
2. Local continuity-aware search around a moving source cursor.
3. Audio-similarity-only rescue logic.
4. Gaussian forward preference.
5. Dominant-frame fallback to avoid constant ghosting.
6. Composite-to-composite temporal smoothing.
7. Optional img2img after the composite stage.
8. Deterministic scoring and tie-breaking.
9. Diagnostics for debugging the visual result.
10. Safe resume with state.json.
11. Clean CLI and clear errors.
12. Demo media generation for smoke testing.
13. Source-fitted feature standardization before cosine similarity.
14. Manifest validation to prevent stale cache reuse.
15. Final validation report with honest pass/fail status.
```

Build the simplest complete version first, then improve visual quality incrementally.

The base system must be usable before img2img exists.
