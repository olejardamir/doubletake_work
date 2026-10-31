# Audit findings and corrections

## Problems found in the first ZIP

1. **The 64 semantic source values were not authoritative.** The file had 64 states, but each was represented by a shortened synthesized `core_direction` sentence. These were not the full values in the calibrated-I-Ching repository README.
   - Fixed: `data/source_README.md` is now byte-for-byte identical to the repository README blob `d64717fd75945c0da54b0437382e53b6d23e86ba`.
   - Fixed: `data/iching_states.json` is generated from that README and embeds the full interpretation paragraph for each state.

2. **The unfavorable↔favorable correspondence had been changed.** The first ZIP invented a Hungarian assignment minimizing semantic cosine. That did not preserve the orientation/correspondence used in the preceding work.
   - Fixed: the frozen ordered correspondence from the two established 32-state manifests is restored. It includes 36↔32, 47↔48 and 56↔59.

3. **The vector extraction backend incorrectly assumed Ollama `gemma2:2b` would provide `/api/embed`.** The standard model is primarily a completion model and may reject embedding requests.
   - Fixed: default backend automatically uses `llama.cpp` `llama-embedding` on the same Ollama GGUF/blob when the exact tag does not expose embedding capability. No different embedding model is substituted.

4. **The original tests checked simplex geometry but not the actual requested 33rd-point invariant.**
   - Fixed: both build-time verification and tests now prove that an arbitrary point's 32 distances to the unfavorable anchors are preserved after the full-die rotation as distances to the paired favorable anchors.

5. **Goal verbalization used only a small top-k subset.**
   - Fixed: Gemma now receives the complete 32-point favorable relation profile, ordered by measured strength, while the original input remains hidden from the goal-generation prompt.

6. **The final path prompt had increases/decreases but no explicit stable component.**
   - Fixed: it now includes strongest increases, strongest decreases, and stable goal-compatible anchors so the final instruction can say what to preserve as well as what to change.

7. **Model identity mismatches were warnings rather than hard failures.**
   - Fixed: strict model identity checking is now the default for digest, family, parameter-size prefix and quantization.

8. **Output file names could collide for two runs in the same second.**
   - Fixed: output timestamps now include microseconds.

## What cannot be pre-verified in this environment

The actual 64 Gemma vectors cannot be produced here because this runtime does not contain the user's exact local Ollama model/GGUF and llama.cpp binary. The ZIP therefore verifies all source data and geometry code statically and generates those vectors only on the target machine. `doctor.py` and `verify.py` fail rather than silently fabricating or substituting data.

## Second-pass audit corrections

8. **The configured 8192 context was not actually enforced.**
   - Fixed: both Gemma generation calls now explicitly send `num_ctx=8192`; hidden-state extraction also passes `--ctx-size 8192`. The model metadata is checked for sufficient native context.

9. **Build/runtime embedding identity was not frozen strongly enough.**
   - Fixed: the resolved GGUF content identity and `llama-embedding` binary SHA-256 are frozen in the recipe and compared at runtime, along with pooling, normalization, GPU-layer count, context, model tag and model digest.

10. **Generated calibration files could be changed after build without immediate detection.**
    - Fixed: SHA-256 hashes for every numerical/calibration artifact are stored in the build manifest and verified before each run.

11. **A perfect simplex could theoretically be geometrically correct but semantically mislabeled.**
    - Fixed: all 64 source semantic directions must retrieve their own corresponding calibrated vertex as rank 1. A non-positive own-state alignment fails the build.

12. **An almost-degenerate 63rd PCA direction could be amplified by normalization.**
    - Fixed: the build records and enforces a minimum `s63/s1` singular-value ratio.

13. **The final action prompt only saw selected anchor changes.**
    - Fixed: it now receives a compact complete 64-anchor change profile in addition to detailed strongest increases/decreases and stable aspects.

14. **The unit tests did not explicitly verify build/runtime projection identity or congruence of the two halves.**
    - Fixed: tests now prove source-vector projection consistency, that both halves are congruent regular 31-simplexes, and that their centered affine spans are orthogonal.
