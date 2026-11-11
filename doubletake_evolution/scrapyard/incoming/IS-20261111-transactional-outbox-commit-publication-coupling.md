# IS-20261111-001 — Transactional outbox: committed-state / event-publication coupling

**Status:** PUBLIC_SOURCE_CANDIDATE_ONLY; not a DT implementation instruction. **Current private DT parity: UNKNOWN.**
**Primary source:** Chris Richardson, *Pattern: Transactional outbox*, https://microservices.io/patterns/data/transactional-outbox.html (public page inspected 2026-11-11 UTC; no numbered version; live page copyright © 2026 Chris Richardson). Original pattern description, problem, forces, solution and duplicate-relay caveat read. All rights reserved; link and paraphrase only, no copied source code or pattern text.
**Public-source dedup:** Public prompt INDEX blob `0113cede448cd8e029e1b0c9a3f4e18ea8d86279` and incoming inventory blob `1c200993d0bbdb7170c4bfb68847c4a756830192` inspected. DT-IP-0012 handles acknowledgement/atomic conditional update of one writer; DT-IP-0019 handles rollback after committed consumers; DT-IP-0051 handles semantic transaction completion. None of those inspected prompt bodies states the distinct cross-boundary invariant *commit durable state and its outbound event intention atomically, then relay only committed events with per-aggregate order and duplicate-safe consumers*. This is not a claim of exhaustive canonical-cluster dedup; Transformer and Scrapyard Scout must recheck before promotion.

## Falsifiable mechanism
If an authorized existing DT consumer ever persists a state change and separately publishes an event/message to another consumer, then:
1. Commit of the state change must also durably record the corresponding outbound event intent within the **same local atomic transaction**. Aborted state changes must never produce corresponding published events.
2. A separate relay may deliver committed intents; for successive committed updates of the same aggregate, publication order must preserve the originating order even across multiple writers.
3. A relay crash after publish but before recording progress can cause duplicate delivery. A downstream consumer must suppress duplicate effects using stable message identity; no exactly-once delivery claim.
This is a conditional architecture hypothesis, **not** evidence DT currently has a database, broker, distributed consumer, missing safeguard or permission to add infrastructure.

## Hypothetical integration and tests (NOT executed)
**Possible seam:** an already owner-authorized persistent-state-to-event handoff, only if identified by a future explicitly authorized coder preflight. No new broker/database/relay should be introduced merely because the pattern exists.
- Positive: committed update plus intent survives crash-before-relay and is eventually published; two ordered updates retain order; authorized duplicate delivery causes one downstream effect.
- Negative: aborted update yields zero published events; crash after commit but before relay does not silently lose intent; crash after publish but before relay acknowledgement does not duplicate consumer effect; concurrent writers cannot invert per-aggregate order; forged/unauthorized intent or cross-tenant message is rejected.
- Freeze independent oracle, writer/consumer IDs, commit sequence, event IDs, exact revision and recovery observations before any future comparison. Distinguish publication-at-least-once from consumer-effect-once; do not assert global ordering or unconditional eventual delivery under permanent outages.

## Boundaries and stop gates
No private DT access, tests, implementation, code, secrets, workflow triggers or privilege changes. Source material cannot authorize effects. If no real owner-approved atomic state/event handoff, return NO_APPLICABLE_CONSUMER. If current behavior already satisfies all relevant clauses, return ALREADY_PRESENT. If a shared transaction boundary, ordering contract or idempotent consumer cannot be established, return CONTRACT_UNKNOWN. A future authorized coder must assess current parity and permissions independently. Pattern is descriptive, not a normative standard; third-party code and dependencies have separately unverified licenses. Scrapyard Scout independently verifies coverage/deletion; Transformer alone owns prompt creation.
