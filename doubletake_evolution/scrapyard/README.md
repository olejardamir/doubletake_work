# Rune Forces CLI — archived reproducibility and interpretation contract

**Provenance:** historical standalone rune-reading project documentation. Full original recoverable at Git blob `c206eba55f584b77a28b2019e26cf14ec98095e1`. Not a DT capability, scientific validation of divination, or an execution instruction for the Borg Collective. Source code and included 24-rune reference were **not** inspected in this review.

## Deterministic selection vs language-model synthesis

Python, **not** the model, creates a closed ternary codebook, three fixed layouts, rune identities and final eight-rune middle pool. A local instruction-tuned LLM classifies the user's query, presents anonymous choices and synthesizes the result. Three rounds each offer three anonymous statements; the user chooses **one** statement per round. Each chosen ternary digit identifies the **IS** rune; its hidden cyclic companion identifies **IS NOT**; the remaining column across the final layout yields **all 8 MIDDLE runes**, not one arbitrary rune. The three chosen digits and three companion digits each form a unique ternary code. Audit `last_session.json` contains layouts, anonymous statements, choices, candidate identities, middle pool and synthesis. Avoid inspecting it during a reading if concealed identities matter.

## Reproducible local setup (historical, unverified)

Requirements: Python ≥3.10, no pip packages, an OpenAI-compatible local model endpoint and an instruction-tuned model that fits available GPU RAM. Original hardware suggestion: GTX 1070 8 GB, ~4B Gemma GGUF `Q4_K_M`, `llama.cpp` CUDA, context 8192, one request at a time, batch 128/256, disable Flash Attention if unsupported on Pascal. Example (replace filename with actual downloaded model):
```sh
llama-server -m your-gemma-instruct-Q4_K_M.gguf --host 127.0.0.1 --port 8080 -c 8192 -ngl 99 -b 128
python rune_forces.py --validate
python test_project.py
python rune_forces.py
python rune_forces.py --query "What is preventing this project from moving forward?"
python rune_forces.py --resume
```
Windows may use `llama-server.exe` and `run_windows.bat`; Linux may use `sh run_linux.sh`. `config.json` defines model and `base_url`, default `http://127.0.0.1:8080/v1`; an Ollama-compatible alternative is `http://127.0.0.1:11434/v1` with its exact model name. Set `seed=null` for ordinary OS randomness or `--seed 123` for repeatable debugging.

**Recovery semantics:** `--resume` reads the stored query, classification, ternary codebook and completed choices in `last_session.json`, continues the next of three rounds, retries only final synthesis if all choices were saved, and displays an already completed session rather than reselecting. Negative tests to consider: no model assignment of rune identities, exact eight-middle cardinality, no repeated round after crash, deterministic seeded audit, and no mismatch between displayed choices and saved codes. No tests executed here.

**Interpretation boundary:** modern divinatory reflection, not an attested ancient system or validated predictive/diagnostic method. It cannot establish hidden motives or guarantee events and must not replace medical, legal, financial or other professional evidence. Transfer to DT, if any, is limited to separating deterministic state machines from untrusted language synthesis and preserving resumable choice/audit state; no current DT gap or assimilation value demonstrated.
