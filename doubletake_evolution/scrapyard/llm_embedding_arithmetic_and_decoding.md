# Embedding-Only Algebra and Logic for Modern LLM Embeddings

**Version 4.1 — provider-agnostic, embedding-only, execution-audited**

## Executive summary

This document implements the narrower system intended here:

```text
human-readable text
        ↓
embedding provider
        ↓
ordinary numeric embedding vector
        ↓
ARITHMETIC and/or LOGIC
        ↓
result vector, result predicate, or result set
        ↓
nearest-neighbor retrieval from an embedded text universe
        ↓
human-readable text
```

The system deliberately does **not** depend on token-level hidden states, transformer-layer hooks, activation steering, or a hidden-state decoder.

The only semantic input is the vector returned by an embedding model or embedding endpoint.

The core implementation supports:

- OpenAI embedding endpoints;
- any OpenAI-compatible `/v1/embeddings` endpoint, including vLLM and LM Studio when configured with an embedding-capable model;
- Ollama `/api/embed`;
- arbitrary local or remote providers through one small Python interface;
- Word2Vec-style arithmetic such as `b - a + c`;
- relation vectors learned by averaging embedding differences;
- centering and optional whitening;
- nearest-neighbor conversion back to human-readable strings;
- exact Boolean `AND`, `OR`, and `NOT` over embedding-defined predicates;
- learned linear half-space predicates built only from embeddings and labeled examples;
- fuzzy logic when graded rather than hard membership is desired;
- deterministic tests for arithmetic, logic laws, numerical edge cases, provider parsing, and ranking.

The most important conclusions are:

1. **Arithmetic can operate directly on LLM embedding vectors.**
2. **A generic embedding vector has no universal inverse to free-form text.** With embeddings alone, the reliable inverse operation is nearest-neighbor retrieval from a pre-embedded human-readable candidate universe.
3. **Do not define Boolean logic as `AND = a + b` or `NOT = -a`.** Those are geometric heuristics, not Boolean logic.
4. **Exact logic can still be performed using only embeddings:** turn semantic concepts into predicates over embedding vectors, then use ordinary set/Boolean operations on those predicates.
5. **OpenCode itself is not an embedding model.** It is a model/provider frontend. If a model is being used through OpenCode, this algebra should call the underlying provider's embedding endpoint directly, or serve the desired model in embedding/pooling mode.
6. **This ChatGPT session does not expose GPT-5.6 Sol's private internal embedding vectors.** OpenAI exposes separate public embedding models such as `text-embedding-3-large` and `text-embedding-3-small`; those can be tested through the embeddings API when credentials are available.

---

# 1. Exact scope

Let an embedding provider implement

\[
E : \text{text} \rightarrow \mathbb{R}^d.
\]

For text `x`, write

\[
z_x = E(x).
\]

Nothing in the core system requires access to the model's internals.

The embedding can come from:

- a dedicated embedding model;
- a generative LLM exposed in pooling/embedding mode;
- a local model server;
- a cloud embedding API.

The only hard requirement is that **the same model, pooling rule, dimensions, normalization policy, and preprocessing are used for every vector participating in one algebraic space**.

Do not mix embeddings from different models or dimensionalities and then add/subtract them as if they shared coordinates.

The **text formatting contract is also part of the coordinate system**. If a model expects an instruction or prefix such as `query:`, use one frozen template consistently for every vector that participates in arithmetic or logic. Mixing differently instructed query/document representations can change the geometry even when the underlying model ID is identical.

---

# 2. What OpenCode means for this system

OpenCode is an agent that can connect to many LLM providers. It does not itself define one universal embedding space. Its current model documentation explicitly excludes embedding-only models from being used to drive an OpenCode session.

Therefore the architecture should be:

```text
OpenCode / application
        │
        ├── generation model, if desired
        │
        └── direct embedding endpoint
                 ↓
             this algebra
```

If the provider behind OpenCode exposes embeddings, call that provider directly.

For local models, current practical routes include:

```text
vLLM      → /v1/embeddings
LM Studio → /v1/embeddings
Ollama    → /api/embed
OpenAI    → /v1/embeddings
```

vLLM can run supported pooling models directly and can also attempt to convert compatible generative architectures to embedding mode. Its documentation notes that automatically converted generative models use a pooled representation and that models trained specifically for embeddings are normally preferable when retrieval quality is the objective.

This document therefore treats the embedding provider as a replaceable component.

---

# 3. Why GPT itself cannot be directly used as a private test oracle here

GPT-5.6 Sol is the model producing this document, but this ChatGPT interface does **not** expose an API that returns its internal hidden vectors to the assistant.

That means a claim such as:

> "I tested `king - man + woman` using my own private GPT-5.6 vectors"

would be false.

What can be tested here is:

- every numerical operation;
- provider request/response handling through mocked HTTP endpoints;
- exact Boolean laws;
- synthetic vectors whose correct arithmetic result is mathematically known;
- deterministic ranking and edge-case behavior.

A real semantic test against OpenAI embeddings requires calling the public embedding endpoint with credentials. OpenAI currently lists `text-embedding-3-large` and `text-embedding-3-small` as embedding models. OpenAI also documents that its embedding outputs are L2-normalized by default, including shortened v3 embeddings.

The supplied real-provider benchmark is therefore executable but intentionally does not fake a successful cloud call when no API key exists.

---

# 4. The key distinction: vector arithmetic versus logic

## 4.1 Arithmetic

Arithmetic transforms a point into another point:

\[
q = z_b - z_a + z_c.
\]

or

\[
r_R = \frac{1}{n}\sum_i(z_{y_i}-z_{x_i}),
\]

\[
q = z_x + r_R.
\]

The result is another numeric vector.

## 4.2 Logic

A Boolean proposition is not naturally a single point. It denotes a set of things for which the proposition is true.

So instead of pretending

```text
AND(a, b) = a + b
NOT(a)    = -a
```

we define an atomic semantic predicate from embeddings, for example

\[
P_A(x) = [\cos(z_x,z_A) \ge \tau_A].
\]

Then Boolean logic is ordinary logic:

\[
(P_A \land P_B)(x)=P_A(x)\land P_B(x),
\]

\[
(P_A \lor P_B)(x)=P_A(x)\lor P_B(x),
\]

\[
(\neg P_A)(x)=\neg P_A(x).
\]

This gives exact Boolean laws over the chosen candidate universe.

The semantics of the **atomic predicate** are approximate because they come from an embedding threshold. The Boolean composition after that is exact.

This separation is fundamental.

---

# 5. Human-readable conversion with embeddings only

A generic embedding function is not guaranteed to be injective, and embedding APIs do not expose a universal inverse

\[
E^{-1}:\mathbb{R}^d\rightarrow\text{text}.
\]

Therefore the fully embedding-only decoder is retrieval.

Create a finite human-readable universe

\[
U=\{s_1,\dots,s_N\}
\]

and precompute

\[
Z_U = \{E(s_1),\dots,E(s_N)\}.
\]

After arithmetic produces query vector `q`, return

\[
\hat s = \arg\max_{s_i\in U}\cos(q,E(s_i)).
\]

For top-k output:

\[
\operatorname{TopK}_{s_i\in U}\cos(q,E(s_i)).
\]

This is exactly how a vector is converted back to human-readable form **without introducing a second generative model**.

If the desired answer is not represented anywhere in `U`, an embedding-only system cannot invent its exact text. It can only return the nearest indexed strings.

A free-form text decoder would require a generator or embedding-inversion model and would therefore violate the strict "embeddings only" boundary.

---

# 6. Arithmetic mode A: direct analogy

For analogy

```text
a : b :: c : ?
```

calculate

\[
q=z_b-z_a+z_c.
\]

Then retrieve the closest candidate vector.

Classic example:

\[
q=z_{\text{woman}}-z_{\text{man}}+z_{\text{king}}.
\]

Nearest-neighbor lookup tests whether `queen` is close to this point.

This is a valid experiment on any same-space embeddings.

It is **not guaranteed** that a modern embedding model was trained to make this relation linear.

---

# 7. Arithmetic mode B: learn the relation from multiple pairs

A single pair is noisy. Prefer a relation estimated from training pairs:

\[
(x_1,y_1),\ldots,(x_n,y_n).
\]

Compute

\[
d_i=z_{y_i}-z_{x_i}
\]

and

\[
r_R=\frac{1}{n}\sum_i d_i.
\]

Apply it to unseen input `x`:

\[
q=z_x+r_R.
\]

Then retrieve the nearest candidate.

Example:

```text
TRAIN
man    → woman
prince → princess
uncle  → aunt

TEST
king   → ?
```

The test pair `king → queen` must not be used to construct the offset.

This average-offset method is generally a stronger test of a relation than one cherry-picked analogy.

---

## 7.1 General linear arithmetic

The engine also exposes a general linear combination

\[
q=\sum_i \alpha_i z_i.
\]

This covers ordinary addition, subtraction, weighted blends, and multi-term expressions without inventing a special function for each one.

```python
from embedding_algebra_core import linear_combination

vectors = space.encode(["king", "man", "woman"])
q = linear_combination(vectors, [1.0, -1.0, 1.0])
```

This is numerically equivalent to `king - man + woman` in the chosen embedding coordinate system.

### Relation composition warning

If two learned relations are represented only by additive offsets, composition is

\[
(z+r_1)+r_2=z+r_1+r_2=z+r_2+r_1.
\]

Therefore pure offset composition is commutative. It **cannot** represent relations whose order matters. If the intended transformations satisfy `R2(R1(x)) != R1(R2(x))`, a single additive-offset algebra is structurally insufficient. That is a limitation of the representation, not a coding bug.

# 8. Relation diagnostics

Before trusting an additive relation, inspect its difference vectors

\[
D=\begin{bmatrix}
d_1^T\\
\vdots\\
d_n^T
\end{bmatrix}.
\]

Useful diagnostics include:

- average cosine alignment of each `d_i` with the mean offset;
- average residual norm around the mean offset;
- standard deviation of offset magnitudes;
- uncentered singular-value spectrum;
- centered singular-value spectrum.

A relation is a good candidate for translation if difference vectors point in similar directions and have reasonably consistent magnitudes on held-out data.

If the residuals are large, do not force a one-vector explanation simply because one analogy worked.

---

# 9. Unit-normalized embedding outputs

Many modern embedding endpoints return approximately or exactly unit-normalized vectors.

That does **not** prevent subtraction or addition.

If

\[
\|z_x\|=1,
\]

then

\[
q=z_b-z_a+z_c
\]

will generally not have norm 1. That is fine.

For cosine retrieval, normalize `q` only when computing cosine similarity. Do not renormalize every intermediate subtraction unless that is an explicitly evaluated design choice.

OpenAI currently documents that its embedding API outputs are L2-normalized by default. Ollama currently documents that `/api/embed` returns L2-normalized vectors.

The implementation never assumes normalization; it computes cosine safely itself.

---

# 10. Optional geometric calibration

The safest baseline is raw embeddings:

```text
geometry = identity
```

Then compare against:

```text
geometry = center
geometry = whiten
```

## Centering

Given a frozen calibration corpus,

\[
\mu=\frac{1}{N}\sum_i z_i,
\]

use

\[
\tilde z=z-\mu.
\]

## Whitening

Fit SVD to centered calibration data and transform only the numerically nonzero subspace so that its sample covariance is identity.

Whitening is an **ablation**, not a promised improvement. It can improve geometry in some embedding settings and damage it in others.

Never fit a calibration transform on test answers and then call the evaluation fully held out.

For strict experiments, fit the transform once on a separate calibration corpus and freeze it.

---

# 11. Exact Boolean logic using embeddings

There are two useful atomic predicate forms.

## 11.1 Similarity predicate

For concept text `A`, compute center vector

\[
c_A=E(A).
\]

Define

\[
P_A(x)=[\cos(E(x),c_A)\ge\tau_A].
\]

This is useful when a text embedding itself is a good concept prototype.

## 11.2 Learned half-space predicate

When examples are available, use positive and negative embedding sets.

Let

\[
\mu_+=\operatorname{mean}(z_{+}),
\qquad
\mu_-=\operatorname{mean}(z_{-}).
\]

Define direction

\[
d=\frac{\mu_+-\mu_-}{\|\mu_+-\mu_-\|}.
\]

Then classify with

\[
P(x)=[z_x^Td\ge\tau].
\]

The supplied implementation chooses `τ` to maximize training balanced accuracy, with a deterministic tie rule.

A proper experiment chooses/fits the threshold on training or validation data and reports test performance separately.

---

# 12. Boolean composition

Once atoms are predicates, composition is exact:

## AND

\[
(A\land B)(x)=A(x)\land B(x)
\]

## OR

\[
(A\lor B)(x)=A(x)\lor B(x)
\]

## NOT

\[
(\neg A)(x)=\neg A(x)
\]

For the finite universe `U`, this is the same as:

\[
S_{A\land B}=S_A\cap S_B,
\]

\[
S_{A\lor B}=S_A\cup S_B,
\]

\[
S_{\neg A}=U\setminus S_A.
\]

Therefore the implementation satisfies, exactly:

\[
A\land B=B\land A,
\]

