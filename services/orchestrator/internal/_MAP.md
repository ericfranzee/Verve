# services/orchestrator/internal/ — Structure Map

## Purpose
Go Orchestrator internal modules handling circuit breaking, redis session state and websocket connections.

## Directories

| Directory | Responsibility |
|------|---------------|
| circuit/ | Contains `breaker.go` (and tests) providing the closed/open/half-open Circuit Breaker implementation |
| session/ | Contains `manager.go` managing concurrent state mapping directly connected to a Redis backend |
| server/ | Contains `server.go` which links circuit, session, and WS routing |

## Data Flow
Flutter Client -> WS /server/ -> [session] (Recovery) -> [circuit] (Proxy downstream to Intent Engine)
