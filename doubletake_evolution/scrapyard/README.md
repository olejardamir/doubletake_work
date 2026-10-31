# Rune Forces CLI

This program uses a local instruction-tuned LLM plus the included fact-checked
24-rune reference to resolve three parts of a reading:

- **IS** — the rune directly related to the user's query or situation.
- **IS NOT** — the opposing force the user may be facing.
- **MIDDLE** — all 8 valid surrounding-condition runes from the resolving
  layout, synthesized collectively rather than falsely reduced to one rune.

The LLM never assigns or resolves rune identities. Python creates the closed
ternary codebook, three fixed layouts, and final 8-rune collection. The model classifies
the query and writes anonymous choices and the final grounded synthesis.

## What you need

1. Python 3.10 or newer.
2. An OpenAI-compatible local model server.
3. A quantized instruction model that fits your GTX 1070 8 GB.

No pip packages are required.

## Recommended GTX 1070 setup

Use a Gemma instruction model around 4B parameters in GGUF `Q4_K_M`. A
`llama.cpp` CUDA build is the most direct option. Start with:

- context: 8192 tokens;
- one request at a time;
- maximum GPU offload that fits;
- batch size 128 or 256;
- Flash Attention disabled if unsupported by the Pascal GPU.

The exact model filename depends on the GGUF you download. Start a current
`llama.cpp` server in the directory containing your model, for example:

```bash
llama-server -m your-gemma-instruct-Q4_K_M.gguf \
  --host 127.0.0.1 --port 8080 -c 8192 -ngl 99 -b 128
```

On Windows, the executable may be named `llama-server.exe`.

If you use Ollama instead, change `base_url` in `config.json` to:

```json
"base_url": "http://127.0.0.1:11434/v1"
```

and set `model` to the exact Ollama model name.

## Run

First validate the included source file and run all offline tests:

```bash
python rune_forces.py --validate
python test_project.py
```

Then start your local model server and run:

```bash
python rune_forces.py
```

Windows users can double-click `run_windows.bat` after the server is running.
Linux users may run `sh run_linux.sh`.

You can supply the focus directly:

```bash
python rune_forces.py --query "What is preventing this project from moving forward?"
```

If a reading was interrupted after at least one completed round, continue it:

```bash
python rune_forces.py --resume
```

Resume uses the query, classified section, ternary codebook, and completed
choices stored in `last_session.json`. It continues with the next of three rounds. If all three rounds are saved but the final interpretation failed, it retries the interpretation without asking you to choose again. A completed session displays its saved reading.

## Selection process

The program always runs exactly three layouts and generates three anonymous
statements in each round.
The user makes only one choice: the statement that best matches the situation.
That single choice drives both hidden paths at once:

- `IS` records the selected ternary digit;
- `IS NOT` records the hidden cyclic companion digit;
- the third digit identifies the middle column.

The program never asks the user to identify or select the opposing force.
The three selected digits form a unique code for `IS`. Their three hidden
companion digits form a unique code for `IS NOT`. In the final layout, the
remaining third column contains exactly 8 middle runes. A session
audit is saved to `last_session.json`, including the hidden layouts, statements,
single choices, candidates, middle pool, and final reading.

Do not inspect that file during a reading if you do not want to see the rune
identities behind the statements.

## Configuration

Edit `config.json` to set the local endpoint and model name. The default assumes
`llama-server` at `http://127.0.0.1:8080/v1`.

`seed` should normally remain `null`. Supplying `--seed 123` is useful only for
repeatable debugging; ordinary readings use operating-system randomness.

## Interpretation boundary

This is a modern divinatory synthesis, not an attested ancient system. It is
for reflection and does not diagnose health, establish another person's hidden
motives, guarantee events, or replace medical, legal, financial, or other
professional evidence.
