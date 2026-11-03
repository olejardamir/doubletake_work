# Scrapyard canonical inventory — sharded

Last rebuilt: 2026-11-02. Full Git-blob access audit at `b2c891739d6cf57ba3eb406572f90fc8663a2e4c`, before this cleanup commit.

**This is the canonical small entrypoint, replacing the 621,621-character monolithic editable ledger.** Legacy detailed findings were retained *unaltered* in `doubletake_evolution/inventory_archives/INVENTORY_pre_sharding_20261102.md` at exact original Git blob `74a09db470c223dd690a6fb493576f9507ce395d`. Original history remains intact. Pre-sharding `INVENTORY_DELTA.md` is retained as historical metadata; S23–S25 factual source SHAs, reductions and Director dispositions are now reconciled in the appropriate source/incoming shards. Do not append further duplicate delta notes.

- **Current verified target after relevance cleanup: 187 scrapyard blobs** = 136 root files, 29 incoming, 13 canonical clusters and 9 inventory shards; previous source counts are historical.
- Active and retired source identities remain listed in the source shards; `INVENTORY.md` and `INVENTORY_DELTA.md` are excluded from self-referential blob-SHA tracking.
- A listed blob is not proof of full reading, semantic value, or valid cluster membership. `LEGACY_STATUS_NOT_YET_MIGRATED` means classification must be reconciled with the archived inventory and actual current content before mutation.
- In every run, edit only the shard(s) whose original source content was changed. Refetch SHA after commit and verify its row; mark old source deleted only after complete preservation/merge of unique content and check existing references.
- Do not create another monolithic inventory or new running delta log. Report actual bytes reduced, source files modified, clusters merged, originals deleted, incoming disposition, and any unverified Ground.

## Shards

- [clustered.md](inventory_shards/clustered.md) — 13 tracked files
- [incoming.md](inventory_shards/incoming.md) — 29 tracked files
- [root_0-9.md](inventory_shards/root_0-9.md) — 1 live files (historical tombstones separately retained)
- [root_A-D.md](inventory_shards/root_A-D.md) — 107 live files (historical tombstones separately retained)
- [root_E-H.md](inventory_shards/root_E-H.md) — 9 live files (historical tombstones separately retained)
- [root_I-L.md](inventory_shards/root_I-L.md) — 5 live files (historical tombstones separately retained)
- [root_M-P.md](inventory_shards/root_M-P.md) — 5 live files (historical tombstones separately retained)
- [root_Q-T.md](inventory_shards/root_Q-T.md) — 5 live files (historical tombstones separately retained)
- [root_U-Z.md](inventory_shards/root_U-Z.md) — 4 live files (historical tombstones separately retained)

## Backlog priorities

1. **S23–S25 reconciled:** source current SHAs and Director feedback are in root_A-D/incoming shards; keep the old delta as archival metadata, not an active competing tracker.
2. Work through historical documents for genuinely useful minimal extracts and source-file rewriting; prioritize large duplicate prompt editions only if sections can be inspected safely and independent value protected.
3. Merge overlapping sources into canonical `clustered/` records with provenance; delete old originals only after source-value preservation is verified. Keep explicit tombstones in shards.
4. Intake research must not repeatedly displace historical dissection.

## 2026-11-02 no-DT-value cleanup

- Removed **22** unrelated, non-operative or superseded root files after verifying source identities and their absence from the canonical 13 research clusters and the distilled-knowledge index. Full former text remains recoverable from Git history, with the original blob identities and reasons retained in the respective `inventory_shards/root_*.md` tombstones. No incoming, clustered, inventory, mission or private DT code was deleted.

## Second no-value cleanup: superseded technical revisions

- Removed **10** superseded technical revisions only after source-content overlap analysis and preservation of later substantive editions. See `inventory_shards/` deletion tombstones for per-file reasons and historical Git object identity. No canonical clusters, incoming leads, private implementation or current final specifications removed.

## 2026-11-02 further superseded-revision deletion

Removed **31** older source revisions across two commits after selecting retained successors, spanning cosmetic-rule syntax, uBlock backlogs/generalization, Freudian pseudocode, EA Milestone 2, form picker, DT capability participation, research-source evolution and hybrid-jumping design. All deletions are confined to scrapyard root. Source blob SHAs, successor names and deletion tombstones remain in the corresponding `inventory_shards/root_*.md` manifests; original bytes remain in Git history. The later `ublock_resurrected_generalization_backlog_v17_more_projectwide_points.md` is *additive* and was not deleted. This is archival pruning, **not** independent proof that a later document retains every unique design detail of each predecessor.

### Follow-up source-equivalence retirement (same date)

