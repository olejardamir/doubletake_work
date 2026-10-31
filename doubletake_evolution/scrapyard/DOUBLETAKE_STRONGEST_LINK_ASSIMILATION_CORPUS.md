# DoubleTake Strongest-Link Assimilation Corpus

Scope: **Kuaishou DoubleTake / self-evolving recommender R&D** and **Deepractice DoubleTake / PromptX / AgentVM ecosystem**.

Priority: mine primary papers, source, docs, tests, schemas, protocols, experiments, and release history first. Reimplement useful mechanisms within DoubleTake governance; do not blindly copy source or prose. Preserve license/provenance metadata during assimilation.

---

# 1. Kuaishou — DoubleTake / Self-Evolving R&D

## 1.1 DoubleTake technical report — PRIMARY

- https://arxiv.org/abs/2606.26859
- https://arxiv.org/pdf/2606.26859
- https://arxiv.org/html/2606.26859
- https://arxiv.org/e-print/2606.26859
- https://doi.org/10.48550/arXiv.2606.26859
- https://huggingface.co/papers/2606.26859
- https://www.researchgate.net/publication/408106187_DoubleTake_Towards_Agent-Driven_Self-Iteration_of_Industrial_Recommender_Systems
- https://www.alphaxiv.org/abs/2606.26859
- https://www.emergentmind.com/papers/2606.26859
- https://arxivlens.com/paperview/details/doubletake-towards-agent-driven-self-iteration-of-industrial-recommender-systems-1567-0315ed12
- https://paperverse.io/paper/9b635b10-01d4-4387-a43f-33d8f371dbf8
- https://daiwk.github.io/auto-research/agent-research/2606.26859-doubletake/
- https://www.themoonlight.io/en/review/doubletake-towards-agent-driven-self-iteration-of-industrial-recommender-systems
- https://www.bridgingchina.ai/posts/kuaishou-doubletake-recommendation-system-begins-self-iteration

### Mine especially

- Brainstorm Agent
- bounded proposal exploration
- evidence-weighted proposal generation
- Experiment KB
- System KB
- data-analysis evidence
- model-research evidence
- Developing Agent repository grounding
- feature/schema validation
- DSL/static/syntax/dry-run verification
- multidimensional code-quality scoring
- Evaluation Agent
- safe rollout / A-B orchestration
- guardrail veto
- causal attribution / falsifiable attribution checks
- success + failure assetization
- execution trajectory storage
- SGPO / Semantic-Gradient-based Prompt Optimization
- single-subagent harness mutation
- old-vs-new paired replay
- prompt / validation-rule / output-contract / tool-discipline evolution

## 1.2 Kuaishou official confirmation / deployment material

- https://ir.kuaishou.com/news-releases/news-release-details/kuaishou-technology-announces-second-quarter-and-interim-2026
- https://ir.kuaishou.com/zh-hans/news-releases/news-release-details/kuaishoukejifabu2026niandierjidujizhongqiweijingshenhecaiwuyeji
- https://www.investing.com/news/transcripts/earnings-call-transcript-kuaishou-q2-2026-profit-holds-as-stock-falls-4-93CH-4867372
- https://www.bianews.com/news/details?id=240912
- https://www.jintiankansha.me/column/Zk6KEnkhMb
- https://www.gm7.org/archives/123362
- https://www.bilibili.com/video/BV1FCTt6AETZ/

## 1.3 Kuaishou research indexes / author graph

- https://huggingface.co/kuaishou/papers
- https://github.com/HaFred/awesome-generative-recsys/blob/master/docs/by_affiliation.md
- https://dblp.org/pid/59/2902.html
- https://jianghaopg11.github.io/

---

# 2. Kuaishou — RecHarness — HIGHEST-VALUE PUBLIC CODE

## 2.1 Paper

- https://arxiv.org/abs/2607.29241
- https://arxiv.org/pdf/2607.29241
- https://arxiv.org/html/2607.29241
- https://arxiv.org/e-print/2607.29241
- https://doi.org/10.48550/arXiv.2607.29241
- https://huggingface.co/papers/2607.29241
- https://dblp.org/rec/journals/corr/abs-2607-29241
- https://www.alphaxiv.org/abs/2607.29241

## 2.2 Source repository

