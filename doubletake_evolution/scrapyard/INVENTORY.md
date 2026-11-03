# Scrapyard canonical inventory — sharded

Last rebuilt: 2026-11-02. Verified baseline public main: `f01969e9e74afcb8dfc57d8a1bc470162210243f`; this inventory accompanies the second superseded-revision cleanup commit.

**This is the canonical small entrypoint, replacing the 621,621-character monolithic editable ledger.** Legacy detailed findings were retained *unaltered* in `doubletake_evolution/inventory_archives/INVENTORY_pre_sharding_20261102.md` at exact original Git blob `74a09db470c223dd690a6fb493576f9507ce395d`. Original history remains intact. Pre-sharding `INVENTORY_DELTA.md` is retained as historical metadata; S23–S25 factual source SHAs, reductions and Director dispositions are now reconciled in the appropriate source/incoming shards. Do not append further duplicate delta notes.

- **Current live tree after superseded revision cleanup: 307 scrapyard blobs = 256 root files, 29 incoming, 13 canonical clusters, 9 inventory shards.** Original contents remain recoverable from Git history; deletion tombstones preserved in inventory shards.
- Active and retired source identities remain listed in the source shards; `INVENTORY.md` and `INVENTORY_DELTA.md` are excluded from self-referential blob-SHA tracking.
- A listed blob is not proof of full reading, semantic value, or valid cluster membership. `LEGACY_STATUS_NOT_YET_MIGRATED` means classification must be reconciled with the archived inventory and actual current content before mutation.
- In every run, edit only the shard(s) whose original source content was changed. Refetch SHA after commit and verify its row; mark old source deleted only after complete preservation/merge of unique content and check existing references.
- Do not create another monolithic inventory or new running delta log. Report actual bytes reduced, source files modified, clusters merged, originals deleted, incoming disposition, and any unverified Ground.

## Shards

- [clustered.md](inventory_shards/clustered.md) — 13 tracked files
- [incoming.md](inventory_shards/incoming.md) — 29 tracked files
- [root_0-9.md](inventory_shards/root_0-9.md) — 2 live files (historical tombstones separately retained)
- [root_A-D.md](inventory_shards/root_A-D.md) — 127 live files (historical tombstones separately retained)
- [root_E-H.md](inventory_shards/root_E-H.md) — 29 live files (historical tombstones separately retained)
- [root_I-L.md](inventory_shards/root_I-L.md) — 16 live files (historical tombstones separately retained)
- [root_M-P.md](inventory_shards/root_M-P.md) — 38 live files (historical tombstones separately retained)
- [root_Q-T.md](inventory_shards/root_Q-T.md) — 14 live files (historical tombstones separately retained)
- [root_U-Z.md](inventory_shards/root_U-Z.md) — 30 live files (historical tombstones separately retained)

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
