# Orchestrator

The orchestrator (`/aria-go`) is an automated dispatch system that polls platform state and routes work to the correct agent. It is not an agent persona -- it is a system mechanism.

## How It Works

The orchestrator runs a continuous loop:

1. **Poll** -- Query the platform for current project state (documents, epics, work items, sprints, labels)
2. **Evaluate** -- Check dispatch rules in priority order against current state
3. **Dispatch** -- Launch the first matching agent with pre-loaded context
4. **Wait** -- Monitor for completion (handoff label or state change)
5. **Repeat** -- Return to step 1

## State Reader

Before evaluating rules, the orchestrator queries the platform to build a state snapshot:

| Query | What It Finds |
|---|---|
| `list_documents` | Which artefacts exist (brief, PRD, architecture, UX) |
| `list_projects` | Epic structure and status |
| `list_issues` with filters | Story states, labels, estimates, assignments |
| `list_cycles` | Active and upcoming sprints |
| Handoff labels | Which agent completed work last |
| Git state | Branch, PR, and merge status |

## Dispatch Rules

Rules are evaluated in priority order. The first matching rule triggers dispatch:

| Priority | Condition | Dispatches | Agent |
|---|---|---|---|
| 1 | Handoff label `aria-handoff-dev` on reviewed issue | Code Review | Pitch |
| 2 | Issues in "In Review" state | Code Review | Pitch |
| 3 | Issues in "Todo" or "Ready for Dev" | Dev Story | Riff |
| 4 | Unrefined stories (no estimate, missing context) | Create Story | Tempo |
| 5 | Stories in backlog, no active cycle | Sprint Planning | Tempo |
| 6 | Projects exist, readiness not validated | Implementation Readiness | Opus |
| 7 | Architecture exists, no projects | Create Epics & Stories | Maestro |
| 8 | PRD exists, no architecture | Create Architecture | Opus |
| 9 | PRD exists, no UX design | Create UX Design | Lyric |
| 10 | Brief exists, no PRD | Create PRD | Maestro |
| 11 | No brief exists | Create Brief | Cadence |

## Context Pre-Loading

Before dispatching an agent, the orchestrator pre-loads relevant context:

- Parses the most recent handoff comment for decisions, questions, and artefact references
- Loads referenced documents from the platform
- Passes structured context to the dispatched agent

This reduces redundant context discovery by each agent.

## Safety Rails

- **Max iterations** -- the orchestrator stops after a configurable number of dispatch cycles to prevent runaway loops
- **Cooldown** -- brief pause between dispatches to allow state to settle
- **Error handling** -- if a dispatched agent fails, the orchestrator logs the error and evaluates the next rule
- **Course corrections** -- always require user approval regardless of autonomy level

## Running the Orchestrator

```
/aria-go
```

The orchestrator respects the configured autonomy level:

- **interactive** -- asks before each dispatch
- **balanced** -- auto-dispatches when the next step is obvious, asks on ambiguous states
- **yolo** -- fully autonomous dispatch (except course corrections)
