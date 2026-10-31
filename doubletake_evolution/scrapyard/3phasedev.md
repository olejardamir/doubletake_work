# DoubleTake — Research assimilation plan

I would treat this as a research-driven evolutionary assimilation mission, not a conventional integration project.

The objective is to make DoubleTake discover, understand, reproduce, adapt and, where possible, surpass the useful mechanisms in each paper. The papers and their GitHub repositories should be treated as complementary evidence: the paper explains the mechanism; the repository shows how the authors implemented it.

I checked DoubleTake's GitHub repository and confirmed that its architecture separates the L0 governed seed kernel, L1 evolution/controller governance, and L2 specialization planning. Assimilation must preserve those boundaries rather than import entire third-party agent frameworks into the core.

## 1. Research inventory and priorities

The inventory covers the papers discussed previously, with their code status verified where possible.

| Research                    | Primary role                               | Priority |
| --------------------------- | ------------------------------------------ | -------- |
| SEAGym                      | Ground: evolutionary evaluation            | P0       |
| ACE                         | Inward: knowledge curation                 | P0       |
| EvolveR                     | Inward: experience consolidation           | P0       |
| Darwin Gödel Machine        | Outward: recursive self-improvement        | P0       |
| GEPA                        | Outward + Ground: reflective optimization  | P0       |
| Voyager                     | Outward: skill discovery and reuse         | P1       |
| AlphaEvolve                 | Outward + Ground: algorithm discovery      | P1       |
| POET                        | Outward: open-ended challenge generation   | P1       |
| ContinualSkillBench         | Ground: skill-transfer evaluation          | P1       |
| SkillEvolBench              | Ground: skill-evolution evaluation         | P1       |
| EvoAgentX                   | Outward + Inward: workflow optimization    | P1       |
| Adaptive Operator Selection | Controller: evolutionary scheduling        | P1       |
| Theory of Agent             | Architecture: internal/external boundaries | P2       |

P0 means investigate first, not automatically implement. P1 means investigate after foundational evidence and integration contracts are established. P2 is primarily conceptual.

The following gives the specific assimilation work for every source.

## 2. Detailed assimilation instructions

### P0 — Highest-priority research

1\. SEAGym — Evaluation Environment for Self-Evolving LLM Agents

Ground