\[
A\lor B=B\lor A,
\]

\[
A\land A=A,
\]

\[
A\lor A=A,
\]

\[
\neg\neg A=A,
\]

\[
\neg(A\land B)=\neg A\lor\neg B,
\]

\[
\neg(A\lor B)=\neg A\land\neg B,
\]

\[
A\land\neg A=\varnothing,
\]

\[
A\lor\neg A=U.
\]

These laws are property-tested in the supplied test suite.

The implementation also provides exact derived operators:

```python
A.implies(B)     # ¬A ∨ B
A.xor(B)         # exclusive OR
A.equivalent(B)  # logical equivalence
A.nand(B)        # ¬(A ∧ B)
A.nor(B)         # ¬(A ∨ B)
```

and Boolean constants `TRUE` and `FALSE`. These are constructed from the primitive Boolean operators, so they inherit the same exact pointwise semantics.

---

# 13. Why `-embedding` is not semantic NOT

For a vector `z`, the vector

\[
-z
\]

is simply its antipode relative to the origin.

There is no general theorem that says

\[
E(\text{not X})=-E(\text{X}).
\]

Likewise,

\[
E(A)+E(B)
\]

is not guaranteed to represent either logical conjunction or disjunction.

Those shortcuts can be tested as heuristics, but they must not be called Boolean logic unless they satisfy the relevant truth conditions on a defined universe.

This is why the core implementation performs logic on predicates over embeddings rather than pretending raw vector arithmetic is propositional logic.

---

# 14. Fuzzy logic mode

Sometimes hard membership is too brittle.

Convert cosine similarity to a graded membership with

\[
m_A(x)=\sigma\left(\frac{\cos(z_x,c_A)-\tau}{T}\right),
\]

where `T > 0` controls softness.

The implementation uses min/max fuzzy logic:

\[
m_{A\land B}=\min(m_A,m_B),
\]

\[
m_{A\lor B}=\max(m_A,m_B),
\]

\[
m_{\neg A}=1-m_A,
\]

and Kleene-Dienes implication

\[
m_{A\to B}=\max(1-m_A,m_B).
\]

With min/max and standard negation, De Morgan's laws and double negation hold pointwise.

These memberships are **not automatically calibrated probabilities**. They are semantic scores unless calibrated against labeled data.

---

# 15. Combining arithmetic and logic

Arithmetic and logic can be composed without inventing invalid vector operators.

## Route A: arithmetic first, logic second

1. Produce arithmetic vector `q`.
2. Use it as a similarity center.
3. Intersect its candidate neighborhood with other predicates.

Example:

```text
near(king - man + woman)
AND royal-person
NOT fictional-character
```

## Route B: logic first, arithmetic second

1. Use Boolean predicates to restrict the candidate universe.
2. Rank only the surviving candidates by similarity to arithmetic query `q`.

The reference implementation performs this directly with:

```python
ranked = logic.rank(q, red & electric & (~large), top_k=10)
```

This is often cleaner because logic acts as an exact filter and arithmetic acts as a continuous ranker.

## Route C: summarize a logical result

The centroid

\[
c_S=\frac{1}{|S|}\sum_{x\in S}z_x
\]

can summarize a nonempty logical result set and can then be used in later arithmetic.

This centroid is a **lossy geometric summary**, not the logical set itself.

---

# 16. Recommended architecture

```text
                    ┌─────────────────────────┐
text ──────────────→│ EmbeddingProvider       │
                    │ same model/config only  │
                    └────────────┬────────────┘
                                 ↓
                         raw embedding z
                                 ↓
                    ┌─────────────────────────┐
                    │ frozen geometry         │
                    │ identity/center/whiten │
                    └────────────┬────────────┘
                                 ↓
                           algebra vector
                    ┌────────────┴─────────────┐
                    ↓                          ↓
             arithmetic engine          predicate engine
             b-a+c / offsets         similarity / halfspace
                    ↓                          ↓
               query vector              Boolean/fuzzy logic
                    └────────────┬─────────────┘
                                 ↓
                      human-readable universe
                                 ↓
                       nearest/ranked strings
```

This is the recommended core because it remains entirely embedding-based.

---

# 17. Provider setup

## 17.1 OpenAI

Current OpenAI embedding models include:

```text
text-embedding-3-large
text-embedding-3-small
```

Example environment:

```bash
export OPENAI_API_KEY="..."
```

Python:

```python
provider = OpenAICompatibleProvider(
    model="text-embedding-3-large",
    base_url="https://api.openai.com/v1",
    api_key=os.environ["OPENAI_API_KEY"],
)
```

The OpenAI embeddings API accepts batches of strings and supports the `dimensions` parameter for v3 embedding models.

## 17.2 vLLM

When a compatible embedding/pooling model is served locally:

```text
http://localhost:8000/v1/embeddings
```

use:

```python
provider = OpenAICompatibleProvider(
    model="MODEL_ID_REPORTED_BY_SERVER",
    base_url="http://localhost:8000/v1",
    api_key=None,
)
```

vLLM currently documents an OpenAI-compatible embeddings endpoint. It also documents pooling/embedding conversion for supported architectures. If a generative LLM is automatically converted to an embedding model, measure the resulting semantic arithmetic empirically; do not assume it will equal a dedicated embedding model.

## 17.3 LM Studio

LM Studio currently exposes an OpenAI-compatible `/v1/embeddings` endpoint.

```python
provider = OpenAICompatibleProvider(
    model="MODEL_ID_REPORTED_BY_LM_STUDIO",
    base_url="http://localhost:1234/v1",
    api_key=None,
)
```

## 17.4 Ollama

Ollama currently exposes:

```text
POST /api/embed
```

Example:

```python
provider = OllamaProvider(
    model="qwen3-embedding",
    base_url="http://localhost:11434",
)
```

Ollama's current documentation also lists `embeddinggemma`, `qwen3-embedding`, and `all-minilm` as recommended embedding models. For the intended LLM-derived setup, Qwen/Gemma-family embedding models are natural choices.

---

## 17.5 Freeze model-specific prefixes, roles, and instructions

Many modern embedding models are instruction-aware, and some distinguish **query** vectors from **document** vectors. For algebra, regard the complete embedding recipe as the coordinate-system identity:

```text
(model revision, dimensions, pooling, normalization, task/role, prefix, suffix)
```

Every operand in one arithmetic expression, every relation-training pair, every calibration item, and every candidate used to decode the result must use the **same recipe** unless a cross-role mapping has been explicitly learned and validated.

For Qwen3-Embedding, the official model card notes that queries benefit from a query prompt while documents are normally encoded without that prompt. Google embedding documentation likewise distinguishes symmetric and asymmetric task formats. Those asymmetries are useful for retrieval, but they are dangerous for coordinate-wise arithmetic. The safe default for this project is therefore a **symmetric algebra mode**: pick one semantically appropriate representation instruction and apply it identically to all texts participating in the algebra.

When the selected model requires one uniform prefix/template for that symmetric mode, wrap the provider once:

```python
from embedding_algebra_core import TemplateProvider

provider = TemplateProvider(
    provider,
    prefix="Represent this text for semantic algebra: ",
)
```

Use the model's documented instruction when one exists; the sentence above is only an example of the mechanism. Record the exact instruction in the experiment manifest.

If a model deliberately defines different query and document encoders/prefixes, treat those outputs as different representational roles even when their dimensions match. **Do not subtract, add, average, whiten together, or fit a relation across query-role and document-role vectors by default.** Either use one symmetric role for the whole algebra or explicitly learn a mapping between roles and validate it on held-out examples.

This restriction is fundamental: equal dimensionality does not imply equal coordinates.

# 18. Complete reference implementation

The following file is standalone except for NumPy.

Install:

```bash
python -m pip install "numpy>=2.0,<3"
```

Save as `embedding_algebra_core.py`:

