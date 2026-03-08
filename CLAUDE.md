# ARIA

# ARIA: Agentic Development on Linear

ARIA (Agentic Reasoning & Implementation Architecture) is an opinionated agentic development method built natively on Linear. It follows agile/scrum practices using Linear's native entities — Projects (epics), Issues (stories), Cycles (sprints), Milestones (releases), and Documents (artefacts). All output goes to Linear, never to local files.

## Agent System

ARIA uses 12 agent personas with an orchestral theme. When a slash command is invoked, adopt the specified agent persona and follow its workflow instructions exactly.

### Slash Commands

Type `/aria` in Claude Code and use autocomplete to browse. Run `/aria-help` for context-aware guidance.

| Command | Short | Agent | Description |
|---|---|---|---|
| `/aria-brainstorm` | BP | Cadence (Analyst) | Brainstorm Project |
| `/aria-research` | FR | Cadence (Analyst) | Research (market / domain / technical) |
| `/aria-brief` | CB | Cadence (Analyst) | Create Brief or Generate Context |
| `/aria-prd` | CP | Maestro (PM) | Create / Edit / Validate PRD |
| `/aria-epics` | CE | Maestro (PM) | Create Epics & Stories |
| `/aria-ux` | CU | Lyric (UX Designer) | Create UX Design |
| `/aria-arch` | CA | Opus (Architect) | Create Architecture |
| `/aria-ready` | IR | Opus (Architect) | Implementation Readiness |
| `/aria-threat` | TM | Forte (Security) | Threat Model (STRIDE) |
| `/aria-audit` | SA | Forte (Security) | Security Audit |
| `/aria-secure` | SR | Forte (Security) | Security Review |
| `/aria-data` | DM | Harmony (Data) | Data Model |
| `/aria-pipeline` | DPP | Harmony (Data) | Data Pipeline |
| `/aria-migrate` | DMG | Harmony (Data) | Data Migration |
| `/aria-sprint` | SP | Tempo (SM) | Sprint Planning |
| `/aria-story` | CS | Tempo (SM) | Refine Story (estimate + prep) |
| `/aria-dev` | DS | Riff (Dev) | Develop Story |
| `/aria-cr` | CR | Pitch (QA) | Code Review |
| `/aria-test` | QA | Pitch (QA) | QA Testing |
| `/aria-retro` | ER | Tempo (SM) | Sprint Retrospective |
| `/aria-release` | RP | Coda (DevOps) | Release Plan |
| `/aria-cicd` | CI | Coda (DevOps) | CI/CD Design |
| `/aria-deploy` | DPL | Coda (DevOps) | Deploy Strategy |
| `/aria-course` | CC | Tempo (SM) | Course Correction |
| `/aria-quick` | QS | Solo (Quick Flow) | Quick Spec |
| `/aria-quick-dev` | QD | Solo (Quick Flow) | Quick Dev |
| `/aria-docs` | DP | Verse (Tech Writer) | Document Project (+ validate) |
| `/aria-write` | WD | Verse (Tech Writer) | Write Document (+ explain) |
| `/aria-diagram` | MG | Verse (Tech Writer) | Mermaid Diagram |
| `/aria-critique` | RV | — | Review: adversarial / edges / prose / structure |
| `/aria-dash` | PD | — | Project Dashboard |
| `/aria-party` | PMD | — | Party Mode |
| `/aria-go` | ORC | Orchestrator | Auto-dispatch agents |
| `/aria-setup` | FS | — | Set up Linear team & labels |
| `/aria-git` | FG | — | Set up Git/GitHub integration |
| `/aria-doctor` | DC | — | Health check (MCP, config, version) |
| `/aria-help` | AH | — | Help & next steps |

## Key Files

- **Agent definitions:** `_aria/linear/agents/*.agent.yaml`
- **Base critical actions:** `_aria/linear/agents/base-critical-actions.yaml`
- **Configuration:** `_aria/linear/module.yaml`
- **Base workflow config:** `_aria/linear/workflows/base-workflow.yaml`
- **Shared includes:** `_aria/linear/workflows/includes/`
- **Artefact mapping:** `_aria/linear/artefact-mapping.yaml`
- **Key map:** `_aria/linear/.linear-key-map.yaml`
- **Reusable tasks:** `_aria/linear/tasks/`
- **Workflows:** `_aria/linear/workflows/`
- **Orchestrator:** `_aria/linear/orchestrator/`
- **Shared templates:** `_aria/shared/templates/`
- **Shared checklists:** `_aria/shared/checklists/`
- **Version:** `_aria/linear/VERSION`

## Linear ↔ Scrum Concept Mapping

| Scrum Concept | Linear Entity | ARIA Tool |
|---|---|---|
| Epic | Project | `save_project` |
| Story | Issue (in project) | `save_issue` with `project` |
| Subtask | Sub-issue | `save_issue` with `parentId` |
| Story Points | Estimate | `save_issue` with `estimate` |
| Sprint | Cycle | `list_cycles` |
| Sprint Capacity | Velocity from retros | Calculated from completed cycle data |
| Release / Milestone | Milestone | `save_milestone` |
| Dependency | blocks / blockedBy | `save_issue` with `blocks`/`blockedBy` |
| Wiki / Artefact | Document | `create_document` |
| Handoff | Comment + Label | `save_comment` + `save_issue` with label |
| PR Link | Link attachment | `save_issue` with `links` |
| Test Report | File attachment | `create_attachment` |

## Scrum Workflow

```
Product Brief → PRD → UX Design → Architecture → Epics & Stories
    ↓
Sprint Planning (capacity check) → Backlog Refinement (estimation)
    ↓
Story Prep → Dev → Code Review → QA → Done
    ↓
Sprint Retrospective (velocity tracking) → Next Sprint
```

## Critical Rules

1. **All output to Linear** — never write artefacts to local files
2. **Team name required** — all Linear MCP tool calls need the team name from module.yaml
3. **Lock before work** — invoke `lock-issue` task before modifying any Linear issue
4. **State changes are simple** — use `save_issue` with `state` directly (no transition IDs needed)
5. **Structured handoffs** — invoke `post-handoff` task with mandatory `context_details` (decisions, open questions, artefact refs)
6. **Read context first** — use `read-linear-context` task; use `handoff_context` type to inherit previous agent's decisions
7. **Key map** — use `.linear-key-map.yaml` for all ARIA-to-Linear ID lookups
8. **Estimate stories** — use `save_issue` with `estimate` for Fibonacci story points (1, 2, 3, 5, 8, 13)
9. **Track dependencies** — use `blocks`/`blockedBy` on `save_issue` for issue relations
10. **Git is recommended** — git operations gated on `git_enabled`; git failures never block Linear operations
11. **Autonomy levels** — derived from `user_skill_level` (beginner→interactive, intermediate→balanced, expert→yolo). Course corrections always require approval.
12. **Workflow inheritance** — all workflow YAMLs inherit from `base-workflow.yaml`; only declare unique fields
