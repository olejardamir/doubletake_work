# High-Level Workflow: Voynich Frequency-Mapping Experiment

## Purpose

This workflow describes a computational experiment for testing whether the Voynich manuscript may contain a weakly recoverable word-level signal under a universal frequency-based mapping.

The goal is **not** to produce a clean translation. The goal is to test whether a universal Voynich-token-to-known-word mapping can produce a **noisy semantic shadow** that is consistently more coherent than shuffled or random controls.

In simple terms:

```text
Voynich transcription
→ word frequencies
→ candidate historical reference corpus
→ universal frequency-compatible mapping
→ genetic algorithm search
→ page-level coherence scoring
→ shuffled baseline comparison
→ ranked semantic hypotheses
```

---

## 1. Voynich Text Preparation

**Technology involved:**  
ASCII/EVA Voynich transcription, Python text processing

**Purpose:**  
The manuscript must be converted into a consistent machine-readable format. Each Voynich glyph group is treated as a token or “word.”

The transcription should be split into:

- manuscript-level text
- page-level text
- section-level text, where available
- token counts
- word-frequency rankings

**Output:**

```text
Voynich token list
Voynich page index
Voynich section labels
Voynich global frequency table
Voynich page-level frequency tables
```

---

## 2. Reference Corpus Preparation

**Technology involved:**  
Digitized historical texts, English translations, Python corpus cleaning

**Purpose:**  
The reference corpus supplies the known-language vocabulary that Voynich tokens will be mapped onto.

For the first version, the reference corpus should preferably use **English translations** of relevant historical materials. This is important because the likely local embedding models are strongest in modern English.

Possible corpus sources include translated:

- medieval herbals
- medical texts
- botanical texts
- pharmacological or recipe texts
- astrological texts
- alchemical texts

**Output:**

```text
Cleaned reference corpus
Reference word-frequency table
Reference word-rank list
Reference section/topic labels
Reference bigram/trigram statistics
```

---

## 3. Frequency Binning

**Technology involved:**  
Python frequency analysis, percentile binning

**Purpose:**  
The mapping should not allow any Voynich word to map to any known word. That search space is too large and too unconstrained.

Instead, both Voynich tokens and reference-corpus words are sorted by frequency and divided into frequency percentile bins.

Example:

```text
Voynich frequency bin 1 → reference frequency bin 1
Voynich frequency bin 2 → reference frequency bin 2
...
```

This allows common Voynich words to map only to common reference words, and rare Voynich words to map only to rare reference words.

**Output:**

```text
Frequency-compatible mapping constraints
```

---

## 4. Universal Mapping

**Technology involved:**  
Python dictionaries / mapping tables

**Purpose:**  
Each genetic algorithm candidate represents one universal dictionary:

```text
Voynich token → known-language word
```

The mapping is universal across the manuscript. The same Voynich token must map to the same known-language word on every page.

This is important because page-specific mappings would overfit and create fake coherence.

**Output:**

```text
One full-manuscript candidate mapping
```

---

## 5. Genetic Algorithm Search

**Technology involved:**  
Python genetic algorithm implementation

**Purpose:**  
The genetic algorithm evolves many candidate universal mappings and keeps the mappings that produce the strongest manuscript-level signal.

Each individual in the population is one full Voynich-to-reference dictionary.

The GA uses:

- frequency-compatible random initialization
- mutation within frequency bins
- crossover within or across bins
- elitism to preserve strong mappings
- repeated generations to improve scores

**Important constraint:**  
Mutation and crossover should respect frequency bins. This prevents the algorithm from creating unrealistic mappings just to improve local scores.

**Output:**

```text
Ranked candidate mappings
Generation-by-generation fitness history
```

---

## 6. Page-Level Scoring

**Technology involved:**  
Python scoring functions

**Purpose:**  
Each candidate mapping is applied to every Voynich page. Each page receives a coherence score.

The system should expect noisy output, such as:

```text
root, water, leaf, dry, vessel, plant, boil
```

This is not a readable translation, but it may still indicate a meaningful semantic cluster.

**The page scorer should reward:**

- related content words appearing together
- stable repeated terms
- section-appropriate vocabulary
- similarity to reference-corpus topic clusters
- better-than-random coherence

**The page scorer should not require:**

- grammatical sentences
- fluent prose
- clean translation

**Output:**

```text
Page coherence score
Page semantic cluster label
Page score above shuffled baseline
```

---

## 7. Embedding-Based Semantic Scoring

**Technology involved:**  
Ollama embedding models, precomputed embeddings, cosine similarity

Recommended local embedding options:

```text
embeddinggemma
nomic-embed-text
qwen3-embedding:0.6b
```

**Purpose:**  
Embeddings convert words or pages into numerical vectors so that semantic relatedness can be measured.

The embedding scorer should measure:

1. **Intra-page coherence**  
   Whether mapped content words on the same page are semantically related.

2. **Topic alignment**  
   Whether a mapped page is closer to herbal, medical, astrological, or recipe-like reference sections.

3. **Section consistency**  
   Whether pages from the same Voynich section tend to map toward similar semantic fields.

**Efficiency requirement:**  
Do not generate embeddings repeatedly inside the GA loop.

Instead:

```text
Precompute embedding for every reference-corpus word once.
Store all vectors.
For each candidate mapping, compute page vectors by averaging precomputed word vectors.
```

This makes semantic scoring fast enough for RTX 3060 Ti hardware.

**Output:**

```text
Word embeddings
Page embeddings
Semantic coherence scores
Topic-alignment scores
```

---

## 8. Stopword Filtering

**Technology involved:**  
Python stopword lists, frequency filters

**Purpose:**  
Very common words such as “the,” “and,” “of,” and “to” can distort semantic scoring.

Before calculating semantic coherence, the system should remove high-frequency function words from the mapped page and from reference-topic vectors.

This ensures that the score reflects content words rather than accidental clusters of function words.

**Output:**

```text
Content-word-only page representation
Cleaner semantic coherence scores
```

---

## 9. N-Gram and Frequency Scoring

**Technology involved:**  
Python n-gram models, bigram/trigram frequency tables

**Purpose:**  
The system should include a lightweight statistical signal in addition to embeddings.

The reference corpus is used to calculate common bigrams and trigrams. Then the mapped Voynich text is scored according to whether its mapped word sequences resemble plausible reference-corpus word sequences.

This should be a weak signal, not the main score, because the expected output is noisy.

**Useful statistical components:**

- frequency-rank plausibility
- bigram plausibility
- trigram plausibility
- repeated phrase stability
- rare/common word balance

**Output:**

```text
Frequency plausibility score
N-gram plausibility score
Repeated-phrase score
```

---

## 10. Shuffled Baseline Controls

**Technology involved:**  
Python randomized controls, null distributions

**Purpose:**  
The experiment must show that the best mappings are better than random or shuffled alternatives.

Controls should include:

- random mappings
- frequency-compatible shuffled mappings
- wrong-corpus mappings
- page-shuffled mappings
- wrong-section mappings

Instead of using one shuffled comparison, generate many shuffled controls, such as 100 or more.

Then report:

```text
real score
mean shuffled score
standard deviation of shuffled scores
z-score
empirical p-value
```

This makes the result interpretable.

**Output:**

```text
Null distribution
Baseline-adjusted score
Statistical significance estimate
```

---

## 11. Small Local LLM Judge

**Technology involved:**  
Ollama small LLMs, structured JSON output

Possible local models:

```text
qwen3:1.7b
qwen3:4b
small Gemma model
small Phi model
```

**Purpose:**  
The LLM should not be the main scorer. It should only judge top candidate mappings after cheaper scoring has already filtered the population.

The LLM should not be asked to translate the page. It should only provide a structured assessment.