- https://github.com/6lyc/RecHarness
- https://github.com/6lyc/RecHarness.git
- https://github.com/6lyc/RecHarness/blob/main/README.md
- https://github.com/6lyc/RecHarness/commits/main
- https://github.com/6lyc/RecHarness/issues
- https://github.com/6lyc/RecHarness/tree/main/tests
- https://github.com/6lyc/RecHarness/tree/main/gagc
- https://github.com/6lyc/RecHarness/tree/main/gagc/benchmarks
- https://github.com/6lyc/RecHarness/tree/main/gagc/templates
- https://github.com/6lyc/RecHarness/blob/main/gagc/agent.py
- https://github.com/6lyc/RecHarness/blob/main/gagc/tools.py
- https://github.com/6lyc/RecHarness/blob/main/gagc/state.py
- https://github.com/6lyc/RecHarness/blob/main/gagc/grpo.py
- https://github.com/6lyc/RecHarness/blob/main/gagc/data_preprocess.py
- https://github.com/6lyc/RecHarness/blob/main/prepare_gr_data.py
- https://github.com/6lyc/RecHarness/blob/main/run2.sh
- https://github.com/6lyc/RecHarness/blob/main/gr.sh
- https://github.com/6lyc/RecHarness/blob/main/.env.example
- https://github.com/6lyc/RecHarness/blob/main/LICENSE

### Mine especially

- Thompson-style bandit routing
- modification arms
- composite arms
- mutex filtering
- local vs structural-jump arms
- jump-basin/stagnation detection
- posterior state
- experiment queue
- Experiment Skill memory
- isolated candidate workspaces
- baseline-first experiment protocol
- deterministic validation contracts
- promotion rules
- failed/OOM/timeout/protocol-invalid rejection
- compute-time budgets
- held-out final evaluation
- reproducible experiment logs/state snapshots

---

# 3. Kuaishou — SR-Agent

## 3.1 Paper / indexes

- https://arxiv.org/abs/2607.17719
- https://arxiv.org/pdf/2607.17719
- https://arxiv.org/html/2607.17719
- https://arxiv.org/e-print/2607.17719
- https://doi.org/10.48550/arXiv.2607.17719
- https://dblp.org/rec/journals/corr/abs-2607-17719
- https://www.researchgate.net/publication/410635911_SR-Agent_An_Experience-Driven_Agentic_Framework_for_Post-Ranking_Strategies_Refinement_in_E-Commerce_Recommendation
- https://www.themoonlight.io/review/sr-agent-an-experience-driven-agentic-framework-for-post-ranking-strategies-refinement-in-e-commerce-recommendation

### Mine especially

- UserSim staged inspection skills
- bad-case discovery
- Analysis Agent diagnosis consolidation
- reusable structured diagnoses
- typed/bounded strategy-action space
- retesting against known bad cases
- historical replay
- human verification gate
- online A/B gate
- automatic rollback
- experience/memory update

---

# 4. Direct self-evolving recommender comparators used around Kuaishou DoubleTake

## 4.1 Google / YouTube Self-Evolving Recommendation System

- https://arxiv.org/abs/2602.10226
- https://arxiv.org/pdf/2602.10226
- https://arxiv.org/html/2602.10226
- https://arxiv.org/e-print/2602.10226
- https://huggingface.co/papers/2602.10226
- https://dblp.org/rec/journals/corr/abs-2602-10226
- https://www.alphaxiv.org/abs/2602.10226
- https://daiwk.github.io/auto-research/reproductions/2602.10226-self-evolving-rec/

## 4.2 AgenticRecTune

- https://arxiv.org/abs/2604.26969
- https://arxiv.org/pdf/2604.26969
- https://arxiv.org/html/2604.26969
- https://arxiv.org/e-print/2604.26969

## 4.3 Self-EvolveRec

- https://arxiv.org/abs/2602.12612
- https://arxiv.org/pdf/2602.12612
- https://arxiv.org/html/2602.12612
- https://arxiv.org/e-print/2602.12612

## 4.4 MLEvolve

- https://arxiv.org/abs/2606.06473
- https://arxiv.org/pdf/2606.06473
- https://arxiv.org/html/2606.06473
- https://arxiv.org/e-print/2606.06473

## 4.5 A/B Agent — multimodal simulation/evaluation

- https://arxiv.org/abs/2601.04554
- https://arxiv.org/pdf/2601.04554
- https://arxiv.org/html/2601.04554
- https://arxiv.org/e-print/2601.04554
- https://doi.org/10.1145/3770854.3785688
- https://github.com/Applied-Machine-Learning-Lab/ABAgent
- https://scholars.cityu.edu.hk/en/publications/exploring-recommender-system-evaluation-a-multi-modal-llm-agent-f/
- https://www.alphaxiv.org/abs/2601.04554

---

# 5. Deepractice — organization / architecture hub

