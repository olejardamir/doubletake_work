# Historical herdr→Agent_X transfer hypotheses (distilled)

**Original blob:** `64b923c39039486088c274b3e3754cf4fda92abc`. The original https://github.com/ogulcancelik/herdr now redirects in GitHub connector; upstream version/license UNKNOWN. A separately inspected [motionharvest fork](https://github.com/motionharvest/herdr) describes terminal panes, detached sessions, status and socket API, but fork claims do not prove upstream features. Fork declares AGPL-3.0-or-later/commercial licensing; review rights before code reuse. [D01](DISTILLED_KNOWLEDGE.md).

**Candidate mechanisms:** governed issue→task→patch→test→promotion/rejection with event evidence; persistent workspace/pane/session and restart semantics; daemon/JSONL log/status UI/webhook intake; goal planning, handoff, recall, sparring, worktree/browser/tmux runners; capability/cost model routing; minimal HTTP bridge only where MCP is unnecessary. No duplicate DT planner, daemon, state store or authorization path.

**Test gate:** verify an actual current DT missing owner/consumer, then benchmark authorized isolated recovery, no-loss, access isolation and cost against baseline. **Unknown:** upstream exact API, license, current DT parity, permission and measured benefit. Not approved for porting.
