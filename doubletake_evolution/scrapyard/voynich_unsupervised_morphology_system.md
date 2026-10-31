# Voynich Manuscript Unsupervised Morphology Clustering System

## Engineering Documentation

**Version:** 1.0  
**Date:** July 2026  
**Purpose:** Build a system for unsupervised clustering of Voynichese tokens to identify morphological variants (stem-like groups) without assuming semantics. This supports frequency analysis, Zipf-based substitution, and topic approximation as per the proposed method.  
**Target Audience:** Software/ML engineers, computational linguists.  
**Assumptions:** Access to standard Voynich transcriptions (EVA/Takahashi). Python 3.10+ environment.

---

## 1. System Overview

The system performs:
1. Data ingestion & preprocessing of Voynich transcription.
2. Vector embedding of tokens capturing orthographic/morphological similarity.
3. Unsupervised clustering to group potential stem variants.
4. Cluster-based normalization for downstream frequency analysis & substitution.
5. Evaluation & visualization for iterative refinement.
6. Integration hooks for Zipf substitution and LLM topic guessing.

**Key Design Principles:**
- Language-agnostic and unsupervised.
- Focus on character-level patterns and contextual co-occurrence.
- Reproducible with fixed seeds.
- Modular for experimentation (e.g., different embeddings/clustering algos).

---

## 2. Requirements

### Software Dependencies
```bash
pip install numpy pandas scikit-learn gensim sentence-transformers hdbscan matplotlib seaborn jupyter
# Optional: fasttext, transformers
```

### Data Sources
- Voynich transcriptions: Download from standard repositories (e.g., voynich.nu, Interlinear Archive).
  - Recommended: `takahashi.txt` or EVA normalized files.
- Contemporary corpora (for later substitution): Latin/Italian/German texts from ~1400-1500 (e.g., via Project Gutenberg or historical archives).

---

## 3. Architecture

```
data/
  raw/          # Original transcriptions
  processed/    # Cleaned tokens, embeddings

src/
  preprocess.py
  embed.py
  cluster.py
  normalize.py
  evaluate.py
  visualize.py
  pipeline.py   # Main orchestrator

outputs/
  clusters.csv
  stats.json
  visualizations/
```

---

## 4. Detailed Components

### 4.1 Preprocessing (`preprocess.py`)

- Load transcription line-by-line.
- Tokenize on spaces.
- Basic cleaning: lowercase, remove rare glyphs if needed.
- Generate corpus statistics (word freq, unique tokens ~9k expected).
- Split by sections (herbal, astro, bio, etc.) based on folio metadata.

Example code skeleton:
```python
import pandas as pd
from collections import Counter

def load_voynich(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        lines = f.readlines()
    tokens = [token for line in lines for token in line.strip().split() if token]
    return pd.DataFrame({'token': tokens})

# Add section labels based on known folio ranges
```

### 4.2 Embedding (`embed.py`)

Goal: Represent tokens so similar morphological variants are close in vector space.

**Recommended Approaches (in order of complexity):**
1. **Character n-gram TF-IDF** (fast baseline).
2. **fastText** (subword, excellent for morphology).
3. **Custom word2vec** trained on Voynich.
4. **Sentence-Transformers** (contextual, fine-tune on corpus).

```python
from gensim.models import FastText
from sklearn.feature_extraction.text import TfidfVectorizer

def train_fasttext(tokens, vector_size=100, window=5, min_count=1):
    model = FastText(sentences=[tokens], vector_size=vector_size, 
                     window=window, min_count=min_count, epochs=10)
    return model

# For TF-IDF:
vectorizer = TfidfVectorizer(analyzer='char', ngram_range=(2,5))
X = vectorizer.fit_transform(tokens)
```

**Tips:** 
- Use character-level for unknown script.
- Experiment with dimensionality (64-300).

### 4.3 Clustering (`cluster.py`)

Use density-based clustering to handle varying group sizes.

```python
import hdbscan
from sklearn.preprocessing import normalize

def cluster_embeddings(embeddings, min_cluster_size=5):
    clusterer = hdbscan.HDBSCAN(min_cluster_size=min_cluster_size, 
                                metric='euclidean')
    labels = clusterer.fit_predict(embeddings)
    return labels

# Post-process: merge small clusters via edit distance if needed
```

**Evaluation Metrics:**
- Silhouette score.
- Number of clusters vs. unique tokens.
- Intra-cluster edit distance (should be low for true variants).

### 4.4 Normalization & Frequency Analysis (`normalize.py`)

- Map original tokens to cluster IDs or representative "stem".
- Compute frequency distributions per cluster.
- Generate normalized corpus for substitution.

### 4.5 Downstream Integration

- **Zipf Substitution:** Rank clusters by frequency, map to ranks in reference corpora.
- **LLM Prompting:** Feed substituted text sections with prompts like "What topic might this approximate text discuss, given herbal/astronomical illustrations?"
- Iterative refinement: Re-cluster after filtering low-confidence tokens.

### 4.6 Evaluation & Visualization (`evaluate.py`, `visualize.py`)

- Compare cluster distributions across manuscript sections.
- t-SNE/UMAP plots of embeddings colored by cluster.
- Frequency plots (log-log for Zipf validation).
- Consistency checks: Do clusters align with known morphological patterns (e.g., gallows characters)?

```python
import matplotlib.pyplot as plt
from sklearn.manifold import TSNE

def plot_clusters(embeddings, labels):
    tsne = TSNE(n_components=2)
    reduced = tsne.fit_transform(embeddings)
    plt.scatter(reduced[:,0], reduced[:,1], c=labels)
    plt.show()
```

---

## 5. Main Pipeline (`pipeline.py`)

```python
def main(transcription_path):
    df = load_voynich(transcription_path)
    # Embed
    model = train_fasttext(df['token'].tolist())
    embeddings = [model.wv[token] for token in df['token']]
    # Cluster
    labels = cluster_embeddings(embeddings)
    df['cluster'] = labels
    # Save & analyze
    df.to_csv('outputs/clusters.csv', index=False)
    # Downstream...
```

Run: `python pipeline.py path/to/transcription.txt`

---

## 6. Best Practices & Experimentation

- **Reproducibility:** Set `random_state` everywhere.
- **Hyperparameter tuning:** Use grid search for embedding size, cluster min_size.
- **Ablations:** Compare TF-IDF vs. fastText vs. contextual embeddings.
- **Scalability:** Voynich is small (~38k tokens) → runs on CPU.
- **Known Pitfalls:** Over-clustering rare words; glyph transcription errors.
- **Extensions:** Add positional features (word start/end glyphs), section-aware clustering.

---

## 7. Expected Outputs

- `clusters.csv`: token, cluster_id, frequency.
- Statistics: # clusters, coverage %, Zipf plots.
- Visualizations.
- Normalized text files for LLM input.

---

## 8. Next Steps / Research Notes

- Validate clusters against known Voynich morphology papers.
- Test substitution consistency across multiple reference books.
- Monitor for section-specific cluster usage (strong signal of meaning).

**License:** MIT (feel free to adapt).  
**Contributions:** Test, fork, share results on Voynich communities.

This document provides a complete blueprint. Implement iteratively and validate at each stage.