Example output format:

```json
{
  "semantic_cluster_score": 7,
  "looks_more_coherent_than_random": true,
  "probable_topic": "herbal preparation",
  "reason_short": "Plant, liquid, root, and preparation terms cluster together."
}
```

**Use rule:**

```text
Do not call the LLM for every candidate in every generation.
Use it only for top mappings every N generations, or at the final inspection stage.
```

**Output:**

```text
Secondary LLM coherence judgment
Optional sanity-check score
```

---

## 12. RTX 3060 Ti Execution Strategy

**Technology involved:**  
RTX 3060 Ti, Python, Ollama, quantized local models

**Purpose:**  
The system should be feasible on 8GB VRAM by keeping the main GA loop mostly CPU-based.

Recommended division of work:

```text
CPU:
  tokenization
  frequency analysis
  genetic algorithm
  n-gram scoring
  shuffled controls
  page-score aggregation

GPU:
  one-time embedding generation
  occasional small-LLM judging
```

The most important performance rule is:

```text
Precompute embeddings once.
Do not run the LLM inside the inner GA loop.
```

**Expected feasibility:**

```text
Statistical GA only:
  minutes to hours

GA + precomputed embeddings:
  hours

GA + occasional small LLM judging:
  several hours to overnight

LLM judging every page for every candidate:
  impractical
```

---

## 13. Fitness Formula

**Technology involved:**  
Python scoring aggregation, normalization

**Purpose:**  
The final score should combine several weak signals. Each component should be normalized before combination.

A practical first formula:

```text
Fitness =
  0.40 * semantic topic coherence
+ 0.25 * frequency-rank plausibility
+ 0.20 * repeated-term / repeated-phrase stability
+ 0.10 * section consistency
+ 0.05 * small-LLM judgment
- shuffled-baseline adjustment
```

A stronger version computes the baseline adjustment for each component:

```text
adjusted_component_score =
  real_component_score - mean_shuffled_component_score
```

Then the adjusted components are combined.

**Output:**

```text
Total mapping fitness
Component-level fitness breakdown
Baseline-adjusted final score
```

---

## 14. Final Ranking and Reporting

**Technology involved:**  
Python reports, tables, optional dashboard

**Purpose:**  
The system should produce interpretable outputs, not just one winning dictionary.

For each top candidate mapping, report:

- total fitness
- score above shuffled baseline
- page-by-page coherence scores
- strongest pages
- weakest pages
- probable section topics
- most important mapped terms
- repeated phrases
- null-distribution comparison
- LLM sanity-check results, if used

For each page, report:

```text
Page ID
Top mapped content words
Coherence score
Topic alignment
Score above shuffled baseline
Probable semantic cluster
Repeated terms
```

**Output:**

```text
Ranked candidate mappings
Page-level diagnostic reports
Statistical comparison against controls
```

---

## 15. Interpretation

The final output should be interpreted conservatively.

A good result would mean:

```text
This universal mapping produces page-level semantic structure
that is stronger than frequency-compatible shuffled mappings.
```

It would not mean:

```text
The Voynich manuscript has been translated.
```

A null result would also be meaningful. It would suggest that this specific hypothesis — a universal word-level substitution/codebook mapping into the chosen reference corpus — does not explain the manuscript well.

---

# Summary

This workflow combines:

```text
Voynich ASCII/EVA transcription
+ English translated historical reference corpora
+ frequency-compatible universal mapping
+ genetic algorithm search
+ precomputed word embeddings
+ page-level semantic scoring
+ n-gram and frequency scoring
+ shuffled baseline controls
+ occasional small local LLM judging
```

The experiment is designed to test whether a noisy but stable semantic signal can be recovered from the Voynich manuscript using a universal frequency-based mapping.

The key principle is:

```text
Do not ask whether the output is a perfect translation.
Ask whether it is consistently more coherent than random under controlled conditions.
```
