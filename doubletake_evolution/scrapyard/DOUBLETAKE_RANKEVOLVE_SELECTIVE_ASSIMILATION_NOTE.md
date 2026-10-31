# RankEvolve: A Reliable Multi-Agent Auto-Research Harness for Evolving Ranking Models

**Authors:** Zheng Chen, Linfeng Liu, Hong Li, Hong Yan  
**Organization:** Meta  
**Paper:** arXiv:2609.39551

# What We Want to Take From This Paper for DoubleTake

This is **not** a plan to port RankEvolve wholesale.

The goal is to selectively assimilate the mechanisms that would make DoubleTake's long-running coding, research, and self-improvement work more reliable, reproducible, and externally enforced rather than dependent on an LLM remembering a long prompt.

## 1. Executable Operating Protocols

The most important idea to investigate is RankEvolve's **Executable Operating Protocol (EOP)** approach.

DoubleTake currently uses large mission `.md` files to tell coding agents what loop to follow, what gates matter, what to verify, and when to stop. The agent still has to read and correctly follow those instructions.

We want to explore turning suitable DoubleTake mission files into **machine-enforced executable protocols**.

Desired direction:

`mission / procedure -> compiled execution graph -> DoubleTake runtime`

The runtime, rather than the agent, should enforce things such as:

- phases;
- dependencies;
- gates;
- branches;
- retries;
- loops;
- budgets;
- mandatory validation;
- tool requirements;
- evidence requirements;
- stop conditions.

The LLM or coding agent should perform the work inside a phase, but should not control the overall protocol merely by remembering instructions.

The purpose is to reduce long-horizon instruction drift and make DoubleTake evolution loops reproducible.

## 2. Canonical Coding-Product Node

RankEvolve treats complete coding products as execution nodes rather than treating everything as a raw model call.

DoubleTake already has pieces for Codex, OpenCode, Claude Code, providers, agent orchestration, permissions, evidence, retries, and parallel execution.

We want to investigate whether these should converge on a **single canonical coding-product contract**.

Conceptually:

`DoubleTake -> CodingProduct -> {Codex, OpenCode, Claude Code, future products}`

A coding-product execution should expose a common governed interface for inputs and outputs such as:

- task/objective;
- repository/workspace snapshot;
- allowed capabilities/tools;
- authority and permission limits;
- resource budget;
- prior artifacts/context;
- resulting patch/artifacts;
- execution trace;
- resource usage;
- terminal/failure state.

This should extend existing DoubleTake provider/orchestration architecture rather than create a parallel framework.

## 3. Heterogeneous Review and Repair

RankEvolve shows value in having different coding products cross-check one another.

We want DoubleTake to investigate a generalized bounded workflow such as:

`propose -> independent review -> repair -> re-review -> accept/refuse`

The important idea is **not** simply "use more agents."

DoubleTake should measure whether two agents/products have sufficiently different failure modes for cross-review to justify the additional cost.

Where useful, a candidate implementation created by one coding product could be reviewed or repaired by another.

The mechanism should remain:

- budget-aware;
- bounded;
- governed;
- evidence-backed;
- optional when expected value is low.

## 4. Product Complementarity Learning

DoubleTake should learn from evidence which coding products or agent configurations complement each other.

For example, instead of permanently hard-coding:

`Codex -> Claude review`

DoubleTake should eventually be able to learn patterns such as:

- product A frequently catches product B's structural errors;
- product B is better at a certain repository/task class;
- A+B provides little additional value for another class;
- cross-review costs more than it saves for simple tasks.

This can become part of DoubleTake's existing learning/evolution machinery.

## 5. Execution-Accuracy Benchmarking

RankEvolve's evaluation methodology is particularly valuable.

We want a DoubleTake-native benchmark constructed from **real defects, failures, regressions, and silent mistakes that DoubleTake or its coding agents have previously produced**.

The benchmark should compare execution strategies under matched conditions, for example:

- single coding product;
- DoubleTake-governed coding product;
- heterogeneous review/repair;
- multi-agent composition.

Comparisons should control for:

- task;
- repository snapshot;
- model/product access;
- tools;
- resource budget;
- stopping criteria;
- evaluation oracle.

The benchmark should measure whether DoubleTake actually improves execution reliability rather than relying only on architectural completeness or test count.

## 6. Negative Results and Failure Knowledge

RankEvolve explicitly retains negative results.

DoubleTake already has substantial learning, retained alternatives, knowledge, evidence, and memory infrastructure, so we should **not add another knowledge system**.

Instead, investigate whether existing DoubleTake learning should more systematically retain:

- failed approaches;
- rejected candidate changes;
- why a repair did not work;
- which product/agent failed on which class of task;
- when multi-agent review added no value;
- incidents involving leakage, invalid evaluation, or misleading success.

Negative results should prevent repeated mistakes but must remain subordinate to canonical governance and measured evidence.

## 7. Knowledge Reconciliation

RankEvolve also motivates reconciling contradictory knowledge gathered across iterations.

DoubleTake should investigate whether its existing knowledge/lesson systems need stronger mechanisms for:

- detecting contradictory lessons;
- identifying stale findings;
- distinguishing environment-specific from transferable findings;
- resolving conflicts using newer or stronger evidence;
- preserving provenance rather than overwriting history.

This should extend existing DoubleTake knowledge infrastructure rather than introduce a replacement.

# What We Do NOT Want

Do not:

- port RankEvolve wholesale;
- create another standalone orchestration subsystem;
- create another independent memory/knowledge system;
- duplicate DoubleTake's existing Borg/Collective, project-evolution, meta-reasoning, provider, evidence, artifact, or governance systems;
- hard-code Codex/Claude/OpenCode as permanent architecture;
- assume multi-agent execution is automatically better;
- allow an LLM to bypass protocol, governance, budget, verification, or stop conditions;
- optimize specifically for ranking-model research.

RankEvolve should be treated as a **source of mechanisms**, not as DoubleTake's new architecture.

# Intended DoubleTake Outcome

The desired result is:

**DoubleTake should be able to turn high-level evolution/coding missions into governed executable procedures, run them across interchangeable coding products, use heterogeneous review only when valuable, preserve negative knowledge, and measure whether the resulting process is actually more reliable under matched resources.**

In short:

**Make the process of improving DoubleTake itself more executable, enforceable, measurable, and reliable.**

# When We Return To This

Before implementation:

1. Re-read the current RankEvolve paper.
2. Re-inspect current DoubleTake `main`.
3. Map each mechanism above to existing DoubleTake components.
4. Delete everything already implemented sufficiently.
5. Identify only the true incremental gaps.
6. Produce a DoubleTake-native implementation mission for those gaps.
7. Require production-path evidence and matched-budget validation.
