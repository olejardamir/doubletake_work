# Historical Harvest Task 07 — Real UI/API inventory

**Provenance:** Astrocytech/Agent_X audit `874bbe4268aca0539cbf8476f62444d704f2d555` (implementation wave after `3887efe448edd223a00f94db324786d6a47a2d3b`). Historical plan, not evidence that current DT UI is deployed. Original blob `f077f15df62d12bbda19ed5f832ff3e6b84b17cc`; D01 digest: [DISTILLED_KNOWLEDGE.md](DISTILLED_KNOWLEDGE.md).

**Historical owners:** `api/stackmgmt.py`, `harvest_loop.py:list_harvest_inventory`, canonical semantic search (Task 03), canonical Gate B (Task 02), real frontend Harvest components; donor `harvest_ui.py` was in-memory helper, not a production UI.

**Mechanism:** Actual browser/API must semantically search governed inventory with optional capability/domain/source/status/disposition/champion/generator filters. Detail displays evidence and disposition (Do not implement, Experiment, Replace, Extend, Complement, New capability, Blocked). Server derives and revalidates implementation eligibility at action time; client button, stale state, model confidence or UI never grants authority. Replacement names incumbent; complement explains specialization. Surface real lifecycle/progress/recovery, not synthetic status. Retries must be idempotent.

**Falsifiable tests:** Real browser/API paraphrase retrieval and combined filters; stale enabled button rejected; tampered request blocked; double-click no duplicate effects; successful state only after backend verification; browser reaches canonical implementation caller; hidden endpoint cannot bypass Gate B. Substring-only in-memory search is insufficient. Remove donor helper only after unique DTO moved to a real owner and references verified. Record revisions, test results, rollback, unresolved unknowns; current DT parity unverified.
