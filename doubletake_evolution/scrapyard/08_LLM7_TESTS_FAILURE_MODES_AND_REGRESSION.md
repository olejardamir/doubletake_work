# Historical LLM7 failure/regression test matrix — distilled

**Original blob:** `e8e54fb6104adafd329cc031f4d03a6ccd4b4fc8`. Historical Agent_X plan, not verified test execution. [Master](00_MAIN_PROMPT.md); [D01](DISTILLED_KNOWLEDGE.md).

**Three layers:** deterministic mocked HTTP/fixtures, canonical runtime provider integration, tiny opt-in live smoke. Normal CI must not require external LLM7 availability. Registration/config: catalog/registry/definition uniqueness, anonymous no-key, headless config, reload. Models: `/v1/models` valid/empty/malformed/partial metadata, capability mapping, cache/refresh/timeout. Runtime: URL, path, Content-Type, **no Authorization** in anonymous mode, chat/SSE, abort/timeout, 4xx/5xx/rate, invalid JSON/missing choices, unavailable model. Tools: supported/unsupported/token-only, call IDs and result round-trip. Regress OpenCode/Codex and shared transport.

**Live diagnostic:** opt-in GET models→currently accessible model→tiny no-auth chat→optional stream; disabled=SKIP, enabled external policy change=explicit FAIL, no secret read merely to prove anonymity. No partial config corruption, fake key, secret logs or retry storms. File-presence/grep tests are insufficient; exercise reachable paths. **Unknown:** current provider access, tests actually run and DT consumer.
