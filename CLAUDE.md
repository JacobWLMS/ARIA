# ARIA

# ARIA: Multi-Platform Agentic Development

ARIA (Agentic Reasoning & Implementation Architecture) is an opinionated agentic development method with multi-platform support (Linear, Plane). It follows agile/scrum practices using each platform's native entities for epics, stories, sprints, releases, and documents. All output goes to the selected platform, never to local files.

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
| `/aria-critique` | RV | -- | Review: adversarial / edges / prose / structure |
| `/aria-dash` | PD | -- | Project Dashboard |
| `/aria-party` | PMD | -- | Party Mode |
| `/aria-go` | ORC | Orchestrator | Auto-dispatch agents |
| `/aria-setup` | FS | -- | Set up platform team & labels |
| `/aria-git` | FG | -- | Set up Git/GitHub integration |
| `/aria-doctor` | DC | -- | Health check (MCP, config, version) |
| `/aria-help` | AH | -- | Help & next steps |

## Key Files

- **Agent definitions:** `_aria/core/agents/*.agent.yaml`
- **Base critical actions:** `_aria/core/agents/base-critical-actions.yaml`
- **Configuration:** `_aria/core/module.yaml`
- **Base workflow config:** `_aria/core/workflows/base-workflow.yaml`
- **Shared includes:** `_aria/core/workflows/includes/`
- **Artefact mapping:** `_aria/core/artefact-mapping.yaml`
- **Key map:** `_aria/core/data/.key-map.yaml`
- **Reusable tasks (core):** `_aria/core/tasks/`
- **Workflows:** `_aria/core/workflows/`
- **Orchestrator:** `_aria/core/orchestrator/`
- **Platform-specific tasks:** `_aria/platform/tasks/`
- **Platform config:** `_aria/platform/platform.yaml`
- **Platform orchestrator:** `_aria/platform/orchestrator/`
- **Platform marker:** `_aria/.platform` (text file: "linear" or "plane")
- **Shared templates:** `_aria/shared/templates/`
- **Shared checklists:** `_aria/shared/checklists/`
- **Version:** `_aria/core/VERSION`

## Scrum Workflow

```
Product Brief -> PRD -> UX Design -> Architecture -> Epics & Stories
    |
Sprint Planning (capacity check) -> Backlog Refinement (estimation)
    |
Story Prep -> Dev -> Code Review -> QA -> Done
    |
Sprint Retrospective (velocity tracking) -> Next Sprint
```

## Critical Rules

1. **All output to platform** -- never write artefacts to local files
2. **Platform detection** -- read `_aria/.platform` marker file to determine the active platform (linear or plane) and load the corresponding platform.yaml
3. **Team/workspace required** -- all platform MCP tool calls need the team or workspace name from module.yaml
4. **Lock before work** -- invoke `lock-work-item` task before modifying any issue
5. **State changes** -- use the platform-appropriate method for state transitions (Linear: `save_issue` with `state`; Plane: state update API)
6. **Structured handoffs** -- invoke `post-handoff` task with mandatory `context_details` (decisions, open questions, artefact refs)
7. **Read context first** -- use `read-context` task; use `handoff_context` type to inherit previous agent's decisions
8. **Key map** -- use `_aria/core/data/.key-map.yaml` for all ARIA-to-platform ID lookups
9. **Estimate stories** -- use Fibonacci story points (1, 2, 3, 5, 8, 13)
10. **Track dependencies** -- use platform-appropriate dependency/relation mechanisms
11. **Git is recommended** -- git operations gated on `git_enabled`; git failures never block platform operations
12. **Autonomy levels** -- derived from `user_skill_level` (beginner->interactive, intermediate->balanced, expert->yolo). Course corrections always require approval.
13. **Workflow inheritance** -- all workflow YAMLs inherit from `base-workflow.yaml`; only declare unique fields
14. **Parallel agents** -- when `parallel_agents` is enabled in module.yaml, the orchestrator dispatches concurrent agents using Claude Code's Agent tool with `run_in_background` and `isolation: "worktree"`. Git-touching workflows (dev, code-review) get worktree isolation; platform-only workflows (story prep) don't. Max 3 concurrent agents. Issue locks prevent conflicts.
