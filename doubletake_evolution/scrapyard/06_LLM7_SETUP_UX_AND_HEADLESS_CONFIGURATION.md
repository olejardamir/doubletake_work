# Historical LLM7 interactive/headless setup — distilled

**Original blob:** `746ea8632ea6c8873e002f84a21a7a752fb49087`. Historical plan, not current implementation. [Master](00_MAIN_PROMPT.md); [D01](DISTILLED_KNOWLEDGE.md).

**Interactive:** provider `llm7` plus dynamically discovered/verified model; no account/email/password/key/token/login prompt when live anonymous access is allowed. Optional authenticated mode must be explicit. Discovery failure should show an accurate error and preserve config, not invent credential requirements; preserve cancel/back semantics.

**Headless:** use existing noninteractive config and real schema names, conceptually provider/model/base_url/default `auth:none`, without creating a second config store or prompts. Validate no-key mode when supported. Store actual config only; never fake keys or leak optional secrets. Maintain saved OpenCode/Codex migration/reload behavior.

**Tests:** interactive selection/cancel, anonymous no-key setup, dynamic model selection, headless config, persistence/reload, missing-key validation, no fake credential and existing-provider regressions. **Unknown:** current API policy, provider architecture and live E2E Ground.