- https://github.com/Deepractice
- https://deepractice.ai/
- https://deepractice.ai/en/team
- https://docs.deepractice.ai/
- https://docs.deepractice.ai/en/
- https://business.deepractice.ai/
- https://deepractice.medium.com/
- https://www.npmjs.com/~deepracticexnpm

### Mine especially

- AgentVM stack
- DPML — Prompt Markup Language
- DARP — Agent Resource Protocol
- DATP — Agent Tool Protocol
- DAEP — Agent Event Protocol
- DASP — Agent Sandbox Protocol
- UIX — AI-to-UI intermediate representation

---

# 6. Deepractice DoubleTake — runtime / event system

## 6.1 Repository

- https://github.com/Deepractice/DoubleTake
- https://github.com/Deepractice/DoubleTake.git
- https://github.com/Deepractice/DoubleTake/blob/main/README.md
- https://github.com/Deepractice/DoubleTake/blob/main/README.zh-CN.md
- https://github.com/Deepractice/DoubleTake/blob/main/CLAUDE.md
- https://github.com/Deepractice/DoubleTake/blob/main/CONTRIBUTING.md
- https://github.com/Deepractice/DoubleTake/tree/main/bdd
- https://github.com/Deepractice/DoubleTake/tree/main/packages
- https://github.com/Deepractice/DoubleTake/tree/main/packages/doubletake
- https://github.com/Deepractice/DoubleTake/tree/main/packages/core
- https://github.com/Deepractice/DoubleTake/tree/main/packages/node-platform
- https://github.com/Deepractice/DoubleTake/tree/main/packages/mono-driver
- https://github.com/Deepractice/DoubleTake/tree/main/packages/claude-driver
- https://github.com/Deepractice/DoubleTake/tree/main/packages/devtools
- https://github.com/Deepractice/DoubleTake/commits/main
- https://github.com/Deepractice/DoubleTake/issues

## 6.2 npm / published implementation docs

- https://www.npmjs.com/org/doubletakejs
- https://www.npmjs.com/package/%40doubletakejs/agent
- https://www.npmjs.com/package/%40doubletakejs/core
- https://www.npmjs.com/package/%40doubletakejs/types
- https://www.npmjs.com/package/%40doubletakejs/node-platform
- https://www.npmjs.com/package/%40doubletakejs/mono-driver
- https://www.npmjs.com/package/%40doubletakejs/claude-driver
- https://www.npmjs.com/package/%40doubletakejs/devtools
- https://www.npmjs.com/package/%40doubletakejs/network

### Mine especially

- Prototype → Image → Agent separation
- local/server/remote identical API
- SystemBus / event-driven runtime
- RxJS pub/sub
- stream → state → message → turn event layers
- pure Mealy-machine event processing
- persistence/session/container boundaries
- SQLite repositories
- message queues / offsets
- WebSocket transport
- provider-independent Driver contract
- RoleX bridge/context refresh
- RecordingDriver / MockDriver / deterministic fixtures
- BDD/evaluation tooling

---

# 7. Deepractice AgentVM — lifecycle control plane

- https://github.com/Deepractice/AgentVM
- https://github.com/Deepractice/AgentVM/blob/main/README.md
- https://github.com/Deepractice/AgentVM/commits/main
- https://github.com/Deepractice/AgentVM/issues

### Mine especially

- HTTP agent lifecycle API
- create/manage agents
- sessions
- SSE streaming
- runtime/control-plane separation

---

# 8. Deepractice PromptX — cognitive memory / context / dynamic capability discovery

## 8.1 Product / documentation

- https://promptx.deepractice.ai/
- https://promptx.deepractice.ai/docs
- https://promptx.deepractice.ai/docs/quick-start
- https://promptx.deepractice.ai/docs/memory
- https://promptx.deepractice.ai/docs/toolx
- https://promptx.deepractice.ai/docs/roles
- https://promptx.deepractice.ai/download
- https://promptx.deepractice.ai/terms

## 8.2 Source

- https://github.com/Deepractice/PromptX
- https://github.com/Deepractice/PromptX.git
- https://github.com/Deepractice/PromptX/commits/main
- https://github.com/Deepractice/PromptX/issues
- https://github.com/Deepractice/promptx.deepractice.ai
- https://github.com/Deepractice/Research

## 8.3 Research paper / supplementary material

- https://research.deepractice.ai/
- https://research.deepractice.ai/PromptX_WWW26_Paper.pdf
- https://doi.org/10.1145/3774905.3793108
- https://scholars.cityu.edu.hk/en/publications/promptx-a-cognitive-agent-platform-with-long-term-memory/
- https://www.researchgate.net/publication/405420975_PromptX_A_Cognitive_Agent_Platform_with_Long-term_Memory
- https://drive.google.com/drive/folders/1wPhEQCKeaZIsQAcFnC7XKmXTtwY1gJL1?usp=sharing