[Paper](https://arxiv.org/abs/2606.17546) · [GitHub source](https://github.com/antropy-research/SEAGym)

Assimilate: Its evaluation lifecycle: training exposure, frozen validation, held-out in-distribution and out-of-distribution tests, replay for forgetting, and cost/reliability tracking.

Repository work: Study the evaluation engine, checkpoint management, configuration schemas, metric collection and deterministic example. Build DT-native adapters for the existing L1 evidence system rather than replacing its gates.

Required proof: An evolutionary change must demonstrate transferable gains without unacceptable forgetting, increased cost or reliability regressions. Separate the evaluator from the agents generating mutations.

Restriction: SEAGym does not itself approve or roll back evolutionary changes. Its full research reproduction depends on additional services; begin with its deterministic, dependency-light tests.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://github.com\&sz=32)

antropy-research/SEAGym · GitHub



2\. ACE — Agentic Context Engineering

Inward

[Paper](https://arxiv.org/abs/2510.04618) · [GitHub source](https://github.com/ace-agent/ace)

Assimilate: Generator–Reflector–Curator processing, incremental playbook updates, structured knowledge preservation and protection against context collapse.

Repository work: Examine the playbook representation, curation routines, localized update operations and evaluation procedures.

DT adaptation: Develop an evidence-linked knowledge consolidator that recognizes duplicate strategies, resolves contradictions, preserves important details and selects relevant knowledge without endlessly expanding the working context.

Required proof: Compare accumulated knowledge before and after consolidation using previously unseen tasks. Measure retained coverage, factual integrity, token cost and success rate.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://github.com\&sz=32)

GitHub



3\. EvolveR — Experience-Driven Self-Evolution

Inward

[ICML 2026 paper](https://proceedings.mlr.press/v306/wu26bf.html) · [GitHub source](https://github.com/KnowledgeXLab/EvolveR)

Assimilate: Self-distillation from successful and failed trajectories, semantic deduplication, empirical utility scoring, retrieval and principle pruning.

Repository work: Examine trajectory-to-principle extraction, experience maintenance, retrieval and the paper's experiments.

DT adaptation: Convert execution histories into versioned reusable strategies. Track where each strategy came from, when it helps, when it fails and whether it remains useful. Prune underperforming strategies reversibly.

Required proof: Strategies must improve held-out performance compared with both no-memory and raw-trajectory reuse, without silently losing useful behavior.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://github.com\&sz=32)

GitHub

+1



4\. Darwin Gödel Machine — Open-Ended Self-Improvement

Outward

[Paper](https://arxiv.org/abs/2505.22954) · [Original GitHub source](https://github.com/jennyzzt/dgm)

Assimilate: Self-modifying agents, evolutionary lineages, archived alternatives, empirical selection and using past variants as stepping stones.

Repository work: Study `DGM_outer.py`, `self_improve_step.py`, coding-agent implementations and benchmark integration. Use `jennyzzt/dgm` as the original source, rather than the fork linked previously.

DT adaptation: Maintain a lineage graph for candidate evolutionary controllers and capabilities. Record parent versions, modifications, evaluation results, checkpoints and descendant performance. Permit controlled evolution of the controller itself.

Required proof: A successor must improve both task performance and the ability to generate useful subsequent improvements under comparable budgets. It must not acquire permission to bypass L0/L1 governance.

Restriction: The authors explicitly warn about executing untrusted model-generated code. Test mutations in isolated, resource-limited environments.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://github.com\&sz=32)

GitHub



5\. GEPA — Reflective Prompt Evolution

Outward + Ground

[Paper](https://arxiv.org/abs/2507.19457) · [GitHub source](https://github.com/gepa-ai/gepa)

Assimilate: Reflection-guided mutations, feedback-based search, Pareto candidate selection and reuse of high-performing candidates.

Repository work: Analyze candidate representations, reflection feedback, optimization loops, objective aggregation and adapter interfaces.

DT adaptation: Introduce a candidate evolutionary operator for prompts, tool-use strategies and workflow configurations. Use Pareto selection to preserve useful alternatives rather than collapse everything into one scalar score.

Required proof: Compare against DT's existing mutation process at equal model-call and evaluation budgets. Measure success, cost, robustness and candidate diversity.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://github.com\&sz=32)

GitHub



### P1 — Additional high-value research

6\. Voyager — Open-Ended Embodied Agent

[Paper](https://arxiv.org/abs/2305.16291) · [GitHub source](https://github.com/MineDojo/Voyager)

Assimilate: Automatic curriculum generation, novelty-driven exploration, reusable executable skills and feedback-based improvement.

Repository work: Focus on the curriculum, `skill_library`, skill retrieval and self-verification. Do not import the Minecraft environment or GPT-4 dependency.

DT adaptation: Add a capability-gap-driven discovery mechanism that creates learning tasks and promotes reusable skills only after evaluation. Test whether its curriculum finds new capabilities that DT's existing discovery mechanism misses.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://github.com\&sz=32)

GitHub



7\. AlphaEvolve — Scientific and Algorithmic Discovery

[Paper](https://arxiv.org/abs/2506.13131) · [Results and verification repository](https://github.com/google-deepmind/alphaevolve_results)

Assimilate: Executable candidate generation, automated evaluators, evolutionary populations, objective comparisons and iterative algorithm improvement.

Repository work: Examine the released mathematical results and correctness-checking code as examples of evaluator design.

DT adaptation: Improve DT's ability to propose competing algorithmic changes and use executable evidence to select among them. Retain diverse candidate families.

Important: The released results repository explicitly does not contain the full AlphaEvolve engine. Do not treat it as an implementation of the agent.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://arxiv.org\&sz=32)

arxiv.org

+1



8\. POET — Paired Open-Ended Trailblazer

[Paper](https://arxiv.org/abs/1901.01753) · [GitHub source](https://github.com/uber-research/poet)

Assimilate: Co-evolution of challenges and solutions, environmental diversity, challenge difficulty selection and transfer between evolutionary lineages.

Repository work: Study the population manager, challenge generation, viability filtering and transfer logic, including the Enhanced POET implementation.

DT adaptation: Make DT generate new evaluation challenges based on demonstrated capability boundaries, rather than relying only on fixed benchmarks.

Required proof: Generated challenges must be meaningful, solvable and independently validated. Prevent agents from modifying their own final acceptance tests.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://github.com\&sz=32)

GitHub



9\. ContinualSkillBench — Can LLM Agents Truly Evolve Their Capabilities?

[Paper](https://arxiv.org/abs/2608.03874) · [GitHub tasks and harness](https://github.com/gtynnn060110-hash/continual-skill-bench-final)

Assimilate: Sequential skill-learning tests, retention measurement, cross-task reuse and comparison between explicit skills and in-context adaptation.

Repository work: Inspect task construction, Harbor-based execution, sequential agents, verification data and trajectory logging.

DT adaptation: Add a continual-learning evaluation track to distinguish genuine reusable capabilities from temporary context adaptation.

Required proof: Measure improvements across long task sequences with and without persistent skill storage.

Caution: The paper describes five domains, while the available repository includes six domain directories. Pin the source revision and reconcile the exact evaluated task inventory before claiming reproduction.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://arxiv.org\&sz=32)

arxiv.org

+1



10\. SkillEvolBench — Episodic Experience to Procedural Skills

[Paper](https://arxiv.org/abs/2605.24117) · [GitHub source](https://github.com/AIoT-MLSys-Lab/SkillEvolBench)

Assimilate: Experience-to-skill conversion, frozen deployment evaluation, contextual transfer, resistance to shortcuts and skill composition.

Repository work: Examine `benchmark/tasks`, baseline policies, skill stores, verification assets and reporting code.

DT adaptation: Add tests comparing no skill, raw historical trajectories, learned skills and curated skills. Freeze evolved skills before transfer evaluations.

Required proof: A learned skill must survive context changes and compose with other skills. Simply performing better on the same tasks is insufficient.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://arxiv.org\&sz=32)

arxiv.org

+1



11\. EvoAgentX — Automated Evolution of Agentic Workflows

[Paper](https://arxiv.org/abs/2507.03616) · [GitHub source](https://github.com/ANative-Lab/EvoAgentX)

Assimilate: Workflow graph generation, automatic refinement of agent configurations, topology optimization and modular evaluation.

Repository work: Inspect workflow abstractions, evolutionary optimizers, evaluation layers and optimizer adapters, including the TextGrad, AFlow and MIPRO integrations described by the paper.

DT adaptation: Represent eligible multi-agent workflows as evolvable graphs, allowing proposals to change delegation, sequencing, branching and tool assignment.

Required proof: Compare candidate workflows on equivalent tasks, accounting for execution cost, agent count, reliability and errors. Do not import its whole orchestration stack.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://arxiv.org\&sz=32)

arxiv.org

+1



12\. Adaptive Operator Selection for Meta-Heuristics: A Survey

[IEEE 2025 paper](https://doi.org/10.1109/TAI.2025.3545792) · GitHub: no official accompanying implementation verified.

Assimilate: The taxonomy of stateless and state-based operator selection, reward attribution and adaptive search policies.

DT adaptation: Make the three-phase controller learn which phase or evolutionary operator should receive more resources based on novelty, stagnation, utility, risk and improvement history.

Required proof: Compare adaptive scheduling with fixed rotation and uniform allocation on the same missions. Grounding checks must remain mandatory, regardless of phase scheduling.

Code treatment: Reconstruct selected algorithms from the paper and their cited primary sources, rather than claim the survey has a reference implementation.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://scholars.ln.edu.hk\&sz=32)

Lingnan Scholars



### P2 — Conceptual research

13\. Theory of Agent — The Science of Internalization and Externalization for LLM-Based Agents

[September 2026 preprint](https://www.preprints.org/manuscript/202609.0308) · No independently verified accompanying executable repository.

Assimilate: The distinction between capabilities embedded in a model and capabilities externalized into memory, tools, workflow and agent infrastructure.

DT adaptation: Build an architecture-placement evaluator that decides whether a capability belongs in persistent memory, a reusable tool, a workflow, an external service or another approved component. Include accuracy, latency, resource requirements, update frequency and operational risk.

Required proof: Demonstrate that placement decisions improve cost/performance or reliability without changing protected architecture boundaries.

This is primarily theoretical guidance, not a ready-made software module.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://www.preprints.org\&sz=32)

Preprints.org



## 3. How DoubleTake should assimilate papers and GitHub code

The process should be the same for every paper, even when a specific research project lacks source code.

### Research-to-evolution pipeline

1\. Acquire

Retrieve paper, code and supporting artifacts

2\. Inspect

Verify provenance, license, dependencies and methods

3\. Reproduce

Run a minimal original experiment when feasible

4\. Translate

Describe the useful mechanism as a DT-native specification

5\. Evolve

Generate competing improvements using the active evolutionary controller

6\. Validate

Run isolated, independent and held-out tests

7\. Promote or reject

Accept measured gains; otherwise retain the research evidence

### Specific implementation rules

1\. Automatically acquire research sources. Download publicly accessible papers and clone their repositories into a temporary, isolated research workspace. Record the paper version, Git commit SHA, URL, license and checksums. Clean temporary files after extracting the needed, verified artifacts. Failed downloads must not be reported as successful.

2\. Use both paper and code. The paper describes the intended method; the code can expose details, assumptions and discrepancies. Compare them. Reproduce at least a small experiment where practical, using mock data or existing DT infrastructure.

3\. Do not blindly import projects. No wholesale framework replacement, uncontrolled dependencies or model downloads. Preserve the requirement to use open-code models without forcing a particular model provider into DoubleTake. If a reproduction needs unavailable services, mark it as unreproduced and separately test a DT-native implementation.

4\. Detect existing equivalents. Before proposing changes, identify whether DT already possesses that functionality. Strengthen the existing implementation when appropriate; avoid creating competing capability registries, memory systems, controllers or governance mechanisms.

5\. Use all three evolutionary pressures. Outward proposes innovations, inward consolidates and simplifies, and ground verifies the outcome. A research source may contribute to several pressures, but it does not get to bypass any mandatory acceptance conditions.

6\. Require measured improvements. Every candidate needs a baseline, fixed-resource comparison, applicable quality and security checks, held-out evaluation and rollback path. Record failed experiments and reasons for rejection as reusable research evidence.

7\. Preserve future evolutionary succession. New mechanisms should participate through versioned contracts, so a superior future controller can replace the current three-phase strategy without requiring all research integrations to be rewritten.

## 4. Recommended implementation sequence

I would not launch thirteen independent missions simultaneously. Several papers overlap, and implementing them independently would create duplication.

Instead, organize assimilation into five connected work packages.

| Order | Research package           | Sources                                                | Intended result                                                     |
| ----- | -------------------------- | ------------------------------------------------------ | ------------------------------------------------------------------- |
| 1     | Evolutionary evidence      | SEAGym, ContinualSkillBench, SkillEvolBench            | Stronger evaluation and promotion evidence                          |
| 2     | Knowledge consolidation    | ACE, EvolveR                                           | More effective inward evolution                                     |
| 3     | Recursive discovery        | Darwin Gödel Machine, GEPA, Voyager, AlphaEvolve, POET | More capable outward evolution                                      |
| 4     | Workflow and phase control | EvoAgentX, Adaptive Operator Selection                 | Improved evolutionary resource allocation and multi-agent workflows |
| 5     | Architectural optimization | Theory of Agent                                        | More efficient placement of learned capabilities                    |

This is the logical implementation order, not a requirement to implement everything within each package. Each candidate must independently earn promotion.

The crucial distinction is that DoubleTake should assimilate the mechanisms, not the identity or architecture of the source agents. Git repositories are reproducible research references; DT-native implementations remain governed by DoubleTake.

### Final recommendation

All thirteen sources merit examination, but not all thirteen should necessarily result in new production code.

I would make the first assimilation milestone SEAGym, ACE and EvolveR, followed by Darwin Gödel Machine and GEPA. This gives DT a better way to measure improvements, preserve valuable experience and generate new evolutionary candidates before expanding into the remaining research.

The expected outcome is not thirteen integrations. It is a smaller, coherent set of proven improvements that strengthens DoubleTake's existing evolutionary system without unnecessary complexity or regressions.