```python
from __future__ import annotations

import json
import math
import numbers
import time
import urllib.error
import urllib.request
from dataclasses import dataclass
from typing import Protocol, Sequence

import numpy as np

Array = np.ndarray


class EmbeddingProvider(Protocol):
    """Minimal interface required by the algebra engine."""

    def embed(self, texts: Sequence[str]) -> Array:
        """Return shape (len(texts), dimension) finite float embeddings."""


def _validate_texts(texts: Sequence[str]) -> list[str]:
    if isinstance(texts, (str, bytes)):
        raise TypeError("texts must be a sequence of strings, not one string")
    out = list(texts)
    if not out:
        raise ValueError("texts must not be empty")
    for i, text in enumerate(out):
        if not isinstance(text, str):
            raise TypeError(f"texts[{i}] is not a string")
        if text == "":
            raise ValueError(f"texts[{i}] is empty")
    return out


def _validate_matrix(x: Array, *, rows: int | None = None, name: str = "matrix") -> Array:
    a = np.asarray(x, dtype=np.float64)
    if a.ndim != 2:
        raise ValueError(f"{name} must be 2-D, got shape {a.shape}")
    if rows is not None and a.shape[0] != rows:
        raise ValueError(f"{name} has {a.shape[0]} rows; expected {rows}")
    if a.shape[0] == 0 or a.shape[1] == 0:
        raise ValueError(f"{name} must have positive dimensions")
    if not np.isfinite(a).all():
        raise ValueError(f"{name} contains NaN or infinity")
    return a


def _validate_vector(x: Array, *, dim: int | None = None, name: str = "vector") -> Array:
    a = np.asarray(x, dtype=np.float64)
    if a.ndim != 1:
        raise ValueError(f"{name} must be 1-D, got shape {a.shape}")
    if dim is not None and a.shape[0] != dim:
        raise ValueError(f"{name} has dimension {a.shape[0]}; expected {dim}")
    if a.size == 0:
        raise ValueError(f"{name} must not be empty")
    if not np.isfinite(a).all():
        raise ValueError(f"{name} contains NaN or infinity")
    return a


def _readonly_vector(x: Array, *, dim: int | None = None, name: str = "vector") -> Array:
    """Validated float64 vector copied into immutable storage."""
    a = _validate_vector(x, dim=dim, name=name).copy()
    a.setflags(write=False)
    return a


def _readonly_matrix(x: Array, *, rows: int | None = None, name: str = "matrix") -> Array:
    """Validated float64 matrix copied into immutable storage."""
    a = _validate_matrix(x, rows=rows, name=name).copy()
    a.setflags(write=False)
    return a


def _require_int(value: object, *, name: str, minimum: int | None = None) -> int:
    if isinstance(value, bool) or not isinstance(value, numbers.Integral):
        raise TypeError(f"{name} must be an integer")
    out = int(value)
    if minimum is not None and out < minimum:
        raise ValueError(f"{name} must be >= {minimum}")
    return out


def _require_real(
    value: object,
    *,
    name: str,
    minimum: float | None = None,
    strict_minimum: bool = False,
) -> float:
    if isinstance(value, bool) or not isinstance(value, numbers.Real):
        raise TypeError(f"{name} must be a real number")
    out = float(value)
    if not math.isfinite(out):
        raise ValueError(f"{name} must be finite")
    if minimum is not None:
        if strict_minimum and not (out > minimum):
            raise ValueError(f"{name} must be > {minimum}")
        if not strict_minimum and out < minimum:
            raise ValueError(f"{name} must be >= {minimum}")
    return out


def _require_nonempty_string(value: object, *, name: str) -> str:
    if not isinstance(value, str):
        raise TypeError(f"{name} must be a string")
    if value == "":
        raise ValueError(f"{name} must not be empty")
    return value


def l2_normalize_vector(x: Array, *, eps: float = 1e-15) -> Array:
    eps = _require_real(eps, name="eps", minimum=0.0, strict_minimum=True)
    x = _validate_vector(x)
    norm = float(np.linalg.norm(x))
    if not math.isfinite(norm) or norm <= eps:
        raise ValueError("cannot normalize a zero or near-zero vector")
    return x / norm


def l2_normalize_rows(x: Array, *, eps: float = 1e-15) -> Array:
    eps = _require_real(eps, name="eps", minimum=0.0, strict_minimum=True)
    x = _validate_matrix(x)
    norms = np.linalg.norm(x, axis=1)
    if np.any(~np.isfinite(norms)) or np.any(norms <= eps):
        bad = np.flatnonzero((~np.isfinite(norms)) | (norms <= eps)).tolist()
        raise ValueError(f"cannot normalize zero/invalid rows at indices {bad}")
    return x / norms[:, None]


def cosine_scores(query: Array, candidates: Array) -> Array:
    candidates = _validate_matrix(candidates, name="candidates")
    query = _validate_vector(query, dim=candidates.shape[1], name="query")
    q = l2_normalize_vector(query)
    c = l2_normalize_rows(candidates)
    scores = c @ q
    # Numerical noise can exceed [-1, 1] by a few ulps.
    return np.clip(scores, -1.0, 1.0)


def _post_json(
    url: str,
    payload: dict,
    *,
    headers: dict[str, str] | None = None,
    timeout: float = 60.0,
    retries: int = 2,
    backoff_seconds: float = 0.5,
) -> dict:
    url = _require_nonempty_string(url, name="url")
    if not url.startswith(("http://", "https://")):
        raise ValueError("url must start with http:// or https://")
    timeout = _require_real(timeout, name="timeout", minimum=0.0, strict_minimum=True)
    retries = _require_int(retries, name="retries", minimum=0)
    backoff_seconds = _require_real(backoff_seconds, name="backoff_seconds", minimum=0.0)

    body = json.dumps(payload).encode("utf-8")
    request_headers = {"Content-Type": "application/json"}
    if headers:
        request_headers.update(headers)

    last_error: Exception | None = None
    retryable_status = {408, 409, 429, 500, 502, 503, 504}

    for attempt in range(retries + 1):
        req = urllib.request.Request(url, data=body, headers=request_headers, method="POST")
        try:
            with urllib.request.urlopen(req, timeout=timeout) as response:
                raw = response.read()
            parsed = json.loads(raw.decode("utf-8"))
            if not isinstance(parsed, dict):
                raise ValueError("JSON response must be an object")
            return parsed
        except urllib.error.HTTPError as exc:
            last_error = exc
            if exc.code not in retryable_status or attempt >= retries:
                try:
                    detail = exc.read().decode("utf-8", errors="replace")
                except Exception:
                    detail = ""
                raise RuntimeError(f"HTTP {exc.code} from {url}: {detail[:1000]}") from exc
        except (urllib.error.URLError, TimeoutError) as exc:
            last_error = exc
            if attempt >= retries:
                raise RuntimeError(f"request to {url} failed: {exc}") from exc
        except json.JSONDecodeError as exc:
            raise RuntimeError(f"invalid JSON response from {url}") from exc

        if backoff_seconds > 0:
            time.sleep(backoff_seconds * (2**attempt))

    raise RuntimeError(f"request failed: {last_error}")


@dataclass(frozen=True)
class OpenAICompatibleProvider:
    """Works with OpenAI and servers exposing POST /v1/embeddings."""

    model: str
    base_url: str = "https://api.openai.com/v1"
    api_key: str | None = None
    dimensions: int | None = None
    timeout: float = 60.0
    retries: int = 2

    def embed(self, texts: Sequence[str]) -> Array:
        clean = _validate_texts(texts)
        model = _require_nonempty_string(self.model, name="model")
        base_url = _require_nonempty_string(self.base_url, name="base_url")
        if self.api_key is not None and not isinstance(self.api_key, str):
            raise TypeError("api_key must be a string or None")
        dimensions = None if self.dimensions is None else _require_int(
            self.dimensions, name="dimensions", minimum=1
        )

        payload: dict[str, object] = {
            "model": model,
            "input": clean,
            "encoding_format": "float",
        }
        if dimensions is not None:
            payload["dimensions"] = dimensions

        headers: dict[str, str] = {}
        if self.api_key:
            headers["Authorization"] = f"Bearer {self.api_key}"

        data = _post_json(
            base_url.rstrip("/") + "/embeddings",
            payload,
            headers=headers,
            timeout=self.timeout,
            retries=self.retries,
        )

        entries = data.get("data")
        if not isinstance(entries, list) or len(entries) != len(clean):
            raise RuntimeError("embedding response has wrong number of data entries")

        by_index: dict[int, Array] = {}
        for entry in entries:
            if not isinstance(entry, dict) or "index" not in entry or "embedding" not in entry:
                raise RuntimeError("malformed embedding response entry")
            idx = entry["index"]
            if not isinstance(idx, int) or not (0 <= idx < len(clean)):
                raise RuntimeError(f"invalid embedding index {idx!r}")
            if idx in by_index:
                raise RuntimeError(f"duplicate embedding index {idx}")
            by_index[idx] = np.asarray(entry["embedding"], dtype=np.float64)

        if set(by_index) != set(range(len(clean))):
            raise RuntimeError("embedding response is missing one or more indices")

        matrix = np.stack([by_index[i] for i in range(len(clean))])
        return _validate_matrix(matrix, rows=len(clean), name="provider embeddings")


@dataclass(frozen=True)
class OllamaProvider:
    """Works with Ollama's documented POST /api/embed endpoint."""

    model: str
    base_url: str = "http://localhost:11434"
    api_key: str | None = None
    dimensions: int | None = None
    truncate: bool = False
    timeout: float = 60.0
    retries: int = 2

    def embed(self, texts: Sequence[str]) -> Array:
        clean = _validate_texts(texts)
        model = _require_nonempty_string(self.model, name="model")
        base_url = _require_nonempty_string(self.base_url, name="base_url")
        if self.api_key is not None and not isinstance(self.api_key, str):
            raise TypeError("api_key must be a string or None")
        if not isinstance(self.truncate, bool):
            raise TypeError("truncate must be a boolean")
        dimensions = None if self.dimensions is None else _require_int(
            self.dimensions, name="dimensions", minimum=1
        )

        payload: dict[str, object] = {
            "model": model,
            "input": clean,
            "truncate": self.truncate,
        }
        if dimensions is not None:
            payload["dimensions"] = dimensions

        headers: dict[str, str] = {}
        if self.api_key:
            headers["Authorization"] = f"Bearer {self.api_key}"

        data = _post_json(
            base_url.rstrip("/") + "/api/embed",
            payload,
            headers=headers,
            timeout=self.timeout,
            retries=self.retries,
        )
        embeddings = data.get("embeddings")
        matrix = np.asarray(embeddings, dtype=np.float64)
        return _validate_matrix(matrix, rows=len(clean), name="provider embeddings")


@dataclass(frozen=True)
class TemplateProvider:
    """Apply one frozen text template before every embedding call."""

    inner: EmbeddingProvider
    prefix: str = ""
    suffix: str = ""

    def embed(self, texts: Sequence[str]) -> Array:
        clean = _validate_texts(texts)
        if not isinstance(self.prefix, str) or not isinstance(self.suffix, str):
            raise TypeError("prefix and suffix must be strings")
        templated = [self.prefix + text + self.suffix for text in clean]
        return _validate_matrix(
            self.inner.embed(templated), rows=len(clean), name="templated embeddings"
        )


@dataclass(frozen=True)
class BatchedProvider:
    """Provider wrapper that enforces a maximum request batch size."""

    inner: EmbeddingProvider
    batch_size: int = 128

    def embed(self, texts: Sequence[str]) -> Array:
        clean = _validate_texts(texts)
        batch_size = _require_int(self.batch_size, name="batch_size", minimum=1)
        chunks: list[Array] = []
        for start in range(0, len(clean), batch_size):
            chunk_texts = clean[start : start + batch_size]
            chunk = _validate_matrix(
                self.inner.embed(chunk_texts), rows=len(chunk_texts), name="batch embeddings"
            )
            chunks.append(chunk)
        dims = {chunk.shape[1] for chunk in chunks}
        if len(dims) != 1:
            raise RuntimeError("provider returned inconsistent embedding dimensions across batches")
        return np.concatenate(chunks, axis=0)


@dataclass(frozen=True)
class LinearGeometry:
    """Frozen affine/linear geometry applied identically to every embedding."""

    mean: Array
    matrix: Array
    mode: str

    def __post_init__(self) -> None:
        mean = _readonly_vector(self.mean, name="geometry mean")
        matrix = _readonly_matrix(self.matrix, name="geometry matrix")
        if matrix.shape[0] != mean.size:
            raise ValueError("geometry matrix input dimension must match mean dimension")
        if self.mode not in {"identity", "center", "whiten"}:
            raise ValueError("invalid geometry mode")
        object.__setattr__(self, "mean", mean)
        object.__setattr__(self, "matrix", matrix)

    def apply(self, x: Array) -> Array:
        a = np.asarray(x, dtype=np.float64)
        one = a.ndim == 1
        if one:
            a = a[None, :]
        a = _validate_matrix(a, name="geometry input")
        mean = _validate_vector(self.mean, dim=a.shape[1], name="geometry mean")
        matrix = _validate_matrix(self.matrix, name="geometry matrix")
        if matrix.shape[0] != a.shape[1]:
            raise ValueError("geometry matrix input dimension does not match vectors")
        z = (a - mean[None, :]) @ matrix
        z = _validate_matrix(z, rows=a.shape[0], name="geometry output")
        return z[0] if one else z


def fit_geometry(
    reference_vectors: Array,
    *,
    mode: str = "identity",
    rank: int | None = None,
) -> LinearGeometry:
    x = _validate_matrix(reference_vectors, name="reference_vectors")
    n, d = x.shape
    mode = _require_nonempty_string(mode, name="mode").lower()
    if mode not in {"identity", "center", "whiten"}:
        raise ValueError("mode must be 'identity', 'center', or 'whiten'")

    if mode == "identity":
        if rank is not None:
            rank = _require_int(rank, name="rank", minimum=1)
        if rank is not None and rank != d:
            raise ValueError("identity geometry does not support dimensionality reduction")
        return LinearGeometry(np.zeros(d), np.eye(d), mode)

    mean = x.mean(axis=0)
    if mode == "center":
        if rank is not None:
            rank = _require_int(rank, name="rank", minimum=1)
        if rank is not None and rank != d:
            raise ValueError("center geometry does not support dimensionality reduction")
        return LinearGeometry(mean, np.eye(d), mode)

    # Whitening: Xc @ W has identity sample covariance on retained nonzero dimensions.
    if n < 2:
        raise ValueError("whitening requires at least two reference vectors")
    xc = x - mean
    _, singular_values, vt = np.linalg.svd(xc, full_matrices=False)
    if singular_values.size == 0 or singular_values[0] <= 0:
        raise ValueError("reference geometry is constant and cannot be whitened")
    tol = max(xc.shape) * np.finfo(np.float64).eps * singular_values[0]
    numerical_rank = int(np.sum(singular_values > tol))
    if numerical_rank == 0:
        raise ValueError("reference geometry has numerical rank zero")
    k = numerical_rank if rank is None else _require_int(rank, name="rank", minimum=1)
    if k > numerical_rank:
        raise ValueError(f"rank must be between 1 and numerical rank {numerical_rank}")
    scales = np.sqrt(n - 1.0) / singular_values[:k]
    matrix = vt[:k].T * scales[None, :]
    return LinearGeometry(mean, matrix, mode)


@dataclass
class AlgebraSpace:
    provider: EmbeddingProvider
    geometry: LinearGeometry

    @classmethod
    def fit(
        cls,
        provider: EmbeddingProvider,
        calibration_texts: Sequence[str],
        *,
        geometry_mode: str = "identity",
        rank: int | None = None,
    ) -> "AlgebraSpace":
        clean = _validate_texts(calibration_texts)
        raw = _validate_matrix(provider.embed(clean), rows=len(clean), name="calibration embeddings")
        geometry = fit_geometry(raw, mode=geometry_mode, rank=rank)
        return cls(provider=provider, geometry=geometry)

    def encode(self, texts: Sequence[str]) -> Array:
        clean = _validate_texts(texts)
        raw = _validate_matrix(self.provider.embed(clean), rows=len(clean), name="raw embeddings")
        return self.geometry.apply(raw)

    def encode_one(self, text: str) -> Array:
        return self.encode([text])[0]


@dataclass
class EmbeddingIndex:
    labels: tuple[str, ...]
    vectors: Array

    def __post_init__(self) -> None:
        if isinstance(self.labels, (str, bytes)):
            raise TypeError("labels must be a sequence of strings, not one string")
        self.labels = tuple(self.labels)
        if not self.labels:
            raise ValueError("labels must not be empty")
        if any(not isinstance(label, str) or label == "" for label in self.labels):
            raise ValueError("all labels must be non-empty strings")
        if len(set(self.labels)) != len(self.labels):
            raise ValueError("labels must be unique")
        self.vectors = _readonly_matrix(self.vectors, rows=len(self.labels), name="index vectors")

    @classmethod
    def from_space(cls, space: AlgebraSpace, labels: Sequence[str]) -> "EmbeddingIndex":
        clean = _validate_texts(labels)
        if len(set(clean)) != len(clean):
            raise ValueError("labels must be unique")
        return cls(tuple(clean), space.encode(clean))

    def nearest(
        self,
        query: Array,
        *,
        top_k: int = 10,
        exclude: Sequence[str] = (),
    ) -> list[tuple[str, float]]:
        top_k = _require_int(top_k, name="top_k", minimum=1)
        if isinstance(exclude, (str, bytes)):
            raise TypeError("exclude must be a sequence of labels, not one string")
        excluded = set(exclude)
        unknown = excluded.difference(self.labels)
        if unknown:
            raise ValueError(f"exclude contains unknown labels: {sorted(unknown)!r}")
        scores = cosine_scores(query, self.vectors)
        eligible = np.array([label not in excluded for label in self.labels], dtype=bool)
        ids = np.flatnonzero(eligible)
        if ids.size == 0:
            return []
        # stable sort: exact ties preserve frozen index order.
        order = np.argsort(-scores[ids], kind="stable")
        chosen = ids[order[: min(top_k, ids.size)]]
        return [(self.labels[i], float(scores[i])) for i in chosen]


def linear_combination(vectors: Array, weights: Sequence[float]) -> Array:
    """Return sum_i weights[i] * vectors[i]."""
    x = _validate_matrix(vectors, name="vectors")
    if isinstance(weights, (str, bytes)):
        raise TypeError("weights must be a numeric sequence, not a string")
    w = np.asarray(list(weights), dtype=np.float64)
    if w.ndim != 1 or w.size != x.shape[0]:
        raise ValueError("weights must be 1-D and match the number of vectors")
    if not np.isfinite(w).all():
        raise ValueError("weights contain NaN or infinity")
    result = w @ x
    return _validate_vector(result, dim=x.shape[1], name="linear combination")


def analogy_vector(a: Array, b: Array, c: Array) -> Array:
    a = _validate_vector(a, name="a")
    b = _validate_vector(b, dim=a.size, name="b")
    c = _validate_vector(c, dim=a.size, name="c")
    q = b - a + c
    if not np.isfinite(q).all():
        raise ValueError("analogy produced non-finite values")
    if np.linalg.norm(q) <= 1e-15:
        raise ValueError("analogy produced a zero/near-zero query vector")
    return q


def apply_offset(vector: Array, offset: Array, *, strength: float = 1.0) -> Array:
    """Apply a learned translation vector with a finite scalar strength."""
    vector = _validate_vector(vector, name="vector")
    offset = _validate_vector(offset, dim=vector.size, name="offset")
    strength = _require_real(strength, name="strength")
    result = vector + strength * offset
    return _validate_vector(result, dim=vector.size, name="offset result")


def evaluate_analogy_cases(
    space: AlgebraSpace,
    index: EmbeddingIndex,
    cases: Sequence[Sequence[str]],
    *,
    top_k: int = 5,
) -> dict[str, object]:
    """Evaluate 3CosAdd analogies a:b::c:d against a frozen candidate index."""
    top_k = _require_int(top_k, name="top_k", minimum=1)
    cases = list(cases)
    if not cases:
        raise ValueError("cases must not be empty")
    label_set = set(index.labels)
    rows: list[dict[str, object]] = []
    reciprocal_ranks: list[float] = []
    top1_hits = 0
    topk_hits = 0

    for i, case in enumerate(cases):
        if isinstance(case, (str, bytes)) or not isinstance(case, Sequence) or len(case) != 4:
            raise TypeError(f"cases[{i}] must be a four-item (a, b, c, d) sequence")
        if not all(isinstance(x, str) and x != "" for x in case):
            raise ValueError(f"cases[{i}] must contain non-empty strings")
        a, b, c, d = case
        if len({a, b, c}) != 3:
            raise ValueError(f"cases[{i}] must use three distinct query terms")
        if d in {a, b, c}:
            raise ValueError(f"cases[{i}] target must not be one of the excluded query terms")
        missing = {a, b, c, d}.difference(label_set)
        if missing:
            raise ValueError(f"cases[{i}] contains labels absent from index: {sorted(missing)!r}")

        za, zb, zc = space.encode([a, b, c])
        query = analogy_vector(za, zb, zc)
        ranked = index.nearest(query, top_k=len(index.labels), exclude=(a, b, c))
        rank = next((j + 1 for j, (label, _) in enumerate(ranked) if label == d), None)
        if rank is None:
            raise RuntimeError("target disappeared from candidate ranking")
        top1_hits += int(rank == 1)
        topk_hits += int(rank <= top_k)
        reciprocal_ranks.append(1.0 / rank)
        rows.append({
            "a": a, "b": b, "c": c, "target": d,
            "rank": rank,
            "predicted": ranked[0][0] if ranked else None,
            "top": ranked[:top_k],
        })

    n = len(rows)
    return {
        "count": n,
        "top1_accuracy": top1_hits / n,
        "topk": top_k,
        "topk_accuracy": topk_hits / n,
        "mrr": float(np.mean(reciprocal_ranks)),
        "rows": rows,
    }


def mean_relation_offset(source_vectors: Array, target_vectors: Array) -> Array:
    source = _validate_matrix(source_vectors, name="source_vectors")
    target = _validate_matrix(target_vectors, rows=source.shape[0], name="target_vectors")
    if target.shape[1] != source.shape[1]:
        raise ValueError("source and target dimensions differ")
    offset = np.mean(target - source, axis=0)
    if np.linalg.norm(offset) <= 1e-15:
        raise ValueError("learned relation offset is zero/near-zero")
    return offset


def fit_relation_from_text_pairs(space: AlgebraSpace, pairs: Sequence[tuple[str, str]]) -> Array:
    pairs = list(pairs)
    if not pairs:
        raise ValueError("pairs must not be empty")
    for i, pair in enumerate(pairs):
        if isinstance(pair, (str, bytes)) or not isinstance(pair, Sequence) or len(pair) != 2:
            raise TypeError(f"pairs[{i}] must be a two-item (source, target) sequence")
        if not all(isinstance(x, str) and x != "" for x in pair):
            raise ValueError(f"pairs[{i}] must contain non-empty strings")
    sources = space.encode([a for a, _ in pairs])
    targets = space.encode([b for _, b in pairs])
    return mean_relation_offset(sources, targets)


def relation_diagnostics(source_vectors: Array, target_vectors: Array) -> dict[str, object]:
    source = _validate_matrix(source_vectors, name="source_vectors")
    target = _validate_matrix(target_vectors, rows=source.shape[0], name="target_vectors")
    if target.shape[1] != source.shape[1]:
        raise ValueError("source and target dimensions differ")
    diffs = target - source
    mean = diffs.mean(axis=0)
    mean_norm = float(np.linalg.norm(mean))
    centered = diffs - mean
    s_uncentered = np.linalg.svd(diffs, compute_uv=False)
    s_centered = np.linalg.svd(centered, compute_uv=False)
    row_norms = np.linalg.norm(diffs, axis=1)

    if mean_norm <= 1e-15:
        mean_alignment = float("nan")
    else:
        valid = row_norms > 1e-15
        if np.any(valid):
            mean_alignment = float(
                np.mean((diffs[valid] @ mean) / (row_norms[valid] * mean_norm))
            )
        else:
            mean_alignment = float("nan")

    def explained_first(s: Array) -> float:
        power = s * s
        denom = float(np.sum(power))
        return float(power[0] / denom) if denom > 0 else float("nan")

    residual = np.linalg.norm(centered, axis=1)
    return {
        "mean_offset_norm": mean_norm,
        "mean_direction_alignment": mean_alignment,
        "mean_residual_norm": float(np.mean(residual)),
        "offset_norm_mean": float(np.mean(row_norms)),
        "offset_norm_std": float(np.std(row_norms)),
        "uncentered_rank1_variance_fraction": explained_first(s_uncentered),
        "centered_rank1_variance_fraction": explained_first(s_centered),
        "uncentered_singular_values": s_uncentered,
        "centered_singular_values": s_centered,
    }


# --------------------------
# Exact Boolean logic over embedding predicates
# --------------------------

class Predicate:
    def evaluate(self, vectors: Array) -> Array:
        raise NotImplementedError

    def __and__(self, other: "Predicate") -> "Predicate":
        if not isinstance(other, Predicate):
            return NotImplemented
        return AndPredicate(self, other)

    def __or__(self, other: "Predicate") -> "Predicate":
        if not isinstance(other, Predicate):
            return NotImplemented
        return OrPredicate(self, other)

    def __invert__(self) -> "Predicate":
        return NotPredicate(self)

    def implies(self, other: "Predicate") -> "Predicate":
        if not isinstance(other, Predicate):
            raise TypeError("other must be a Predicate")
        return (~self) | other

    def xor(self, other: "Predicate") -> "Predicate":
        if not isinstance(other, Predicate):
            raise TypeError("other must be a Predicate")
        return (self | other) & (~(self & other))

    def equivalent(self, other: "Predicate") -> "Predicate":
        if not isinstance(other, Predicate):
            raise TypeError("other must be a Predicate")
        return ~(self.xor(other))

    def nand(self, other: "Predicate") -> "Predicate":
        if not isinstance(other, Predicate):
            raise TypeError("other must be a Predicate")
        return ~(self & other)

    def nor(self, other: "Predicate") -> "Predicate":
        if not isinstance(other, Predicate):
            raise TypeError("other must be a Predicate")
        return ~(self | other)


@dataclass(frozen=True)
class ConstantPredicate(Predicate):
    value: bool

    def __post_init__(self) -> None:
        if not isinstance(self.value, (bool, np.bool_)):
            raise TypeError("constant predicate value must be boolean")
        object.__setattr__(self, "value", bool(self.value))

    def evaluate(self, vectors: Array) -> Array:
        x = _validate_matrix(vectors, name="vectors")
        return np.full(x.shape[0], bool(self.value), dtype=bool)


TRUE = ConstantPredicate(True)
FALSE = ConstantPredicate(False)


@dataclass(frozen=True)
class SimilarityPredicate(Predicate):
    center: Array
    threshold: float

    def __post_init__(self) -> None:
        center = _readonly_vector(self.center, name="center")
        object.__setattr__(self, "center", center)
        if isinstance(self.threshold, bool) or not isinstance(self.threshold, numbers.Real):
            raise TypeError("cosine threshold must be a real number")
        threshold = float(self.threshold)
        if not math.isfinite(threshold) or not (-1.0 <= threshold <= 1.0):
            raise ValueError("cosine threshold must lie in [-1, 1]")
        object.__setattr__(self, "threshold", threshold)

    def evaluate(self, vectors: Array) -> Array:
        return cosine_scores(self.center, vectors) >= self.threshold


@dataclass(frozen=True)
class HalfspacePredicate(Predicate):
    direction: Array
    threshold: float

    def __post_init__(self) -> None:
        direction = l2_normalize_vector(self.direction).copy()
        direction.setflags(write=False)
        object.__setattr__(self, "direction", direction)
        if isinstance(self.threshold, bool) or not isinstance(self.threshold, numbers.Real):
            raise TypeError("halfspace threshold must be a real number")
        threshold = float(self.threshold)
        if not math.isfinite(threshold):
            raise ValueError("halfspace threshold must be finite")
        object.__setattr__(self, "threshold", threshold)

    def evaluate(self, vectors: Array) -> Array:
        x = _validate_matrix(vectors, name="vectors")
        if x.shape[1] != self.direction.size:
            raise ValueError("vector dimension does not match halfspace direction")
        return (x @ self.direction) >= self.threshold


def _validated_predicate_mask(predicate: Predicate, vectors: Array, *, name: str) -> Array:
    if not isinstance(predicate, Predicate):
        raise TypeError(f"{name} must be a Predicate")
    x = _validate_matrix(vectors, name="vectors")
    mask = np.asarray(predicate.evaluate(x))
    if mask.dtype != np.bool_:
        raise TypeError(f"{name} returned a non-boolean mask")
    if mask.shape != (x.shape[0],):
        raise ValueError(f"{name} returned mask shape {mask.shape}; expected {(x.shape[0],)}")
    return mask


@dataclass(frozen=True)
class AndPredicate(Predicate):
    left: Predicate
    right: Predicate

    def __post_init__(self) -> None:
        if not isinstance(self.left, Predicate) or not isinstance(self.right, Predicate):
            raise TypeError("left and right must be Predicate instances")

    def evaluate(self, vectors: Array) -> Array:
        x = _validate_matrix(vectors, name="vectors")
        left = _validated_predicate_mask(self.left, x, name="left predicate")
        right = _validated_predicate_mask(self.right, x, name="right predicate")
        return np.logical_and(left, right)


@dataclass(frozen=True)
class OrPredicate(Predicate):
    left: Predicate
    right: Predicate

    def __post_init__(self) -> None:
        if not isinstance(self.left, Predicate) or not isinstance(self.right, Predicate):
            raise TypeError("left and right must be Predicate instances")

    def evaluate(self, vectors: Array) -> Array:
        x = _validate_matrix(vectors, name="vectors")
        left = _validated_predicate_mask(self.left, x, name="left predicate")
        right = _validated_predicate_mask(self.right, x, name="right predicate")
        return np.logical_or(left, right)


@dataclass(frozen=True)
class NotPredicate(Predicate):
    inner: Predicate

    def __post_init__(self) -> None:
        if not isinstance(self.inner, Predicate):
            raise TypeError("inner must be a Predicate instance")

    def evaluate(self, vectors: Array) -> Array:
        x = _validate_matrix(vectors, name="vectors")
        inner = _validated_predicate_mask(self.inner, x, name="inner predicate")
        return np.logical_not(inner)


def _best_balanced_threshold(scores: Array, labels: Array) -> tuple[float, float]:
    scores = _validate_vector(scores, name="scores")
    y = np.asarray(labels, dtype=bool)
    if y.ndim != 1 or y.size != scores.size:
        raise ValueError("labels must be a 1-D boolean array matching scores")
    if not np.any(y) or np.all(y):
        raise ValueError("threshold fitting requires both positive and negative examples")

    unique = np.unique(scores)
    candidates: list[float] = []
    # Include thresholds just outside the observed range and all adjacent midpoints.
    below = float(np.nextafter(unique[0], -np.inf))
    above = float(np.nextafter(unique[-1], np.inf))
    candidates.append(below if math.isfinite(below) else float(unique[0]))
    candidates.extend(float(a + (b - a) / 2.0) for a, b in zip(unique[:-1], unique[1:]))
    candidates.append(above if math.isfinite(above) else float(unique[-1]))

    best_threshold = candidates[0]
    best_score = -1.0
    # Stable tie policy: lower threshold wins because candidates are ascending.
    for threshold in candidates:
        pred = scores >= threshold
        tpr = float(np.mean(pred[y]))
        tnr = float(np.mean(~pred[~y]))
        bal = 0.5 * (tpr + tnr)
        if bal > best_score + 1e-15:
            best_score = bal
            best_threshold = threshold
    return best_threshold, best_score


def fit_similarity_predicate(
    center: Array,
    positive_vectors: Array,
    negative_vectors: Array,
) -> tuple[SimilarityPredicate, dict[str, float]]:
    """Fit a cosine threshold for one semantic atom from labeled calibration vectors."""
    pos = _validate_matrix(positive_vectors, name="positive_vectors")
    neg = _validate_matrix(negative_vectors, name="negative_vectors")
    if pos.shape[1] != neg.shape[1]:
        raise ValueError("positive and negative dimensions differ")
    center = _validate_vector(center, dim=pos.shape[1], name="center")
    all_vectors = np.concatenate([pos, neg], axis=0)
    scores = cosine_scores(center, all_vectors)
    labels = np.concatenate([np.ones(len(pos), dtype=bool), np.zeros(len(neg), dtype=bool)])

    # Cosine thresholds must stay inside [-1, 1]. Midpoints plus exact bounds
    # are sufficient to represent every distinct classification achievable by >=.
    unique = np.unique(scores)
    candidates = [-1.0]
    candidates.extend(float(a + (b - a) / 2.0) for a, b in zip(unique[:-1], unique[1:]))
    candidates.append(1.0)

    best_threshold = candidates[0]
    best_score = -1.0
    for threshold in candidates:
        pred_values = scores >= threshold
        tpr = float(np.mean(pred_values[labels]))
        tnr = float(np.mean(~pred_values[~labels]))
        balanced = 0.5 * (tpr + tnr)
        if balanced > best_score + 1e-15:
            best_score = balanced
            best_threshold = threshold

    pred = SimilarityPredicate(center=center, threshold=best_threshold)
    return pred, {
        "train_balanced_accuracy": best_score,
        "threshold": best_threshold,
        "positive_cosine_mean": float(np.mean(scores[labels])),
        "negative_cosine_mean": float(np.mean(scores[~labels])),
    }


def fit_halfspace_predicate(positive_vectors: Array, negative_vectors: Array) -> tuple[HalfspacePredicate, dict[str, float]]:
    pos = _validate_matrix(positive_vectors, name="positive_vectors")
    neg = _validate_matrix(negative_vectors, name="negative_vectors")
    if pos.shape[1] != neg.shape[1]:
        raise ValueError("positive and negative dimensions differ")
    direction_raw = pos.mean(axis=0) - neg.mean(axis=0)
    direction = l2_normalize_vector(direction_raw)
    all_vectors = np.concatenate([pos, neg], axis=0)
    scores = all_vectors @ direction
    labels = np.concatenate([np.ones(len(pos), dtype=bool), np.zeros(len(neg), dtype=bool)])
    threshold, balanced_accuracy = _best_balanced_threshold(scores, labels)
    pred = HalfspacePredicate(direction=direction, threshold=threshold)
    return pred, {
        "train_balanced_accuracy": balanced_accuracy,
        "threshold": threshold,
        "positive_projection_mean": float(np.mean(pos @ direction)),
        "negative_projection_mean": float(np.mean(neg @ direction)),
    }


@dataclass
class LogicIndex:
    index: EmbeddingIndex

    def __post_init__(self) -> None:
        if not isinstance(self.index, EmbeddingIndex):
            raise TypeError("index must be an EmbeddingIndex")

    def select(self, predicate: Predicate) -> list[str]:
        mask = self.select_mask(predicate)
        return [label for label, keep in zip(self.index.labels, mask) if keep]

    def select_mask(self, predicate: Predicate) -> Array:
        return _validated_predicate_mask(predicate, self.index.vectors, name="predicate")

    def centroid(self, predicate: Predicate) -> Array:
        mask = self.select_mask(predicate)
        if not np.any(mask):
            raise ValueError("cannot form centroid of an empty logical result")
        return np.mean(self.index.vectors[mask], axis=0)

    def rank(
        self,
        query: Array,
        predicate: Predicate,
        *,
        top_k: int = 10,
    ) -> list[tuple[str, float]]:
        """Apply exact logic as a filter, then rank survivors by cosine to query."""
        top_k = _require_int(top_k, name="top_k", minimum=1)
        mask = self.select_mask(predicate)
        ids = np.flatnonzero(mask)
        if ids.size == 0:
            return []
        scores = cosine_scores(query, self.index.vectors)
        order = np.argsort(-scores[ids], kind="stable")
        chosen = ids[order[: min(top_k, ids.size)]]
        return [(self.index.labels[i], float(scores[i])) for i in chosen]


# --------------------------
# Fuzzy logic over embedding-derived memberships
# --------------------------

@dataclass(frozen=True)
class FuzzySet:
    membership: Array

    def __post_init__(self) -> None:
        m = _validate_vector(self.membership, name="membership")
        if np.any(m < 0.0) or np.any(m > 1.0):
            raise ValueError("fuzzy membership must lie in [0, 1]")
        m = m.copy()
        m.setflags(write=False)
        object.__setattr__(self, "membership", m)

    def __and__(self, other: "FuzzySet") -> "FuzzySet":
        self._same_shape(other)
        return FuzzySet(np.minimum(self.membership, other.membership))

    def __or__(self, other: "FuzzySet") -> "FuzzySet":
        self._same_shape(other)
        return FuzzySet(np.maximum(self.membership, other.membership))

    def __invert__(self) -> "FuzzySet":
        return FuzzySet(1.0 - self.membership)

    def implies(self, other: "FuzzySet") -> "FuzzySet":
        """Kleene-Dienes implication: max(1-a, b)."""
        self._same_shape(other)
        return FuzzySet(np.maximum(1.0 - self.membership, other.membership))

    def _same_shape(self, other: "FuzzySet") -> None:
        if not isinstance(other, FuzzySet):
            raise TypeError("other must be a FuzzySet")
        if self.membership.shape != other.membership.shape:
            raise ValueError("fuzzy sets have different universes")


def fuzzy_similarity_membership(
    center: Array,
    candidates: Array,
    *,
    threshold: float = 0.5,
    temperature: float = 0.1,
) -> FuzzySet:
    threshold = _require_real(threshold, name="threshold")
    if not (-1.0 <= threshold <= 1.0):
        raise ValueError("threshold must lie in [-1, 1]")
    temperature = _require_real(temperature, name="temperature", minimum=0.0, strict_minimum=True)
    scores = cosine_scores(center, candidates)
    logits = np.clip((scores - threshold) / temperature, -60.0, 60.0)
    membership = 1.0 / (1.0 + np.exp(-logits))
    return FuzzySet(membership)


def rank_fuzzy(index: EmbeddingIndex, fuzzy: FuzzySet, *, top_k: int = 10) -> list[tuple[str, float]]:
    if fuzzy.membership.size != len(index.labels):
        raise ValueError("fuzzy set universe does not match index")
    top_k = _require_int(top_k, name="top_k", minimum=1)
    order = np.argsort(-fuzzy.membership, kind="stable")[: min(top_k, len(index.labels))]
    return [(index.labels[i], float(fuzzy.membership[i])) for i in order]


# --------------------------
# Optional real-provider smoke test helper
# --------------------------

def provider_smoke_test(provider: EmbeddingProvider) -> dict[str, object]:
    texts = ["king", "queen", "man", "woman"]
    x = _validate_matrix(provider.embed(texts), rows=4, name="smoke embeddings")
    norms = np.linalg.norm(x, axis=1)
    return {
        "rows": int(x.shape[0]),
        "dimension": int(x.shape[1]),
        "finite": bool(np.isfinite(x).all()),
        "norm_min": float(norms.min()),
        "norm_max": float(norms.max()),
        "cosine_king_queen": float(cosine_scores(x[0], x[[1]])[0]),
        "cosine_man_woman": float(cosine_scores(x[2], x[[3]])[0]),
    }


# --------------------------
# Deterministic mock provider for unit tests
# --------------------------

@dataclass(frozen=True)
class DictProvider:
    mapping: dict[str, Sequence[float]]

    def embed(self, texts: Sequence[str]) -> Array:
        clean = _validate_texts(texts)
        missing = [text for text in clean if text not in self.mapping]
        if missing:
            raise KeyError(f"missing embeddings for {missing!r}")
        return _validate_matrix(
            np.stack([np.asarray(self.mapping[text], dtype=np.float64) for text in clean]),
            rows=len(clean),
            name="dict embeddings",
        )


if __name__ == "__main__":
    # Exact synthetic analogy: king - man + woman == queen.
    mapping = {
        "man": [1.0, 0.0, 0.0],
        "woman": [1.0, 1.0, 0.0],
        "king": [2.0, 0.0, 1.0],
        "queen": [2.0, 1.0, 1.0],
        "prince": [1.8, 0.0, 0.8],
        "princess": [1.8, 1.0, 0.8],
    }
    provider = DictProvider(mapping)
    space = AlgebraSpace.fit(provider, list(mapping), geometry_mode="identity")
    index = EmbeddingIndex.from_space(space, list(mapping))
    q = analogy_vector(space.encode_one("man"), space.encode_one("woman"), space.encode_one("king"))
    result = index.nearest(q, top_k=1, exclude=("man", "woman", "king"))
    assert result[0][0] == "queen", result

    relation = fit_relation_from_text_pairs(space, [("man", "woman"), ("prince", "princess")])
    transformed_king = space.encode_one("king") + relation
    result2 = index.nearest(transformed_king, top_k=1, exclude=("king",))
    assert result2[0][0] == "queen", result2

    # Exact Boolean logic laws over embedding predicates.
    x = index.vectors
    A = HalfspacePredicate(np.array([1.0, 0.0, 0.0]), threshold=1.5)
    B = HalfspacePredicate(np.array([0.0, 1.0, 0.0]), threshold=0.5)
    assert np.array_equal((A & B).evaluate(x), (B & A).evaluate(x))
    assert np.array_equal((~(A & B)).evaluate(x), ((~A) | (~B)).evaluate(x))
    assert np.array_equal((~(A | B)).evaluate(x), ((~A) & (~B)).evaluate(x))
    assert np.array_equal((~~A).evaluate(x), A.evaluate(x))

    # Fuzzy min/max + standard negation obey De Morgan pointwise.
    fa = FuzzySet(np.array([0.1, 0.4, 0.9]))
    fb = FuzzySet(np.array([0.8, 0.4, 0.2]))
    assert np.allclose((~(fa & fb)).membership, ((~fa) | (~fb)).membership)
    assert np.allclose((~(fa | fb)).membership, ((~fa) & (~fb)).membership)
    assert np.allclose((~~fa).membership, fa.membership)

    print("embedding_algebra_core self-test: PASS")
```

