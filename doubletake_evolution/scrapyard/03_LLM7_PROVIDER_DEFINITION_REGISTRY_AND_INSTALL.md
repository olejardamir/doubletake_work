# Historical LLM7 canonical provider wiring — distilled

**Original blob:** `b4895bb1c8b1c187be15c8db35df3ce4f4fc5bc5`. Archival Agent_X plan; [master](00_MAIN_PROMPT.md), [D01](DISTILLED_KNOWLEDGE.md). Revalidate actual current code and access policy.

**Canonical integration:** add provider identity `llm7`, display name, definition export, catalog, registry and existing install/backend enumeration; preserve OpenCode/Codex. Base `https://api.llm7.io/v1`, `/chat/completions`, `/models`. Remote/no-install behavior should use existing abstraction, not a fake local executable. If needed, add minimal generic no-install support. No static model inventory, mandatory anonymous credential, scattered special-case UI or duplicate provider registry. Optional token strategy only if naturally supported and not required for anonymous.

**Tests:** catalog/registry/definition resolve exactly once; normal provider enumeration; correct remote backend; no anonymous credential requirement; OpenCode and Codex entries remain functional. **Unknown:** present-day API entitlement, canonical code paths and any production result; this file is not proof of implementation.
