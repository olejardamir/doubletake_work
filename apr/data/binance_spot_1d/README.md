# APR v25 market-data bridge — training archive

This directory repairs the connector-to-Library transfer blocker using **Binance connector → GitHub contents API**, with no local filesystem handoff. Three complete, connector-normalized (NOT original HTTP) OHLCV archives were retrieved 2026-10-26 UTC and independently read back byte-for-byte from GitHub.

| Asset | Period (UTC inclusive) | Rows | Git blob SHA |
|---|---|---:|---|
| BTCUSDT | 2018-12-01..2020-12-31 | 762 | `aa8549b0805f08b49ba13e9f89fb9b48da692c94` |
| ETHUSDT | 2018-12-01..2020-12-31 | 762 | `cb210fc292b35873ff2e64161a086670497f1b3b` |
| XRPUSDT | 2018-12-01..2020-12-31 | 762 | `3a493989cb88bf0c37c33a38be72a7b33216ea23` |

All rows have exactly 12 Binance spot kline fields; day-open UTC timestamps are contiguous without gaps; total 2,286 bars. These blobs are public historical market data. This archive has no trading credentials or account data. The exact original HTTP response and server headers were **not** obtained; the source is the connector-normalized response and no independent first-seen timestamp is claimed.

## Pipeline contract

1. B/C retrieve the three files using connected GitHub `fetch_file` or GitHub REST `contents` API. Validate the Git blob SHA, 762 rows each, 12 fields, all consecutive UTC days, and 2020-12-31 training cutoff. Prefer exact commit pin over branch head for repeatability.
2. Recompute training features and A135's 72 monthly anchor rows and 7 retained formulas **from these complete daily sources**, documenting any discrepancies with earlier B130 derived features; a mismatch is evidence to investigate, not permission to quietly modify an already proposed formula.
3. C freezes the *whole* A135 batch, including 9 submitted / 7 retained / 2 excluded, all code+train-fit hashes, feature derivation, costs, baseline and 2021 33-event cohort **before** reading any 2021 outcomes.
4. Only afterward, B/D fetch the distinct 2021 evaluation prices for scoring; never train on or inspect 2021 outcome labels before freeze. Store 2021 archive separately after freeze (GitHub is an authorized durable store). Report P/N/Z/U for every candidate under each fee scenario, full coverage and comparison to 30-day momentum.
5. This is OFFLINE RESEARCH ONLY, not an upgrade to legacy H8/D102/P0 qualified forecast records; no live trades.

If a Library-to-GitHub interoperability restriction remains, the GitHub blob itself is durable canonical data. A Library report may carry its exact GitHub URL, commit SHA, blob SHA, retrieval code and verified row counts instead of a byte-copy. **Do not block evaluation solely because the same dataset is not duplicated into the ChatGPT Library.**