---

# 19. Minimal arithmetic example

```python
import os
from embedding_algebra_core import (
    AlgebraSpace,
    EmbeddingIndex,
    OpenAICompatibleProvider,
    analogy_vector,
)

provider = OpenAICompatibleProvider(
    model="text-embedding-3-large",
    base_url="https://api.openai.com/v1",
    api_key=os.environ["OPENAI_API_KEY"],
)

candidates = [
    "king", "queen", "man", "woman",
    "prince", "princess", "monarch", "empress",
    "father", "mother", "boy", "girl",
]

# Identity is the correct first baseline.
space = AlgebraSpace.fit(
    provider,
    calibration_texts=candidates,
    geometry_mode="identity",
)

index = EmbeddingIndex.from_space(space, candidates)

q = analogy_vector(
    space.encode_one("man"),
    space.encode_one("woman"),
    space.encode_one("king"),
)

for text, score in index.nearest(
    q,
    top_k=5,
    exclude=("man", "woman", "king"),
):
    print(f"{score: .6f}  {text}")
```

This code does **not** assert that the top answer must be `queen`. That is the empirical question being measured.

---

# 20. Learned relation example

```python
from embedding_algebra_core import fit_relation_from_text_pairs

train_pairs = [
    ("man", "woman"),
    ("prince", "princess"),
    ("uncle", "aunt"),
]

r_gender = fit_relation_from_text_pairs(space, train_pairs)

query = space.encode_one("king") + r_gender

print(
    index.nearest(
        query,
        top_k=5,
        exclude=("king",),
    )
)
```

