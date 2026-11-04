# Common-chat controller with compact symbolic graph — research extract

Source: historical "Common Chat Architecture for a Forced Freudian Graph"; original Git blob `7a5be885b7eca182a248532b20e25caedbacd112` (recoverable through Git history). **Design proposal, not DT implementation or empirical evidence.** Original target was a low-resource Llama 3.2:3B + MegaHAL system; Freudian interpretation is project-specific and not a validated psychological assessment.

## Transferable mechanism for DT (hypothesis)
- Separate untrusted/noisy associative generation from authoritative decisions: weak generators may propose alternatives, but deterministic/schema-validated routing, policy checks, and state transitions must decide what is eligible.
- Immediately compress node output to typed, validated packets; group packets into stage summaries; send only bounded, relevant summaries to final synthesis. Keep original raw outputs in an access-controlled trace for reproducibility, not automatically in the model context.
- Maintain distinct raw, working, stage, and canonical traces; record node identity, route candidates, selected/rejected transitions, state deltas and validation failures. Trace is **operational metadata**, not hidden reasoning.
- Keep user-facing response mode independent of internal exploratory route; ordinary factual requests should be answered directly, without projecting symbolic diagnoses.
- Enforce a finite state machine/allowlisted transitions. A suggested packet shape: `{node_id, summary, signals, candidate_routes, state_delta}`; validate type/ranges/allowed keys before consuming. Example numerical pressure scores in the original are **illustrative only**, not calibrated measures.

## Historical architecture (not DT requirements)
Input → controller → optional weak associative nodes (id, memory, dream, fantasy, slips) → per-node packet validation → stage summaries → deterministic conflict/router layer → durable state/trace update → small final synthesizer. Ten macro-stages were proposed: input perception, associations, body/affect, memory, reality, normative evaluation, conflict computation, output selection, feedback/state update, synthesis. MegaHAL was explicitly excluded from reliable reality testing, routing, state mutation, and final decisions.

Original illustrative conflict formula: `id_pressure=max(drive_tags...)`; `reality_pressure=mean(external_danger,social_cost,legal_cost,resource_cost)`; `superego_pressure=clamp01(mean(prohibition,guilt,shame,punishment,ideal_gap)-approval_reward)`; `total_conflict=id+reality+superego-ego_capacity`. **Do not reuse as a factual model or DT safety scoring**: no calibration, validity or adversarial tests were provided.

## Falsifiable DT-oriented experiment
On a permitted isolated test fixture, compare (A) raw candidate context fed to a decision consumer against (B) validated typed packets plus bounded stage summaries and deterministic routing. Hold tasks and budget fixed; include ordinary/practical requests, contradictory candidates, malformed JSON, adversarial prompt injection, missing state, and replay after interruption. Measure token cost, route determinism, unauthorized transition rate, factual-answer accuracy, trace-to-decision linkage, and recovery. Reject transfer if compression hides material negative evidence, worsens decision quality, leaks raw private traces, or changes governed state without authorization. No measured result is claimed.

## Original proposal acceptance and limitations
Original tests named low-conflict weather chat, emotional conflict, practical questions, JSON validation and context-budget enforcement. Claimed acceptance: every input passes the graph; compact final prompt; raw noise not passed wholesale; reproducible routing; optional debug trace; normal replies remain normal. These were *proposed tests*, not recorded passing executions. Missing: actual implementation, benchmark data, provenance for psychological claims, calibrated thresholds, privacy/retention policy, permissions and DT integration point. Keep the original blob for exact examples, schemas, pseudocode and proposed file layout.
