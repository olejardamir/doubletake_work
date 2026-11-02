# Voynich unsupervised morphology — compact experimental specification

**Origin:** historical July 2026 draft, original Git blob `7ad8a114852cbc366bce4deaeb70cf010b03bea4`; full version recoverable from Git history. **Status:** research hypothesis, not a validated Voynich decipherment or DT capability. No transcription, code execution, results, license verification or benchmark replication was supplied. Historical source asserted MIT for its own draft; do not infer upstream corpus rights.

## Target and input contract

Cluster possible morphological variants in EVA/Takahashi Voynich transcriptions **without assuming meanings**. Preserve folio/section metadata (herbal, astronomical, biological), transcription variant, token frequency, line/word position and provenance; split by folio or section before fitting to prevent leakage. Sources proposed: voynich.nu / Interlinear Archive, with rights, exact edition, transcription ambiguities and source digests checked before use. Historic reference corpora (Latin, Italian, German, 1400–1500) are *optional* comparison data, not ground truth.

## Minimal pipeline and baselines

1. Parse lines and metadata; normalize only with a reversible glyph map. Record raw/normalized token counts, unknown glyphs, repeated text, rare forms and section sizes. Draft estimated ~9,000 unique tokens/~38,000 tokens overall; **unverified estimates**.
2. Start with character 2–5-gram TF-IDF and edit-distance nearest neighbours; compare subword fastText and contextual embeddings only with a fair held-out protocol. Original fastText skeleton used `sentences=[tokens]`, which treats the entire corpus as one sequence; correct sentence/line boundaries before any meaningful context claim. Fix seeds, versions, tokenization and vector dimensions.
3. Cluster via HDBSCAN (min cluster size initially 5, Euclidean on normalized embeddings), compare no-cluster and edit-distance baselines; retain noise/unassigned tokens. A single high silhouette is **not** semantic validity. Record membership confidence and false-merge/split examples.
4. Emit token→cluster/representative mapping, raw counts, section-conditioned frequencies, normalization reversibility, source hashes, parameter/seed manifest and held-out errors. Optional Zipf-rank substitution against historical corpora and LLM topic guesses are **exploratory interpretations**, not decipherment evidence.
5. Test stability under alternate transcription editions, random seeds, parameter ranges, folio holdouts and corrupted-glyph controls. Check section-specific patterns, within-cluster orthographic distances, token-frequency confounding, and null shuffled clusters. Visual t-SNE/UMAP plots are diagnostics, not proofs.

## Falsification and DT transfer boundary

Reject meaningful morphology if clusters collapse to frequency/length, do not generalize across folios/transcriptions, or have no advantage over character n-gram/edit-distance baselines. Without licensed source text and independent expert validation, outcome remains `NEEDS_EMPIRICAL_VERIFICATION`. A possible DT analogy is source-grounded unsupervised discovery with held-out negative controls; no current canonical DT owner, measurable gap, authority or research handoff has been established. Do not execute the old draft's installation commands or treat its code skeleton as tested implementation.