For a proper test, `king → queen` must remain absent from relation fitting and hyperparameter selection.

---

# 21. Exact logic example

Suppose the universe is a set of human-readable descriptions:

```python
from embedding_algebra_core import (
    EmbeddingIndex,
    HalfspacePredicate,
    LogicIndex,
    fit_halfspace_predicate,
)

items = [
    "small red electric car",
    "large red electric truck",
    "small blue electric car",
    "small red gasoline car",
    "large blue gasoline truck",
]

index = EmbeddingIndex.from_space(space, items)
logic = LogicIndex(index)
```

For production, fit predicates from labeled train examples. Conceptually:

```python
positive_red = space.encode([
    "a red object",
    "bright red color",
    "crimson red item",
])
negative_red = space.encode([
    "a blue object",
    "a green object",
    "a yellow object",
])

red, red_info = fit_halfspace_predicate(
    positive_red,
    negative_red,
)
```

Repeat for `electric` and `large`.

Then:

```python
query = red & electric & (~large)
answers = logic.select(query)
```

The final `AND` and `NOT` are exact Boolean operations on every candidate embedding. The quality limitation lies in how accurately the learned atomic predicates classify `red`, `electric`, and `large`.

---

# 22. Similarity logic with calibrated thresholds

For production use, do not copy an arbitrary cosine threshold such as `0.55` from another model. Fit the threshold from labeled calibration examples in the **same frozen embedding space**:

```python
from embedding_algebra_core import fit_similarity_predicate

red_center = space.encode_one("red")
positive_red = space.encode([
    "a red object",
    "bright crimson fabric",
    "a scarlet surface",
])
negative_red = space.encode([
    "a blue object",
    "green fabric",
    "a yellow surface",
])

red, red_info = fit_similarity_predicate(
    red_center,
    positive_red,
    negative_red,
)

answers = logic.select(red)
print(red_info)
```

`fit_similarity_predicate()` chooses the cosine threshold that maximizes balanced accuracy on the calibration examples, with a deterministic tie policy. The threshold must then be evaluated on held-out examples.

If labeled examples do not exist, a manually chosen threshold is an **exploratory definition**, not a calibrated semantic fact. Report it as such.

---

# 23. Fuzzy logic example

Fuzzy logic uses graded memberships in `[0,1]`. Calibrate each concept threshold first, then reuse that threshold in the smooth membership function:

```python
from embedding_algebra_core import (
    fit_similarity_predicate,
    fuzzy_similarity_membership,
    rank_fuzzy,
)

def calibrate_atom(name, positive_texts, negative_texts):
    pred, info = fit_similarity_predicate(
        space.encode_one(name),
        space.encode(positive_texts),
        space.encode(negative_texts),
    )
    return pred, info

red_pred, red_info = calibrate_atom(
    "red",
    ["red paint", "crimson cloth", "scarlet object"],
    ["blue paint", "green cloth", "yellow object"],
)
electric_pred, electric_info = calibrate_atom(
    "electric",
    ["electric motor", "battery powered device", "electrical appliance"],
    ["manual tool", "unpowered object", "mechanical hand tool"],
)

red = fuzzy_similarity_membership(
    space.encode_one("red"),
    index.vectors,
    threshold=red_info["threshold"],
    temperature=0.05,
)
electric = fuzzy_similarity_membership(
    space.encode_one("electric"),
    index.vectors,
    threshold=electric_info["threshold"],
    temperature=0.05,
)

red_and_electric = red & electric
print(rank_fuzzy(index, red_and_electric, top_k=5))
```

The `temperature` controls softness around the calibrated boundary; it is a model/application hyperparameter and should be validated rather than copied blindly.

---

# 24. Strict Boolean logic versus fuzzy logic

Use **hard predicates + Boolean operators** when the requirement is actual Boolean algebra over a finite semantic universe.

Use **fuzzy membership** when the application needs graded semantic matching.

Do not call fuzzy memberships literal truth probabilities unless they have been calibrated as probabilities.

---

# 25. A stronger concept representation: multiple half-spaces

A concept need not be one direction.

For attributes `A1`, `A2`, ..., define a region

\[
C(x)=A_1(x)\land A_2(x)\land\cdots.
\]

This means a concept can be represented by the intersection of several learned half-spaces.

That is substantially more expressive than trying to compress every concept into one point.

Recent work on lattice geometry in LLM representations similarly studies concepts as regions induced by attribute directions and thresholds, with meet/join operations related to intersection/generalization. That work should be treated as evidence for the geometric direction, not as proof that every external embedding API already has perfect Boolean geometry.

---

# 26. Negation, domain, and the human-readable universe

Boolean negation is always relative to a **domain of discourse**. The predicate engine itself can define a mathematical complement directly:

\[
(
eg P)(z)=
eg P(z).
\]

For a half-space or similarity predicate, that complement can be evaluated on any compatible embedding vector; it is not intrinsically limited to the vectors already stored in an index.

However, to **enumerate the result as human-readable text**, the system needs a declared candidate universe

\[
U=\{s_1,\ldots,s_N\}.
\]

The returned finite complement is then

\[

eg A = U\setminus A.
\]

So two statements must be kept separate:

1. predicate negation is an exact Boolean operation on the chosen embedding domain;
2. human-readable enumeration of `NOT A` is exact only relative to the indexed universe `U`.

Without such an index, "all human-readable things that are not A" cannot be exhaustively returned by an embeddings-only system. This is also why a lone `-z_A` is not universal semantic negation.

---

# 27. Logical OR should not be forced into one point

If `A` and `B` are semantically distant, their union can be disconnected.

For example:

```text
cats OR database servers
```

A single centroid might land near something that is neither a cat nor a database server.

The exact representation of the disjunction in this system is therefore the predicate

\[
A(x)\lor B(x),
\]

or the resulting union of candidate sets.

This agrees with a broader lesson from logical embedding research: sets, boxes, mixtures, distributions, or expression trees are often needed because a single point is an inadequate representation of arbitrary logical answer sets.

---

# 28. Logic result back to arithmetic

When a later step really requires one vector, summarize a nonempty logical result set:

```python
summary_vector = logic.centroid(red & electric & (~large))
```

Then use it in arithmetic.

But preserve the original logical result set as the authoritative representation. The centroid is a lossy convenience representation.

---

# 29. Model comparison protocol

For each provider/model, keep exactly the same:

- candidate universe;
- train/validation/test split;
- relation pairs;
- predicate labels;
- thresholds or threshold-selection procedure;
- geometry mode;
- retrieval metric;
- exclusion rules;
- random seed where randomness exists.

Then compare:

```text
OpenAI embedding model
Qwen/Gemma embedding model
same generative LLM converted to pooling mode
other provider embeddings
```

Do not compare vectors directly across spaces. Compare task metrics.

---

# 30. Arithmetic evaluation

At minimum report:

## Top-1 accuracy

