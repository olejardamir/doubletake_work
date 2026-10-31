# Revised High-Level Workflow: Voynich Frequency-Mapping Experiment

## Purpose

This workflow describes a computational experiment for testing whether the Voynich manuscript contains a weakly recoverable word-level signal under a **universal frequency-compatible mapping**.

The goal is **not** to produce a clean translation. The goal is to test whether one manuscript-wide Voynich-token-to-known-word mapping can produce a **noisy semantic shadow** that is significantly more coherent than shuffled or randomized controls.

In simple terms:

```text
Voynich transcription
→ word frequencies
→ historically plausible reference corpus
→ universal soft frequency-compatible mapping
→ genetic algorithm search
→ page-level bag-of-words semantic scoring
→ shuffled and negative controls
→ ranked noisy semantic hypotheses
```

---

## Core Hypothesis

The experiment tests a narrow hypothesis:

```text
Some Voynich tokens may correspond, approximately and consistently, to known-language words or lemmas.
```

This does **not** assume:

- perfect word-for-word translation
- modern English plaintext
- natural word order
- grammatical output
- that the Voynich manuscript is meaningless if the experiment fails

A failed result should be interpreted conservatively:

```text
Under the assumptions of a universal, frequency-compatible word mapping into the selected corpus language, no recoverable semantic signal was found.
```

---

## 1. Voynich Text Preparation

**Technology involved:**  
ASCII/EVA Voynich transcriptions, Python text processing

**Purpose:**  
The Voynich manuscript must be converted into consistent machine-readable text. Each Voynich glyph group is treated as a token or “word.”

The transcription should be split into:

- manuscript-level text
- page-level text
- section-level text, where available
- token counts
- word-frequency rankings

**Robustness requirement:**  
Run the pipeline on at least two transcription variants where possible, such as Takahashi EVA and another independent EVA/Currier-style transcription. If the same type of signal appears across transcriptions, the result is more credible.

**Output:**

```text
Voynich token list
Voynich page index
Voynich section labels
Voynich global frequency table
Voynich page-level frequency tables
Transcription-version metadata
```

---

## 2. Reference Corpus Preparation

**Technology involved:**  
Digitized historical texts, corpus cleaning, lemmatization where possible

**Purpose:**  
The reference corpus supplies the known-language vocabulary or lemmas that Voynich tokens may map onto.

The preferred corpus should be in a **historically plausible language**, such as:

- medieval Latin
- early Italian
- early German
- Hebrew, if justified by the hypothesis
- another historically plausible language with domain-relevant texts

For a first prototype, English translations can still be used, but only as a **proof of concept**. English should not be treated as evidence for a historical plaintext unless the experiment is explicitly framed that way.

**Corpus types:**

- herbals
- medical texts
- botanical texts
- pharmacological or recipe texts
- astrological texts
- alchemical texts

**Output:**

```text
Cleaned reference corpus
Reference word or lemma frequency table
Reference rank list
Reference topic/section labels
Reference topic vectors
Stopword list for the chosen language
```

---

## 3. Language-Appropriate Embeddings

**Technology involved:**  
Embedding models, vector storage, cosine similarity

**Purpose:**  
Embeddings are used to measure whether mapped words form a meaningful semantic cluster. The embedding model must match the language of the reference corpus.

Recommended strategy:

```text
If using English translations:
  use fast local English-capable embeddings such as nomic-embed-text, embeddinggemma, or qwen3-embedding:0.6b

If using Latin or another historical language:
  use a language-appropriate model, such as a Latin-focused BERT/embedding model, multilingual sentence transformer, or custom corpus-trained embeddings
```

**Important limitation:**  
Modern English embedding models may not reliably capture medieval Latin, early German, or archaic domain terminology. The reference language and embedding model must be chosen together.

**Output:**

```text
Precomputed reference word/lemma embeddings
Precomputed topic embeddings
Embedding model metadata
```

---

## 4. Soft Frequency Compatibility

**Technology involved:**  
Python frequency analysis, rank comparison, soft penalties

**Purpose:**  
The mapping should be frequency-compatible, but not too rigid. Exact frequency-bin matching assumes that Voynich and the reference corpus have perfectly aligned rank distributions, which is unlikely.

Instead of hard frequency bins, use a **soft rank penalty**.

Example:

```text
rank_penalty = exp(-alpha * abs(voynich_rank_percentile - reference_rank_percentile))
```

or:

```text
rank_cost = min(abs(rank_diff), cap) / cap
```

This allows occasional rank mismatches when they improve semantic coherence.

**Optional practical compromise:**  
Use broad frequency bands only for initialization, but allow mutation to escape the band with a penalty.

**Output:**

```text
Frequency-rank compatibility score
Soft penalty function
Initial frequency-compatible mapping pool
```

---

## 5. Universal Mapping

**Technology involved:**  
Python dictionaries / mapping tables

**Purpose:**  
Each genetic algorithm candidate represents one universal dictionary:

```text
Voynich token → reference word or lemma
```

The same Voynich token must map to the same reference word everywhere in the manuscript.

