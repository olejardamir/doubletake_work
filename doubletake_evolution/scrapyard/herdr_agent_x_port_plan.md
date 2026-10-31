# Agent_X Port Plan — herdr

## Source Repository

https://github.com/ogulcancelik/herdr

## What Should Be Ported to Agent_X, in Development Order

1. **Governed vertical execution loop**
   - GitHub issue → governed Agent_X task → implementation/patch proposal → validation → promotion or rejection.
   - Preserve logs, evidence, tests, and review artifacts for every run.

2. **Terminal pane, session, and workspace abstractions**
   - Independent agent panes.
   - Persistent/detached sessions.
   - Restart-surviving workspaces.
   - Programmatic pane creation, output reading, lifecycle control, and coordination.

3. **Daemon mode and persistent orchestration**
   - Long-running Agent_X daemon.
   - Per-client/per-task workspaces.
   - JSONL event log.
   - Monitoring TUI.
   - Chat/webhook adapter layer for external task intake.

4. **Reusable agent execution modules**
   - Goal planner.
   - Handoff pack.
   - Session recall.
   - Agent sparring.
   - Worktree runner.
   - Browser runner.
   - tmux runner.

5. **GitHub intake layer**
   - Convert GitHub issues, pull requests, and discussions into typed Agent_X tasks.
   - Route those tasks through the governed execution loop rather than directly to coding agents.

6. **Model registry and routing**
   - Registry of available models and capabilities.
   - Capability-aware model selection.
   - Cost-aware routing.
   - Task-specific model assignment.

7. **Simple HTTP tool bridge**
   - Lightweight HTTP tool/interface specification alongside MCP.
   - Use it for integrations where MCP would be unnecessarily heavy.