Removed 5 additional superseded source files: original Agent_X multi-session tabs, Harvest adaptive-fidelity integration and continuous-discovery architecture editions; the older EQC-FIC v1.0 standard; and the 5.57 MB UBR behavioral-emulation prompt V15 (V16 retained). Comparative source coverage: Agent_X documents 94–99% of long normalized lines matched successor after equivalent project-name normalization; UBR V15 ~90%; EQC-FIC v1.0 ~51% direct long-line match with broadened v2.3 release candidate. Distinct historical bodies are recoverable from source SHA tombstones. Unmatched sections were not fully semantically certified as redundant; deletion is version retirement, not code verification.

## Complete 307-file blob-access sweep and conservative disposition — 2026-11-02

- Baseline commit: `b2c891739d6cf57ba3eb406572f90fc8663a2e4c`; **307 of 307 Git blobs fetched in full without fetch failures**, covering 256 root files, 29 incoming leads, 13 canonical clusters, 9 inventory shards. `INVENTORY.md` and `INVENTORY_DELTA.md` were also included. No files outside `scrapyard/` reviewed or edited during this sweep.
- Review method: each full body was loaded and inspected for structure, opening purpose, version/status, and representative sections. Candidate version families were separately compared on normalized substantive text lines; this was **not** a manual semantic examination of every paragraph in all 307 documents. `BODY_FETCHED_2026_11_02; STRUCTURE_SCANNED; FULL_SEMANTIC_REVIEW_PENDING` in source shards means exactly that, not FULL_READ. Established deeper dispositions were not downgraded.
- Candidate comparison found very different archives even when filenames looked similar (e.g., old and current implementation prompts, patent-review iterations, research papers, standalone experiments). Those remain untouched unless a later consolidated successor was materially demonstrable. Some later files are additive rather than replacements.
- **This commit removes 6 more superseded originals**, with current Git SHAs, successor paths, and source-level coverage reasons recorded in `inventory_shards/`. 31 previous deletions remain recorded. Remaining 301 blobs include current inventory metadata.
- **Limitations:** exact/normalized long-line overlap is necessary but not sufficient for proving semantic redundancy; historical differences and version-specific outcomes remain recoverable in Git. No running code tests were executed. No unrelated external-project documents were discarded solely because of age or filename.

## Direct relevance re-evaluation — 2026-11-02

- Deleted `ublock_resurrected_remaining_behavior_master_prompt(4).md` (124,965 bytes). It is an executable backlog for a separate browser extension, naming `Astrocytech/uBlockResurrected`, Chromium MV3/DNR rules, filter lists, and extension testing. No distinct reusable DoubleTake mechanism was identified; retaining merely because semantic duplication was not proven was an overly permissive rule. Recorded original Git blob `398cda13851359858532707a4abbe596f73cc65d` for recovery. This is a relevance-based deletion, not a claim of content equivalence to another browser-extension file.
- Current scrapyard count 300 blobs after this deletion, 249 root files. Remaining uBlock files have not been certified valuable by this case-specific decision.

## Relevance-first mass cleanup — 2026-11-02

The previous structural access screening was not a reliable file-value decision. Reassessment prioritized **unique, concrete, current or demonstrably transferable DoubleTake mechanisms**, not merely technical detail or novelty. The following root-level source groups were directly checked against their actual Git blob contents (headings, repository attribution, subject matter, and DT-specific transfer evidence); no unrelated project archives are kept simply because they are long or contain generic programming guidance.

- uBlock-specific implementation and browser-extension documentation: **21 deleted**.
- separate live-match assignment and execution ledgers: **23 deleted**.
- Glyphser patent-review history: **10 deleted**.
- runic/poetry/card/I Ching interpretation corpus: **23 deleted**.
- market-specific theories and experiments: **16 deleted**.
- unrelated stand-alone engineering, mathematics and extension projects: **16 deleted**.

- **109 files deleted, 16,287,924 original bytes removed** from current Git tree; initial 300 blobs, target 191. Each original Git blob SHA and deletion reason remain in sharded inventory tombstones; Git history provides full recovery. No incoming research, clustered DT synthesis, workers, mission file or production source modified.
- Stand-alone architecture and proof references with plausible transfer value (EQC-AC, EQC-FIC, PAIV, finite-primitive proof) were explicitly preserved pending a concrete DT-specific distillation, not certified as important.
- This is **relevance screening of directly fetched project documents, not a claim of paragraph-level semantic proof across every file**. Remaining root files require the same relevance-first rule, and should not be marked valuable just because no duplicate was found.

### Additional four out-of-scope documents — 2026-11-02

- Removed four additional unrelated originals after direct inspection: a human-only Jira procedure, an educational MCQ manual, a semantic rune/card die mapping, and an unrelated employment-evaluation license. These were not needed for DT's architecture, research intake or canonically distilled evidence. 53857 current Git bytes retired; recoverable using original SHAs in root shards.