This prevents page-level overfitting. Each page becomes a test case for the same mapping rather than receiving its own custom dictionary.

**Output:**

```text
One full-manuscript candidate mapping
```

---

## 6. Genetic Algorithm Search

**Technology involved:**  
Python genetic algorithm implementation

**Purpose:**  
The genetic algorithm evolves many candidate universal mappings and keeps mappings that produce stronger manuscript-level signal.

Each individual in the population is one full Voynich-to-reference dictionary.

The GA uses:

- diverse frequency-compatible initialization
- mutation with soft rank penalties
- crossover that preserves coherent parts of a mapping
- elitism to preserve strong mappings
- multiple random seeds
- train/validation evaluation

**Important implementation detail:**  
The GA should not optimize only on all pages at once. Use held-out validation pages so that a mapping must generalize beyond the pages used during selection.

Example split:

```text
80% training pages
20% validation pages
```

A candidate should be considered promising only if it improves both training and validation scores.

**Output:**

```text
Ranked candidate mappings
Generation-by-generation fitness history
Training score
Validation score
Seed-by-seed stability report
```

---

## 7. Page-Level Bag-of-Words Scoring

**Technology involved:**  
Python scoring functions, stopword filtering, embeddings

**Purpose:**  
Each candidate mapping is applied to every Voynich page. Each page receives a coherence score.

The expected output is noisy. A useful mapped page may look like:

```text
root, water, leaf, dry, vessel, plant, boil
```

This is not a readable translation, but it may indicate a meaningful semantic cluster.

The page scorer should reward:

- related content words appearing together
- section-appropriate vocabulary
- similarity to reference-corpus topic clusters
- stability of repeated Voynich terms
- improvement over random baselines

The page scorer should not require:

- grammatical sentences
- fluent prose
- natural word order
- readable translation

**Stopword rule:**  
Remove high-frequency function words before computing semantic coherence. This prevents the system from scoring accidental clusters of words such as “the,” “and,” “of,” or their equivalents in the selected reference language.

**Output:**

```text
Page coherence score
Page topic-alignment score
Page score above random baseline
Content-word list for inspection
```

---

## 8. Semantic Scoring Method

**Technology involved:**  
Precomputed embeddings, cosine similarity, topic vectors

**Purpose:**  
Semantic scoring checks whether the mapped content words on a page are closer to meaningful reference topics than random word sets are.

Recommended method:

```text
1. Map Voynich tokens to reference words/lemmas.
2. Remove stopwords.
3. Replace each mapped word with its precomputed embedding.
4. Average the word vectors to create a page vector.
5. Compare the page vector to reference topic vectors.
6. Use the mean similarity to the top-3 most similar topics.
7. Subtract the mean score of random reference-word sets of the same size.
```

Example:

```text
semantic_score = mean(cosine(page_vector, top_3_topic_vectors))
adjusted_semantic_score = semantic_score - mean(random_same_size_scores)
```

This is better than asking whether the page forms grammatical prose. It asks whether the page forms a weak semantic cloud.

**Output:**

```text
Adjusted semantic coherence score
Top matching reference topics
Random baseline comparison
```

---

## 9. Repeated Phrase Stability

**Technology involved:**  
Python n-gram extraction, repeated sequence analysis

**Purpose:**  
The system should preserve repeated Voynich sequences without assuming that the mapped output has natural language word order.

This replaces grammar-based bigram/trigram scoring.

Do **not** score whether mapped bigrams or trigrams are fluent in the reference language. That would incorrectly assume that Voynich word order should match the target language.

Instead, score whether repeated Voynich sequences produce stable repeated mapped sequences.

Useful checks:

- repeated Voynich token stability
- repeated Voynich phrase stability
- recurring page or section motifs
- overlap of repeated mapped content words across related pages

**Output:**

```text
Repeated-token stability score
Repeated-phrase stability score
Recurring motif report
```

---

## 10. Section Consistency

**Technology involved:**  
Voynich section labels, reference topic vectors, cosine similarity

**Purpose:**  
A good mapping should produce different semantic clouds in different manuscript sections.

For example:

```text
herbal pages → plant/preparation-like clusters
astronomical pages → celestial/calendar-like clusters
pharmaceutical pages → medicine/container/preparation-like clusters
```

This does not require knowing the exact content of each page. It only tests whether section-level differences become semantically meaningful after mapping.

**Output:**

```text
Section-level topic profile
Within-section coherence
Between-section separation
```

---

## 11. Controls and Null Distributions

**Technology involved:**  
Python randomization, shuffled mappings, shuffled text, significance testing

**Purpose:**  
Controls are essential. The system must show that the best mapping is better than chance.

Use several controls:

1. **Frequency-compatible shuffled mappings**  
   Randomly shuffle reference assignments while preserving similar rank compatibility.

2. **Random reference word sets**  
   Compare each mapped page to random word sets of the same size.

3. **Wrong-corpus controls**  
   Test whether unrelated corpora produce similar scores.

4. **Shuffled-text negative control**  
   Randomly permute Voynich tokens manuscript-wide and run the full GA pipeline on the shuffled text. If shuffled Voynich achieves similar gains, the method is detecting optimization artifacts rather than manuscript structure.