\[
\frac{\#\text{correct first results}}{N}
\]

## Top-k accuracy

Whether the target appears in the first `k` retrieved entries.

## Mean reciprocal rank

\[
MRR=\frac1N\sum_i\frac1{\operatorname{rank}_i}.
\]

## Relation alignment

Average cosine between pair offsets and the mean relation vector.

## Relation residual

Average

\[
\|d_i-r_R\|.
\]

Always evaluate on held-out relation instances.

---

# 31. Logic evaluation

Atomic predicates should be evaluated independently from Boolean composition.

For each atom report:

- precision;
- recall;
- F1;
- balanced accuracy;
- ROC-AUC when appropriate.

For composite Boolean queries report exact answer-set metrics:

- set precision;
- set recall;
- set F1;
- exact-set match rate;
- Jaccard similarity.

This separates failures in semantic predicate induction from failures in logic. The Boolean engine itself should satisfy Boolean laws exactly regardless of semantic classification quality.

---

# 32. Leakage rules

For a serious experiment:

1. Never use a test target to fit its relation offset.
2. Never tune thresholds on the test set.
3. Never fit a learned half-space using test labels.
4. Fit centering/whitening on a frozen calibration/train corpus.
5. Freeze candidate ordering before evaluation so ties are deterministic.
6. Do not remove "difficult" candidates after seeing test errors.
7. Report the candidate universe, because nearest-neighbor accuracy depends strongly on it.
8. Preserve raw result rankings for auditability.

---

# 33. Controls that prevent false discoveries

Every claimed arithmetic relation should be compared against:

- random relation vectors with matched norm;
- shuffled source-target pairings;
- no-arithmetic nearest-neighbor baseline;
- identity geometry versus centered/whitened geometry;
- relation learned without the test pair;
- different candidate-universe sizes.

Every claimed logical predicate should be compared against:

- majority baseline;
- random direction;
- shuffled labels;
- direct similarity prototype versus learned half-space;
- held-out labels.

If the real relation does not outperform these controls, do not claim meaningful embedding algebra.

---

# 34. Numerical rules

The implementation enforces:

- finite vectors only;
- positive dimensions;
- no zero-vector cosine queries;
- no zero-norm candidate rows for cosine similarity;
- identical dimensions throughout one space;
- numerically valid whitening rank only;
- stable tie ordering;
- explicit complement universe;
- empty logical-set detection before centroid creation;
- explicit HTTP error handling;
- response-index validation for OpenAI-compatible providers.

These are not cosmetic checks. Silent handling of these cases can produce plausible-looking but invalid answers.

---

# 35. Reproducibility manifest

Record at least:

```yaml
embedding_provider: openai-compatible | ollama | custom
provider_base_url: ...
model_id: ...
model_revision: ...          # when provider exposes one
dimensions: ...
provider_normalization: ...
input_prefix_or_template: ...
geometry: identity | center | whiten
geometry_calibration_hash: ...
whitening_rank: ...
candidate_universe_hash: ...
relation_training_hash: ...
logic_training_hash: ...
threshold_policy: ...
similarity: cosine
ranking_tie_policy: frozen-index-order
numpy_version: ...
python_version: ...
```

If the provider aliases a moving model version, record date/time and any provider version metadata available.

---

# 36. Complete automated test suite

Save as `test_embedding_algebra_core.py` beside the core file:

```python
from __future__ import annotations

import json
import threading
from http.server import BaseHTTPRequestHandler, HTTPServer

import numpy as np

from embedding_algebra_core import (
    AlgebraSpace,
    AndPredicate,
    DictProvider,
    EmbeddingIndex,
    FuzzySet,
    HalfspacePredicate,
    LogicIndex,
    NotPredicate,
    Predicate,
    OllamaProvider,
    OpenAICompatibleProvider,
    SimilarityPredicate,
    TemplateProvider,
    TRUE, FALSE,
    analogy_vector,
    apply_offset,
    evaluate_analogy_cases,
    linear_combination,
    cosine_scores,
    fit_geometry,
    fit_halfspace_predicate,
    fit_similarity_predicate,
    fit_relation_from_text_pairs,
    l2_normalize_rows,
    l2_normalize_vector,
    mean_relation_offset,
    rank_fuzzy,
    relation_diagnostics,
)


def test_whitening():
    rng = np.random.default_rng(7)
    x = rng.normal(size=(100, 6)) @ rng.normal(size=(6, 10))
    geom = fit_geometry(x, mode="whiten", rank=6)
    z = geom.apply(x)
    cov = np.cov(z, rowvar=False)
    assert np.allclose(cov, np.eye(6), atol=1e-10), np.max(np.abs(cov - np.eye(6)))


def test_linear_combination():
    x=np.array([[1.,0.],[0.,2.],[3.,4.]])
    y=linear_combination(x,[2.,-1.,0.5])
    assert np.allclose(y,[3.5,0.0])




def test_apply_offset_and_analogy_evaluator():
    mapping={
        "man":[1.,0.,0.], "woman":[1.,1.,0.],
        "king":[2.,0.,1.], "queen":[2.,1.,1.],
        "prince":[3.,0.,2.], "princess":[3.,1.,2.],
        "noise":[-2.,3.,4.],
    }
    p=DictProvider(mapping)
    s=AlgebraSpace.fit(p,list(mapping))
    idx=EmbeddingIndex.from_space(s,list(mapping))
    offset=fit_relation_from_text_pairs(s,[["man","woman"],["prince","princess"]])
    assert np.allclose(apply_offset(s.encode_one("king"),offset),s.encode_one("queen"))
    report=evaluate_analogy_cases(s,idx,[["man","woman","king","queen"]],top_k=3)
    assert report["count"] == 1
    assert report["top1_accuracy"] == 1.0
    assert report["topk_accuracy"] == 1.0
    assert report["mrr"] == 1.0
    assert report["rows"][0]["predicted"] == "queen"
    for bad in ([["man","woman","king","man"]], [["man","woman","missing","queen"]]):
        try:
            evaluate_analogy_cases(s,idx,bad)
        except ValueError:
            pass
        else:
            raise AssertionError("invalid analogy case was accepted")
    try:
        apply_offset(np.array([1.,0.]),np.array([0.,1.]),strength=float("nan"))
    except ValueError:
        pass
    else:
        raise AssertionError("non-finite strength was accepted")


def test_relation_and_retrieval():
    mapping = {
        "a": [1., 0., 0.], "b": [1., 1., 0.],
        "c": [2., 0., 1.], "d": [2., 1., 1.],
        "e": [3., 0., 2.], "f": [3., 1., 2.],
    }
    p = DictProvider(mapping)
    s = AlgebraSpace.fit(p, mapping.keys())
    idx = EmbeddingIndex.from_space(s, list(mapping))
    q = analogy_vector(s.encode_one("a"), s.encode_one("b"), s.encode_one("c"))
    assert idx.nearest(q, top_k=1, exclude=("a", "b", "c"))[0][0] == "d"
    r = fit_relation_from_text_pairs(s, [["a", "b"], ["e", "f"]])
    assert np.allclose(r, [0,1,0])
    diag = relation_diagnostics(s.encode(["a","e"]), s.encode(["b","f"]))
    assert np.isclose(diag["mean_direction_alignment"], 1.0)




def test_predicate_interface_hardening():
    p=HalfspacePredicate(np.array([1.,0.]),0.0)
    try:
        AndPredicate(p,"not a predicate")
    except TypeError:
        pass
    else:
        raise AssertionError("malformed AndPredicate accepted")
    try:
        NotPredicate("not a predicate")
    except TypeError:
        pass
    else:
        raise AssertionError("malformed NotPredicate accepted")
    for cls,args in [
        (SimilarityPredicate,(np.array([1.,0.]),"0.5")),
        (HalfspacePredicate,(np.array([1.,0.]),True)),
    ]:
        try:
            cls(*args)
        except TypeError:
            pass
        else:
            raise AssertionError(f"{cls.__name__} accepted non-real threshold")

    class BadPredicate(Predicate):
        def evaluate(self,vectors):
            return np.ones((len(vectors),1),dtype=bool)

    idx=EmbeddingIndex(("a","b"),np.eye(2))
    logic=LogicIndex(idx)
    try:
        logic.select(BadPredicate())
    except ValueError:
        pass
    else:
        raise AssertionError("bad predicate mask shape accepted")

    class NumericPredicate(Predicate):
        def evaluate(self,vectors):
            return np.ones(len(vectors),dtype=float)

    try:
        logic.select(NumericPredicate())
    except TypeError:
        pass
    else:
        raise AssertionError("non-boolean predicate mask accepted")


def test_boolean_laws_randomized():
    rng = np.random.default_rng(123)
    x = rng.normal(size=(200, 9))
    for _ in range(100):
        d1, d2, d3 = rng.normal(size=(3, 9))
        A = HalfspacePredicate(d1, rng.normal())
        B = HalfspacePredicate(d2, rng.normal())
        C = HalfspacePredicate(d3, rng.normal())
        ae, be, ce = A.evaluate(x), B.evaluate(x), C.evaluate(x)
        assert np.array_equal((A & B).evaluate(x), (B & A).evaluate(x))
        assert np.array_equal(((A & B) & C).evaluate(x), (A & (B & C)).evaluate(x))
        assert np.array_equal((A | B).evaluate(x), (B | A).evaluate(x))
        assert np.array_equal(((A | B) | C).evaluate(x), (A | (B | C)).evaluate(x))
        assert np.array_equal((A & A).evaluate(x), ae)
        assert np.array_equal((A | A).evaluate(x), ae)
        assert np.array_equal((~~A).evaluate(x), ae)
        assert np.array_equal((~(A & B)).evaluate(x), ((~A) | (~B)).evaluate(x))
        assert np.array_equal((~(A | B)).evaluate(x), ((~A) & (~B)).evaluate(x))
        assert np.array_equal((A & (~A)).evaluate(x), np.zeros(len(x), dtype=bool))
        assert np.array_equal((A | (~A)).evaluate(x), np.ones(len(x), dtype=bool))
        assert np.array_equal((A & TRUE).evaluate(x), ae)
        assert np.array_equal((A | FALSE).evaluate(x), ae)
        assert np.array_equal((A & FALSE).evaluate(x), np.zeros(len(x), dtype=bool))
        assert np.array_equal((A | TRUE).evaluate(x), np.ones(len(x), dtype=bool))
        assert np.array_equal(A.implies(B).evaluate(x), ((~A) | B).evaluate(x))
        assert np.array_equal(A.xor(B).evaluate(x), np.logical_xor(ae, be))
        assert np.array_equal(A.equivalent(B).evaluate(x), np.logical_not(np.logical_xor(ae, be)))
        assert np.array_equal(A.nand(B).evaluate(x), np.logical_not(np.logical_and(ae, be)))
        assert np.array_equal(A.nor(B).evaluate(x), np.logical_not(np.logical_or(ae, be)))


def test_fuzzy_laws_randomized():
    rng = np.random.default_rng(456)
    for _ in range(100):
        a = FuzzySet(rng.random(50)); b = FuzzySet(rng.random(50)); c = FuzzySet(rng.random(50))
        assert np.allclose((a & b).membership, (b & a).membership)
        assert np.allclose(((a & b) & c).membership, (a & (b & c)).membership)
        assert np.allclose((a | b).membership, (b | a).membership)
        assert np.allclose(((a | b) | c).membership, (a | (b | c)).membership)
        assert np.allclose((~(a & b)).membership, ((~a) | (~b)).membership)
        assert np.allclose((~(a | b)).membership, ((~a) & (~b)).membership)
        assert np.allclose((~~a).membership, a.membership)




def test_similarity_fit():
    center=np.array([1.,0.,0.])
    pos=np.array([[1.,0.,0.],[0.95,0.1,0.],[0.9,-0.1,0.]])
    neg=np.array([[0.,1.,0.],[-1.,0.,0.],[0.,0.,1.]])
    pred,info=fit_similarity_predicate(center,pos,neg)
    assert info["train_balanced_accuracy"] == 1.0
    assert np.all(pred.evaluate(pos))
    assert not np.any(pred.evaluate(neg))
    assert -1.0 <= pred.threshold <= 1.0


def test_frozen_numeric_state():
    geom=fit_geometry(np.array([[1.,0.],[0.,1.],[1.,1.]]),mode="center")
    try:
        geom.mean[0]=99.0
    except ValueError:
        pass
    else:
        raise AssertionError("geometry mean was mutable")
    pred=SimilarityPredicate(np.array([1.,0.]),0.0)
    try:
        pred.center[0]=0.0
    except ValueError:
        pass
    else:
        raise AssertionError("predicate center was mutable")
    fuzzy=FuzzySet(np.array([0.2,0.8]))
    try:
        fuzzy.membership[0]=0.9
    except ValueError:
        pass
    else:
        raise AssertionError("fuzzy membership was mutable")
    idx=EmbeddingIndex(["a","b"],np.array([[1.,0.],[0.,1.]]))
    assert idx.labels == ("a","b")
    try:
        idx.vectors[0,0]=2.0
    except ValueError:
        pass
    else:
        raise AssertionError("index vectors were mutable")


def test_geometry_fuzz():
    rng=np.random.default_rng(2026)
    for n in (3,5,12,30):
        for d in (2,4,9):
            x=rng.normal(size=(n,d))
            rank=np.linalg.matrix_rank(x-x.mean(axis=0))
            if rank:
                k=min(rank,3)
                g=fit_geometry(x,mode="whiten",rank=k)
                z=g.apply(x)
                cov=np.atleast_2d(np.cov(z,rowvar=False))
                assert np.allclose(cov,np.eye(k),atol=1e-9)


def test_halfspace_fit():
    rng = np.random.default_rng(99)
    pos = rng.normal(loc=[2,0,0], scale=0.2, size=(50,3))
    neg = rng.normal(loc=[-2,0,0], scale=0.2, size=(50,3))
    pred, info = fit_halfspace_predicate(pos, neg)
    assert info["train_balanced_accuracy"] == 1.0
    assert np.all(pred.evaluate(pos))
    assert not np.any(pred.evaluate(neg))


def test_logic_index():
    labels=("red apple","green apple","red car","blue car")
    x=np.array([[1,1,0],[0,1,0],[1,0,1],[0,0,1]],dtype=float)
    idx=EmbeddingIndex(labels,x)
    logic=LogicIndex(idx)
    red=HalfspacePredicate(np.array([1.,0,0]),0.5)
    apple=HalfspacePredicate(np.array([0.,1,0]),0.5)
    assert logic.select(red & apple)==["red apple"]
    assert set(logic.select(red | apple))=={"red apple","green apple","red car"}
    assert set(logic.select(~red))=={"green apple","blue car"}
    ranked=logic.rank(np.array([1.,1.,0.]), red | apple, top_k=2)
    assert ranked[0][0]=="red apple"


class Handler(BaseHTTPRequestHandler):
    def do_POST(self):
        length = int(self.headers.get("content-length", "0"))
        payload = json.loads(self.rfile.read(length))
        texts = payload["input"]
        if self.path == "/v1/embeddings":
            # Return deliberately reversed response order to test index sorting.
            data = [
                {"object":"embedding","index":i,"embedding":[float(i+1), float(len(t))]}
                for i,t in enumerate(texts)
            ][::-1]
            body = {"object":"list","data":data,"model":payload["model"],"usage":{}}
        elif self.path == "/api/embed":
            body = {"model":payload["model"],"embeddings":[[float(i+1),float(len(t))] for i,t in enumerate(texts)]}
        else:
            self.send_response(404); self.end_headers(); return
        raw=json.dumps(body).encode()
        self.send_response(200)
        self.send_header("Content-Type","application/json")
        self.send_header("Content-Length",str(len(raw)))
        self.end_headers(); self.wfile.write(raw)

    def log_message(self, format, *args):
        pass




def test_provider_config_validation():
    bad_openai = [
        OpenAICompatibleProvider(model=123, base_url="http://localhost"),
        OpenAICompatibleProvider(model="x", base_url=123),
        OpenAICompatibleProvider(model="x", base_url="http://localhost", api_key=123),
        OpenAICompatibleProvider(model="x", base_url="http://localhost", timeout="60"),
    ]
    for provider in bad_openai:
        try:
            provider.embed(["a"])
        except TypeError:
            pass
        else:
            raise AssertionError("invalid OpenAI-compatible config was accepted")

    for truncate in ("false", 0, 1, None):
        provider=OllamaProvider(model="x",base_url="http://localhost",truncate=truncate)
        try:
            provider.embed(["a"])
        except TypeError:
            pass
        else:
            raise AssertionError("non-boolean Ollama truncate was accepted")


def test_http_adapters():
    server=HTTPServer(("127.0.0.1",0),Handler)
    thread=threading.Thread(target=server.serve_forever,daemon=True); thread.start()
    host=f"http://127.0.0.1:{server.server_port}"
    try:
        p=OpenAICompatibleProvider(model="mock",base_url=host+"/v1",retries=0)
        x=p.embed(["a","bbb"])
        assert np.allclose(x,[[1,1],[2,3]])
        o=OllamaProvider(model="mock",base_url=host,retries=0)
        y=o.embed(["a","bbb"])
        assert np.allclose(y,[[1,1],[2,3]])
    finally:
        server.shutdown(); server.server_close(); thread.join(timeout=2)


def test_template_provider():
    base=DictProvider({"Q: cat !":[1.,0.],"Q: dog !":[0.,1.]})
    wrapped=TemplateProvider(base,prefix="Q: ",suffix=" !")
    x=wrapped.embed(["cat","dog"])
    assert np.allclose(x,[[1.,0.],[0.,1.]])


def test_tie_stability():
    idx=EmbeddingIndex(("first","second","third"),np.array([[1.,0],[1.,0],[0.,1]]))
    result=idx.nearest(np.array([1.,0]),top_k=3)
    assert [x[0] for x in result[:2]]==["first","second"]


def test_errors():
    try:
        analogy_vector(np.array([1.,0]),np.array([0.,1]),np.array([1.,-1]))
    except ValueError as e:
        assert "zero" in str(e)
    else: raise AssertionError("zero query not rejected")
    try:
        fit_geometry(np.ones((3,4)),mode="whiten")
    except ValueError:
        pass
    else: raise AssertionError("constant whitening not rejected")




def test_numeric_option_validation():
    for eps in (0.0,-1.0,float("nan"),"1e-15",True):
        try:
            l2_normalize_vector(np.array([1.,0.]),eps=eps)
        except (TypeError,ValueError):
            pass
        else:
            raise AssertionError(f"invalid eps accepted: {eps!r}")
        try:
            l2_normalize_rows(np.eye(2),eps=eps)
        except (TypeError,ValueError):
            pass
        else:
            raise AssertionError(f"invalid row eps accepted: {eps!r}")
    for mode in (123,None,True):
        try:
            fit_geometry(np.eye(2),mode=mode)
        except (TypeError,ValueError):
            pass
        else:
            raise AssertionError("invalid geometry mode type accepted")
    idx=EmbeddingIndex(("a","b"),np.eye(2))
    for threshold,temperature in [("0.5",0.1),(0.5,"0.1"),(0.5,0.0),(0.5,float("inf"))]:
        try:
            from embedding_algebra_core import fuzzy_similarity_membership
            fuzzy_similarity_membership(np.array([1.,0.]),idx.vectors,threshold=threshold,temperature=temperature)
        except (TypeError,ValueError):
            pass
        else:
            raise AssertionError("invalid fuzzy numeric option accepted")


def test_interface_type_validation():
    mapping={"a":[1.,0.],"b":[0.,1.]}
    p=DictProvider(mapping)
    s=AlgebraSpace.fit(p,["a","b"])
    idx=EmbeddingIndex.from_space(s,["a","b"])
    cases=[]
    try:
        fit_geometry(np.array([[1.,0.],[0.,1.]]), mode="whiten", rank=1.5)
    except TypeError: pass
    else: cases.append("fractional rank")
    try:
        idx.nearest(np.array([1.,0.]), top_k=1.2)
    except TypeError: pass
    else: cases.append("fractional top_k")
    try:
        idx.nearest(np.array([1.,0.]), exclude="a")
    except TypeError: pass
    else: cases.append("string exclude")
    try:
        OpenAICompatibleProvider(model="x", dimensions=2.5).embed(["a"])
    except TypeError: pass
    except RuntimeError:
        cases.append("fractional dimensions reached network")
    else: cases.append("fractional dimensions")
    if cases:
        raise AssertionError(cases)


def main():
    tests=[name for name in globals() if name.startswith("test_")]
    for name in sorted(tests):
        globals()[name]()
        print(name,"PASS")
    print(f"{len(tests)} tests PASS")

if __name__=="__main__": main()
```

Run:

```bash
python test_embedding_algebra_core.py
```

The expected local result for this version is:

```text
test_apply_offset_and_analogy_evaluator PASS
test_boolean_laws_randomized PASS
test_errors PASS
test_frozen_numeric_state PASS
test_fuzzy_laws_randomized PASS
test_geometry_fuzz PASS
test_halfspace_fit PASS
test_http_adapters PASS
test_interface_type_validation PASS
test_linear_combination PASS
test_logic_index PASS
test_numeric_option_validation PASS
test_predicate_interface_hardening PASS
test_provider_config_validation PASS
test_relation_and_retrieval PASS
test_similarity_fit PASS
test_template_provider PASS
test_tie_stability PASS
test_whitening PASS
19 tests PASS
```

The test suite uses no cloud credentials and therefore verifies the algorithm and provider protocol handling independently of model availability.

---

# 37. Real-provider smoke test

After configuring an actual embedding endpoint:

```python
import os
from embedding_algebra_core import (
    OpenAICompatibleProvider,
    provider_smoke_test,
)

provider = OpenAICompatibleProvider(
    model=os.environ["EMBED_MODEL"],
    base_url=os.environ["EMBED_BASE_URL"],
    api_key=os.environ.get("EMBED_API_KEY"),
)

print(provider_smoke_test(provider))
```

Examples:

## OpenAI

```bash
export EMBED_MODEL="text-embedding-3-large"
export EMBED_BASE_URL="https://api.openai.com/v1"
export EMBED_API_KEY="$OPENAI_API_KEY"
```

## local vLLM

```bash
export EMBED_MODEL="MODEL_ID_REPORTED_BY_SERVER"
export EMBED_BASE_URL="http://localhost:8000/v1"
unset EMBED_API_KEY
```

## LM Studio

```bash
export EMBED_MODEL="MODEL_ID_REPORTED_BY_SERVER"
export EMBED_BASE_URL="http://localhost:1234/v1"
unset EMBED_API_KEY
```

This verifies actual vector dimensions, finiteness, norms, and basic cosine behavior.

---

# 38. Real arithmetic benchmark template

Do not assert success before observing it.

Use a candidate universe with meaningful distractors and hold relations out properly.

Example categories:

```text
singular → plural
present → past
adjective → comparative
country → capital
country → currency
male/female lexical pairs
```

Classic work found that analogy arithmetic is more reliable for some morphological alternations, male/female alternations, and named-entity relations than for arbitrary lexical semantics. That remains a useful expectation, not a guarantee for a modern embedding endpoint.

For each relation, report all test cases rather than only successful examples.

The reference module includes an executable evaluator:

```python
from embedding_algebra_core import evaluate_analogy_cases

report = evaluate_analogy_cases(
    space,
    index,
    [
        ["man", "woman", "king", "queen"],
        ["small", "smaller", "large", "larger"],
    ],
    top_k=5,
)

print(report["top1_accuracy"])
print(report["topk_accuracy"])
print(report["mrr"])
for row in report["rows"]:
    print(row)
```

The target must already exist in the frozen candidate universe. The evaluator excludes the three query terms but never the target, rejects malformed cases in which the target is one of those operands, and uses deterministic ranking for exact ties.

---

# 39. How to use an ordinary generative LLM as the source of embeddings

If the actual requirement is:

> use the same Qwen/Gemma/etc. generative model that an agent uses, but obtain one vector per text

then the model needs a **defined pooling rule**.

A serving stack such as vLLM can expose supported generative architectures in embedding mode. Its current documentation states that automatic embedding conversion uses a pooled hidden representation, with the default conversion using a normalized representation corresponding to the prompt endpoint/last token for generic models.

The important rule is that the pooling procedure becomes part of the embedding definition:

\[
E_{M,P}(x),
\]

where `M` is the model and `P` is the pooling rule.

Changing `P` creates a different vector space even when `M` is unchanged.

Therefore record it and never mix outputs from different pooling modes.

---

# 40. What this system can guarantee

It can guarantee the following mechanically:

- vector arithmetic is calculated exactly as specified;
- nearest-neighbor decoding uses cosine correctly;
- exact Boolean composition satisfies Boolean laws;
- predicate negation is exact on its declared vector domain, while enumerated human-readable complement is relative to a declared candidate universe;
- fuzzy min/max logic satisfies its stated algebraic identities;
- provider response ordering cannot silently scramble embeddings;
- ties are deterministic;
- invalid numerical states are rejected;
- whitening uses only numerical-rank directions;
- any finite, non-zero result vector can be converted to ranked human-readable output **provided a nonempty candidate index with valid non-zero vectors exists**.

---

# 41. What no generic embedding-only system can guarantee

It cannot truthfully guarantee that:

- `king - man + woman` always retrieves `queen`;
- every semantic relation is linear;
- `-E(x)` means `NOT x`;
- `E(a)+E(b)` means `a AND b` or `a OR b`;
- an arbitrary off-manifold vector corresponds to one grammatical string;
- arbitrary text can be reconstructed exactly without a candidate universe or a separate decoder;
- embeddings from different models can be combined coordinate-wise;
- an embedding model optimized for retrieval will automatically expose clean symbolic algebra.

Those are empirical or mathematically invalid assumptions, not implementation problems.

---

# 42. The strongest embedding-only design

For the stated goal, the recommended system is:

## Arithmetic

\[
\boxed{
q=z_x+r_R
}
\]

or

\[
\boxed{
q=z_b-z_a+z_c
}
\]

followed by nearest-neighbor retrieval.

## Logic

Define atomic concepts as embedding predicates:

\[
\boxed{
P_A(x)=[f_A(z_x)\ge\tau_A]
}
\]

where `f_A` is cosine similarity or a learned linear projection.

Then:

\[
\boxed{
P_{A\land B}=P_A\land P_B
}
\]

\[
\boxed{
P_{A\lor B}=P_A\lor P_B
}
\]

\[
\boxed{
P_{\neg A}=\neg P_A
}
\]

and return the human-readable labels of vectors satisfying the expression.

This gives a clean division:

```text
continuous embedding geometry → meaning / similarity / learned attributes
Boolean algebra              → logical composition
retrieval                    → human-readable output
```

No model-internal hidden-state machinery is required.

---

# 43. 10/10 release gate for a concrete model

Before calling a particular deployment finished, require all of the following.

## Mechanical gate

- [x] core module parses;
- [x] synthetic analogy recovers the mathematically exact answer;
- [x] HTTP provider adapters pass mocked endpoint tests;
- [x] malformed provider configuration is rejected before network I/O, including non-Boolean Ollama `truncate`;
- [x] frozen text-template provider behavior is tested;
- [x] invalid vectors and invalid integer-valued API parameters are rejected;
- [x] invalid normalization epsilons, fuzzy numeric options, and geometry-mode types are rejected;
- [x] stable tie behavior is tested;
- [x] whitening is numerically verified across randomized matrix shapes and ranks;
- [x] stored geometry, predicate, fuzzy-membership, and index arrays are protected against accidental mutation;
- [x] calibrated cosine-predicate fitting is tested;
- [x] held-out-style analogy evaluator and offset application are tested;
- [x] exact Boolean laws and derived operators pass randomized property tests;
- [x] malformed predicate objects, non-Boolean masks, and wrong-shaped masks are rejected before logical composition can silently broadcast/coerce them;
- [x] fuzzy De Morgan/double-negation tests pass;
- [x] half-space predicate fitting is tested;
- [x] human-readable retrieval is tested.

## Real-provider gate

For the selected model/provider:

- [ ] actual endpoint smoke test passes;
- [ ] model ID/revision, dimensions, pooling, normalization, role, and instruction/template are frozen;
- [ ] every arithmetic operand and decode candidate uses the same symmetric embedding recipe, or a cross-role mapping is separately validated;
- [ ] candidate universe is frozen;
- [ ] all relation benchmarks run on held-out pairs;
- [ ] all logic atoms run on held-out labels;
- [ ] shuffled/random controls run;
- [ ] top-1/top-k/MRR reported;
- [ ] predicate precision/recall/F1 reported;
- [ ] composite logical set metrics reported;
- [ ] failures are preserved, not removed.

The unchecked items depend on the **actual embedding endpoint you choose**. They cannot be honestly marked passed in this ChatGPT runtime without that endpoint and its credentials/model server.

---

# 44. Local verification performed on this version

The complete core and test suite embedded in this Markdown were executed locally during hardening.

Observed result:

```text
embedding_algebra_core self-test: PASS
test_apply_offset_and_analogy_evaluator PASS
test_boolean_laws_randomized PASS
test_errors PASS
test_frozen_numeric_state PASS
test_fuzzy_laws_randomized PASS
test_geometry_fuzz PASS
test_halfspace_fit PASS
test_http_adapters PASS
test_interface_type_validation PASS
test_linear_combination PASS
test_logic_index PASS
test_numeric_option_validation PASS
test_predicate_interface_hardening PASS
test_provider_config_validation PASS
test_relation_and_retrieval PASS
test_similarity_fit PASS
test_template_provider PASS
test_tie_stability PASS
test_whitening PASS
19 tests PASS
```

The mocked HTTP test deliberately returns OpenAI-compatible embeddings in reversed response order and verifies that the adapter restores them by the API `index` field. It separately exercises the Ollama response shape.

This makes the provider layer test meaningful rather than merely testing a local dictionary.

---

# 45. Final recommendation

Start with this exact sequence:

```text
1. Choose ONE embedding provider/model.
2. Freeze model ID, dimensions, input formatting, and pooling.
3. Build a human-readable candidate universe.
4. Embed every candidate once.
5. Start with identity geometry.
6. Test direct b-a+c arithmetic.
7. Test relation offsets learned from multiple held-out training pairs.
8. Compare centering/whitening only as ablations.
9. For logic, learn or define atomic predicates over embeddings.
10. Compose AND/OR/NOT as actual Boolean operations, not vector addition/sign flips.
11. Return candidate strings directly for logic.
12. Return nearest indexed strings for arithmetic.
13. Run random/shuffled controls.
14. Keep only claims that survive held-out evaluation.
```

That is the cleanest way to obtain an actual **embedding algebra + embedding logic system** while using only modern LLM embeddings.

---

# References and current implementation sources

- Mikolov, T. et al. (2013). *Efficient Estimation of Word Representations in Vector Space.* https://arxiv.org/abs/1301.3781
- Levy, O. & Goldberg, Y. (2014). *Linguistic Regularities in Sparse and Explicit Word Representations.* https://aclanthology.org/W14-1618/
- Finley, G., Farmer, S., & Pakhomov, S. (2017). *What Analogies Reveal about Word Vectors and their Compositionality.* https://aclanthology.org/S17-1001/
- Hamilton, W. et al. (2018). *Embedding Logical Queries on Knowledge Graphs.* https://arxiv.org/abs/1806.01445
- Ren, H., Hu, W., & Leskovec, J. (2020). *Query2box: Reasoning over Knowledge Graphs in Vector Space using Box Embeddings.* https://arxiv.org/abs/2002.05969
- Ren, H. & Leskovec, J. (2020). *Beta Embeddings for Multi-Hop Logical Reasoning in Knowledge Graphs.* https://arxiv.org/abs/2010.11465
- Xiong, B. (2026). *The Hidden Lattice Geometry of LLMs / Lattice Representation Hypothesis.* ICLR 2026 / arXiv:2603.01227.
- OpenAI model catalog and embeddings API: https://developers.openai.com/api/docs/models/all and https://developers.openai.com/api/reference/
- Qwen3-Embedding official model card (instruction-aware and query prompting): https://huggingface.co/Qwen/Qwen3-Embedding-8B
- Google Gemini Embeddings task-format documentation (symmetric vs asymmetric formats): https://ai.google.dev/gemini-api/docs/embeddings
- OpenAI Embeddings FAQ: https://help.openai.com/en/articles/6824809-embeddings-frequently-asked-questions
- OpenCode model documentation: https://opencode.ai/v2/docs/models
- vLLM embedding/pooling documentation: https://docs.vllm.ai/en/latest/models/pooling_models/embed/
- LM Studio OpenAI-compatible endpoints: https://lmstudio.ai/docs/developer/openai-compat
- Ollama embeddings documentation: https://docs.ollama.com/capabilities/embeddings
