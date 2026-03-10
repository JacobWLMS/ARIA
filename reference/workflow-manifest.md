# Workflow Manifest

Complete catalog of ARIA workflows with their orchestrator integration details.

## Phase 0 -- Quick Flow

| Workflow | Command | Agent | Detection |
|---|---|---|---|
| Quick Spec | `/aria-quick` | Solo | Issues with label `aria-quick-flow` in Backlog |
| Quick Dev | `/aria-quick-dev` | Solo | Issues with label `aria-quick-flow` in Todo |

## Phase 1 -- Analysis

| Workflow | Command | Agent | Detection |
|---|---|---|---|
| Brainstorming | `/aria-brainstorm` | Cadence | No brainstorming document exists |
| Research | `/aria-research` | Cadence | Research requested but no document exists |
| Product Brief | `/aria-brief` | Cadence | No product brief document exists |
| Project Context | `/aria-brief context` | Cadence | Context generation requested |
| Document Project | `/aria-docs` | Verse | Documentation requested for existing project |

## Phase 2 -- Planning

| Workflow | Command | Agent | Detection |
|---|---|---|---|
| Create PRD | `/aria-prd` | Maestro | Brief exists but no PRD |
| Edit PRD | `/aria-prd edit` | Maestro | PRD exists and edit requested |
| Validate PRD | `/aria-prd validate` | Maestro | PRD validation requested |
| Create UX Design | `/aria-ux` | Lyric | PRD exists but no UX design |

## Phase 3 -- Solutioning

| Workflow | Command | Agent | Detection |
|---|---|---|---|
| Create Architecture | `/aria-arch` | Opus | PRD exists but no architecture |
| Create Epics & Stories | `/aria-epics` | Maestro | Architecture exists but no projects |
| Implementation Readiness | `/aria-ready` | Opus | Projects exist, readiness not validated |

## Phase 4 -- Implementation

| Workflow | Command | Agent | Detection |
|---|---|---|---|
| Sprint Planning | `/aria-sprint` | Tempo | Stories exist in backlog |
| Create Story | `/aria-story` | Tempo | Unrefined stories in backlog |
| Dev Story | `/aria-dev` | Riff | Stories in Todo or Ready for Dev |
| Code Review | `/aria-cr` | Pitch | Stories in In Review |
| QA Testing | `/aria-test` | Pitch | Stories reviewed, tests needed |
| Retrospective | `/aria-retro` | Tempo | Cycle complete, retro not done |
| Course Correction | `/aria-course` | Tempo | Blocker or major change detected |

## Orchestrator

The orchestrator (`/aria-go`) uses the detection column to determine which workflow to dispatch next. It polls platform state, evaluates rules in priority order, and dispatches the first matching agent. See the [Orchestrator Guide](../guides/orchestrator.md).