5. **Held-out pages**  
   Use validation pages that were not used for selection.

For each component, build a null distribution from many shuffled runs.

Example:

```text
z_component = (observed_component_score - mean(shuffled_component_scores)) / std(shuffled_component_scores)
```

Also report empirical p-values where appropriate.

**Output:**

```text
Null distributions
Z-scores
Empirical p-values
Negative-control comparison
Train/validation comparison
```

---

## 12. Fitness Formula

**Technology involved:**  
Python score aggregation, z-score normalization

**Purpose:**  
Avoid arbitrary weights. Each scoring component should be normalized against its own shuffled baseline.

Recommended fitness:

```text
fitness = z_semantic + z_rank_plausibility + z_phrase_stability + z_section_consistency
```

where:

```text
z_component = (observed_component_score - mean(shuffled_component_scores)) / std(shuffled_component_scores)
```

This means each component contributes in standard-deviation units relative to chance.

Do not include:

- LLM score in the fitness function
- grammar fluency score
- natural-language n-gram likelihood
- arbitrary fixed weights such as 0.40, 0.25, etc.

**Output:**

```text
Overall adjusted fitness score
Component-level z-scores
Fitness confidence diagnostics
```

---

## 13. LLM Use: Qualitative Sanity Check Only

**Technology involved:**  
Optional local Ollama model, such as a small Qwen/Gemma/Phi model

**Purpose:**  
The LLM should not be used in the genetic algorithm and should not influence candidate selection or ranking.

It may be used only after the GA run to help inspect the top mappings qualitatively.

Acceptable LLM use:

```text
Review top candidate page outputs
Summarize apparent semantic clusters
Compare mapped pages against shuffled controls
Flag obviously nonsensical outputs
```

Unacceptable LLM use:

```text
Score every candidate inside the GA
Translate the manuscript
Select the winning mapping
Reward fluent English output
```

Structured sanity-check prompt format:

```json
{
  "page_id": "f12r",
  "section": "herbal",
  "mapped_content_words": ["root", "leaf", "water", "dry", "plant"],
  "random_control_words": ["king", "river", "justice", "window", "milk"],
  "task": "Compare semantic clustering only. Do not translate. Return JSON."
}
```

**Output:**

```text
Qualitative notes only
No contribution to GA fitness
No contribution to final statistical significance
```

---

## 14. RTX 3060 Ti Execution Strategy

**Technology involved:**  
RTX 3060 Ti, Python, NumPy, optional PyTorch, Ollama or local embedding runtime

**Purpose:**  
The workflow should remain practical on 8GB VRAM.

Efficient division of work:

```text
CPU:
  tokenization
  frequency analysis
  genetic algorithm
  rank-penalty scoring
  phrase-stability scoring
  shuffled controls
  score aggregation

GPU:
  one-time embedding generation
  optional post-run LLM sanity checks
```

Important efficiency rule:

```text
Do not generate embeddings inside the GA loop.
```

Instead:

```text
1. Precompute embeddings for every unique reference word/lemma.
2. Store vectors in memory or on disk.
3. During GA scoring, create page vectors by averaging precomputed word vectors.
```

This keeps the GA fast enough for local experimentation.

**Output:**

```text
Precomputed embedding cache
Fast CPU-based GA scoring
Optional GPU-based post-run inspection
```

---

## 15. Final Ranking and Reporting

**Technology involved:**  
Python reports, CSV/JSON outputs, tables, optional dashboard

**Purpose:**  
The final result should be interpretable and statistically grounded.

For each top mapping, report:

- total fitness score
- semantic z-score
- rank-plausibility z-score
- phrase-stability z-score
- section-consistency z-score
- training score
- validation score
- shuffled-control comparison
- shuffled-text negative-control comparison
- top mapped terms per page
- top semantic topics per page
- stability across random seeds
- robustness across transcription variants

Do not report the top mapping as a translation. Report it as a ranked hypothesis under the tested model.

**Output:**

```text
Ranked candidate mappings
Per-page semantic reports
Control comparisons
Statistical significance report
Null-result interpretation if applicable
```

---

## Final Workflow Summary

This revised workflow combines:

```text
Voynich transcription variants
+ historically plausible reference corpus
+ language-appropriate embeddings
+ universal soft frequency-compatible mapping
+ genetic algorithm search
+ bag-of-words semantic scoring
+ repeated phrase stability
+ section consistency
+ shuffled controls
+ shuffled-text negative control
+ held-out validation pages
+ optional post-run LLM sanity check
```

The method is best understood as a **null hypothesis test** for a specific class of decipherment:

```text
A universal, frequency-compatible word or lemma mapping from Voynich tokens into a selected historical reference language.
```

If the real Voynich text significantly outperforms shuffled controls and shuffled-text negative controls, the result may indicate a weak semantic signal worth deeper investigation.

If it does not, the proper conclusion is limited but still useful:

```text
This specific mapping hypothesis did not recover a statistically detectable semantic signal.
```
