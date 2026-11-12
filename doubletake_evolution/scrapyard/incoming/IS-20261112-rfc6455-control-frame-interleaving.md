# IS-20261112-RFC6455 — WebSocket fragmented-message control-frame interleaving

Status: NEW_PUBLIC_SOURCE_CANDIDATE / NOT_IMPLEMENTED / PRIVATE_DT_PARITY_UNKNOWN
Source: IETF RFC 6455, December 2011, §§5.4–5.5.3, https://www.rfc-editor.org/rfc/rfc6455
Primary text: directly read 2026-11-12. RFC 6455 has later updates RFC 7936/8307/8441; this candidate concerns base framing clauses, not extension-specific behavior.
Rights: © 2011 IETF Trust and authors; BCP 78/IETF Trust Legal Provisions. Paraphrase only, no code or normative text copied.

## Narrow independent clause
When a WebSocket data message is fragmented, Ping/Pong/Close control frames can occur between fragments and must be processed without treating them as message data or waiting for message completion. Control frames must not be fragmented and must have payload length <=125 bytes. Without an applicable negotiated extension, fragments of distinct data messages cannot interleave. The final FIN fragment determines message completion; control-frame receipt or TCP close does not establish application-task completion.

## Hypothetical future DT applicability
Only if a future authorized coder establishes a WebSocket-framing consumer or adapter and a real missing behavior. This is not a claim that DT uses WebSockets or has a defect. Candidate integration seam: frame-to-tool-event adapter or WebSocket transport parser, **hypothesis only**. Do not implement a new transport just to satisfy this research candidate.

## Falsifiable synthetic tests (NOT EXECUTED)
P1: text fragment FIN=0, Ping, continuation FIN=1: process Ping/Pong promptly, assemble original text exactly once; no early tool-result completion.
P2: unfragmented data message accepted with identical application payload.
N1: fragmented control frame rejected; N2: control payload >125 bytes rejected; N3: second data message begins before first FIN without negotiated interleaving extension: reject; N4: missing final FIN followed by transport EOF: no complete-message success; N5: Close after partial message: no false application success; N6: unsolicited Pong must not count as operation acknowledgement.
Negative authorization: untrusted wire events cannot authorize tool execution, mutate protected state or assert mission completion. Use disposable synthetic fixtures; validate exact owner-approved transport and permission boundaries.

## Deduplication and uncertainty
Public implementation_prompts/INDEX.md blob e51366e98177af58b014d60339049a23aff8428a checked; existing DT-IP-0018 semantic termination, DT-IP-0023 digest integrity, DT-IP-0039 tool-effect completeness, DT-IP-0048 agent transport, DT-IP-0049 bounded operating protocol are adjacent but do not specify the RFC 6455 fragmented-data/control-frame interleaving invariant. Targeted public repository searches for 'WebSocket fragmentation', 'control frames' and 'Last-Event-ID' returned no matches; this is not proof of absence. Complete canonical research cluster review and applicable public WebSocket consumer remain UNKNOWN. This candidate is distinct from RFC 7464 JSON-sequence truncation and WHATWG SSE blank-line dispatch.

Transfer disposition: CONDITIONAL_RESEARCH_ONLY. Transformer independently verifies canonical overlap and applicability before any future prompt. Private DT implementation parity UNKNOWN; no code, tests, private repository access or worker changes.