### Mine especially

- PML / DPML structured agent context
- identity layer
- Context Assembler
- Engram memory units
- ATOMIC / LINK / PATTERN memory types
- activation-diffusion / spreading activation
- semantic graph memory
- working-memory Mind subgraph
- coarse recall → fine ranking
- strength / relevance / recency / type weighting
- Default Mode Network recall
- Recall Agent / Remember Agent
- Agent Context Protocol
- HATEOAS-inspired dynamic capability/tool discovery
- progressive context/resource disclosure

---

# 9. Deepractice prompt/context/memory design writings

- https://deepractice.ai/en/blog/dpml-design
- https://deepractice.ai/en/blog/ai-memory-fragments
- https://deepractice.ai/en/blog/why-rag-cannot-be-used-for-ai-memory
- https://deepractice.ai/en/blog/cognitive-prompt-paradigm
- https://deepractice.ai/en/blog/oes-framework
- https://deepractice.ai/en/blog/ai-task-state-machine
- https://deepractice.ai/en/blog/mcp-environment-positioning
- https://deepractice.ai/en/blog/agi-path-ai-organization
- https://deepractice.ai/en/blog/agent-cloud-production-function
- https://deepractice.ai/blog.html

---

# 10. Deepractice RoleX — persistent agent state / skills / experience

## 10.1 Source

- https://github.com/Deepractice/RoleX
- https://github.com/Deepractice/RoleX.git
- https://github.com/Deepractice/RoleX/blob/main/README.md
- https://github.com/Deepractice/RoleX/blob/main/README.zh-CN.md
- https://github.com/Deepractice/RoleX/commits/main
- https://github.com/Deepractice/RoleX/issues

## 10.2 Packages

- https://www.npmjs.com/package/rolexjs
- https://www.npmjs.com/package/%40rolexjs/core
- https://www.npmjs.com/package/%40rolexjs/system
- https://www.npmjs.com/package/%40rolexjs/parser
- https://www.npmjs.com/package/%40rolexjs/local-platform
- https://www.npmjs.com/package/%40rolexjs/mcp-server
- https://www.npmjs.com/package/%40rolexjs/cli

### Mine especially

- durable identity/state graph
- organization/position/capability relationships
- goal → plan → task lifecycle
- encounter → reflect → experience → principle/procedure lifecycle
- procedures vs skills vs resources
- progressive disclosure
- Gherkin as parseable/diffable/versionable state representation
- explicit stateless core API
- graph-backed runtime

---

# 11. Deepractice ResourceX — resource package/registry architecture

## 11.1 Source

- https://github.com/Deepractice/ResourceX
- https://github.com/Deepractice/ResourceX.git
- https://github.com/Deepractice/ResourceX/blob/main/README.md
- https://github.com/Deepractice/ResourceX/tree/main/apps/cli
- https://github.com/Deepractice/ResourceX/tree/main/apps/mcp-server
- https://github.com/Deepractice/ResourceX/tree/main/packages/resourcex
- https://github.com/Deepractice/ResourceX/tree/main/packages/server
- https://github.com/Deepractice/ResourceX/tree/main/packages/core
- https://github.com/Deepractice/ResourceX/tree/main/packages/node-provider
- https://github.com/Deepractice/ResourceX/tree/main/packages/arp
- https://github.com/Deepractice/ResourceX/tree/main/docs
- https://github.com/Deepractice/ResourceX/commits/main
- https://github.com/Deepractice/ResourceX/issues

## 11.2 Documentation paths

- https://github.com/Deepractice/ResourceX/blob/main/docs/tutorials/quick-start.md
- https://github.com/Deepractice/ResourceX/blob/main/docs/tutorials/first-resource.md
- https://github.com/Deepractice/ResourceX/blob/main/docs/tutorials/publish-resource.md
- https://github.com/Deepractice/ResourceX/blob/main/docs/guides/mcp-integration.md
- https://github.com/Deepractice/ResourceX/blob/main/docs/guides/development-workflow.md
- https://github.com/Deepractice/ResourceX/blob/main/docs/guides/versioning.md
- https://github.com/Deepractice/ResourceX/blob/main/docs/guides/self-hosting.md
- https://github.com/Deepractice/ResourceX/blob/main/docs/reference/cli.md
- https://github.com/Deepractice/ResourceX/blob/main/docs/reference/sdk.md
- https://github.com/Deepractice/ResourceX/blob/main/docs/reference/mcp-tools.md
- https://github.com/Deepractice/ResourceX/blob/main/docs/concepts/locators.md
- https://github.com/Deepractice/ResourceX/blob/main/docs/concepts/resource-types.md
- https://github.com/Deepractice/ResourceX/blob/main/docs/concepts/registry.md

