# DoubleTake patch-management ledger

**Current owner (2026-11-02):** **Borg Code Engineer**, GPT automation `6ae806721bc48191bc27372da61ec9fc`, merges former Borg Patch Engineer source diagnosis/patch repair with direct code/test integration. The old Patch Engineer automation `6ae785556ee48191bec4acaed0c9a791` is disabled. **All new implementation source changes belong directly in PRIVATE `olejardamir/DT/main`, never here.** This PUBLIC repository contains mission planning, read-only historic BPE proposals, source-safe work orders and sanitized feedback. No GitHub Actions or local LLM needed.

- `PATCH_INDEX.json`: historical proposal IDs, exact provenance, implementation status, dependencies and recorded test/Ground limits
- `WORKER_RULES.md`: archived prior Patch Engineer contract, read as legacy design guidance; four-worker current role assignments take precedence
- `PATCH_LEARNING.md`: documented lessons from historical patch conflicts and source integration
- `results/<ID>.json`: public-safe historical outcome reports; a report is not a live DT test
- `WORK_ORDERS_INDEX.md`, `work_orders/`, `MISSION_ATOMIC_QUEUE.json`: all 22 current mission steps broken into 58 conditional units
- `MISSION_PATCH_MAP.md`: historical traceability; no authority implied

The `atomic_patches/` MEP files are read-only conditional gates, NOT implementation. Legacy BPE-029/BPE-030 script proposals (if still present) require a new current DT source inspection and independent safety review; the merged Code Engineer may implement the intended behavior DIRECTLY in private DT/main with focused tests, rather than executing a public `.sh`. Do not duplicate already integrated BPE-001/010/024-028 code. The existing `bpe_queue_runner.py` remains an optional operator-controlled fallback, NOT part of the scheduled GPT integration pipeline.

The **four workers** are Evolution Director (independent mission acceptance), Borg Code Engineer (full engineering), Internet Scout (discovery), and Scrapyard Scout (independent source validation and distillation). The private canonical coordination document is `olejardamir/DT/reports/gpt_collective/INTEGRATION_COORDINATION.md`.

Never treat authored patch text, published sources or a GitHub commit as successful test execution, release authorization, live autonomous Ground, or permission to modify retained state. Preserve no-loss, owner controls and confidentiality.
