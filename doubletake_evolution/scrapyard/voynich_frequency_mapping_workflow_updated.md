# Voynich universal frequency-mapping experiment — distilled historical workflow

**Provenance:** historical public scrapyard source `doubletake_evolution/scrapyard/voynich_frequency_mapping_workflow_updated.md`, pre-surgery blob `2da46b82d46ce8e29e209409f1bcf3e0819e0791` (12,982 bytes; recoverable in Git history). This is a **hypothesis-testing design**, not a translation, validated empirical result, or DT/Borg implementation task. Manuscript transcription, source edition, reference corpus licensing, ground truth, model versions and actual results remain **UNKNOWN**.

## Hypothesis and fixed representation

Test whether one **global** Voynich-token→known-language-word mapping produces a weak but repeatable page/section semantic signal stronger than properly matched null mappings. Never optimize separate dictionaries for each page; that would manufacture coherence. Preserve manuscript/page/section IDs, token frequencies, transcription convention (ASCII/EVA or explicitly chosen edition), uncertainty and missing/variant glyphs. The proposed reference corpus consists of cleaned English translations of historically relevant herbal, botanical, medical, pharmacological, recipe, astrological or alchemical texts, with word frequencies, ranks, topic labels and bigram/trigram counts. Translation/domain choices are hypotheses, not established provenance or language identification.

Sort Voynich and reference tokens by frequency percentile; restrict each candidate dictionary and mutation to compatible frequency bins. Each genetic-algorithm individual is a full-manuscript dictionary; initialize randomly within bins, use constrained mutation/crossover, elitism and reproducible generations. Guard against accidental one-to-many or page-specific mappings, leakage of evaluation pages into search, and corpus-specific topical bias.

## Scoring and controlled search

For each global dictionary, map every page and calculate **content-word** page coherence without requiring grammatical sentences. Remove common function words from semantic scoring while retaining raw counts for frequency statistics. Precompute embedding vectors once (historical candidate local models: `embeddinggemma`, `nomic-embed-text`, `qwen3-embedding:0.6b`; present compatibility unverified). Measure (a) within-page semantic relatedness, (b) alignment with reference topics, (c) section consistency, (d) repeated-token/phrase stability, (e) frequency-rank plausibility and (f) weak bigram/trigram plausibility. A fluent-looking page is not an acceptance criterion.

**Illustrative, not calibrated, original weighted formula:**

```text
Fitness = 0.40 * topic coherence
        + 0.25 * frequency-rank plausibility
        + 0.20 * repeated-term/phrase stability
        + 0.10 * section consistency
        + 0.05 * small-LLM judgment
        - shuffled-baseline adjustment
component_adjusted = component_real - mean(component_matched_shuffles)
```

Normalize components before weighting; freeze weights/selection before evaluating held-out pages. The original fixed weights are arbitrary design starting points, not evidence of optimality or statistical significance. If a small local LLM is used, invoke it **only for top mappings at sparse checkpoints/final review**, never every candidate inside the GA loop. Ask for structured coherence-vs-random judgment and short possible topic, not a claimed translation; guard against judge hallucination/contamination.

**Compute strategy in the historical RTX 3060 Ti / 8GB VRAM plan:** CPU tokenization, frequency tables, GA, n-grams, shuffles and page aggregation; GPU one-time embeddings and occasional small-model review. Timings in original were rough estimates (statistical GA minutes–hours, embeddings hours, sparse judge hours–overnight), not measurements; actual hardware/model context may differ.

## Null controls, falsifiers and reporting

Predeclare train/validation/held-out manuscript pages and reference corpora, fixed seeds, GA budget and stop rules. Compare the selected global mapping against many nulls (original suggestion >=100), including unconstrained random, **frequency-compatible shuffled**, wrong-corpus, page-shuffled and wrong-section mappings. Re-run search under the same compute budget for nulls; otherwise optimizing only the real mapping biases the comparison. Report null mean/SD, empirical tail probability and score above matched null; avoid claiming an arbitrary z-score alone proves semantics. Test sensitivity to transcription variant, reference-corpus composition, stopword filtering, embedding model and section definitions. A mapping that scores only on training pages, one reference domain or an LLM judge is not persuasive.

For each ranked candidate, retain full dictionary/version, component-level and baseline-adjusted fitness, strongest/weakest page scores, section/topic alignment, repeated terms, null-distribution comparison, held-out performance and optional judge uncertainty. Per page: ID, mapped content terms, coherence, topic, repeated tokens and above-null margin. Preserve negative and null results, not only top examples.

**Interpretation boundary:** Above-null stable coherence supports only the narrow hypothesis that this *specific* universal mapping plus selected reference corpus yields a nonrandom semantic shadow. It does **not** establish Voynich language, decipherment, translation or historical meaning. Failure constrains this model/corpus/search setup, not every possible decipherment hypothesis. Recheck only on source-licensed corpus and pre-registered, reproducible held-out evidence.

**DT relevance:** only indirect transferable methodology—fixed-budget candidate search, explicit provenance, matched nulls and no proxy→Ground conflation. No current B1/B7 fix, DT source consumer, permission or measurable transfer identified. Do not create a Director handoff without a distinct authorized DT gap/fixture.