## 11.3 Packages

- https://www.npmjs.com/package/resourcexjs
- https://www.npmjs.com/package/%40resourcexjs/core
- https://www.npmjs.com/package/%40resourcexjs/server
- https://www.npmjs.com/package/%40resourcexjs/mcp-server
- https://www.npmjs.com/package/%40resourcexjs/registry
- https://www.npmjs.com/package/%40resourcexjs/loader
- https://www.npmjs.com/package/%40resourcexjs/node-provider
- https://www.npmjs.com/package/%40resourcexjs/arp

### Mine especially

- Resource Definition / Identifier / Locator / Manifest / Archive / Resource primitives
- versioned AI-resource packaging
- content-addressable storage
- local/remote registry semantics
- read-through discovery
- resource resolution/execution
- MCP resource discovery/use/publish
- self-hosted registry

---

# 12. Deepractice SandboX — execution isolation + append-only replay

## 12.1 Source

- https://github.com/Deepractice/SandboX
- https://github.com/Deepractice/SandboX.git
- https://github.com/Deepractice/SandboX/blob/main/README.md
- https://github.com/Deepractice/SandboX/tree/main/packages/sandboxxjs
- https://github.com/Deepractice/SandboX/tree/main/packages/core
- https://github.com/Deepractice/SandboX/tree/main/packages/state
- https://github.com/Deepractice/SandboX/tree/main/packages/cli
- https://github.com/Deepractice/SandboX/commits/main
- https://github.com/Deepractice/SandboX/issues

## 12.2 Package

- https://www.npmjs.com/package/sandboxxjs

### Mine especially

- isolator abstraction
- local / OS-level / container isolation
- Node + Python execution contract
- filesystem/environment/KV state layer
- operation recording
- StateLog
- JSONL append-only persistence
- AOF pattern
- replay-based state reconstruction
- StateLog compaction
- deterministic sandbox initialization
- resource/time/memory/CPU limits

---

# 13. Deepractice UIX — normalized AI output / tool lifecycle

- https://github.com/Deepractice/UIX
- https://github.com/Deepractice/UIX.git
- https://github.com/Deepractice/UIX/blob/main/README.md
- https://github.com/Deepractice/UIX/commits/main
- https://github.com/Deepractice/UIX/issues
- https://www.npmjs.com/package/%40uix-ai/core
- https://www.npmjs.com/package/%40uix-ai/adapter-vercel
- https://www.npmjs.com/package/%40uix-ai/adapter-agui
- https://www.npmjs.com/package/%40uix-ai/adapter-a2ui
- https://www.npmjs.com/package/%40uix-ai/adapter-doubletake

### Mine especially

- stable AI-output intermediate representation
- anti-corruption adapters
- text/tool/thinking/image/file/error/source blocks
- explicit tool lifecycle states
- approval-required / approved / denied transitions
- backend-independent UI contract

---

# 14. Deepractice secondary repositories worth crawling

- https://github.com/Deepractice/ToolX
- https://github.com/Deepractice/RouterX
- https://github.com/Deepractice/IssueX
- https://github.com/Deepractice/Registry
- https://github.com/Deepractice/CommonX
- https://github.com/Deepractice/DoubleTakeDesktop
- https://github.com/Deepractice/PromptML
- https://github.com/Deepractice/Research
- https://github.com/Deepractice/promptx.deepractice.ai

---

# 15. Highest-priority assimilation order

1. https://arxiv.org/abs/2606.26859
2. https://arxiv.org/e-print/2606.26859
3. https://github.com/6lyc/RecHarness
4. https://github.com/6lyc/RecHarness/tree/main/gagc
5. https://arxiv.org/abs/2607.17719
6. https://github.com/Deepractice/DoubleTake
7. https://www.npmjs.com/org/doubletakejs
8. https://github.com/Deepractice/SandboX
9. https://github.com/Deepractice/PromptX
10. https://research.deepractice.ai/PromptX_WWW26_Paper.pdf
11. https://promptx.deepractice.ai/docs/memory
12. https://github.com/Deepractice/RoleX
13. https://github.com/Deepractice/ResourceX
14. https://github.com/Deepractice/AgentVM
15. https://github.com/Deepractice/UIX

