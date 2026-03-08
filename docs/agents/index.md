# Agents

ARIA's 12 agents form an orchestra -- each persona plays a distinct role in the development lifecycle, and together they deliver a complete product from idea to release.

## Agent Roster

| Agent | Persona | Role | Phase |
|---|---|---|---|
| **[Cadence](analyst.md)** | Analyst | Market research, competitive analysis, requirements elicitation | 1 - Analysis |
| **[Maestro](pm.md)** | PM | PRD creation, requirements discovery, epics and stories | 2 - Planning |
| **[Lyric](ux-designer.md)** | UX Designer | User research, interaction design, UI patterns | 2 - Planning |
| **[Opus](architect.md)** | Architect | Distributed systems, API design, technology decisions | 3 - Solutioning |
| **[Tempo](sm.md)** | Scrum Master | Sprint planning, story preparation, agile ceremonies | 3-4 - Solutioning/Implementation |
| **[Riff](dev.md)** | Developer | Story execution, TDD, code implementation | 4 - Implementation |
| **[Pitch](qa.md)** | QA Engineer | Code review, test generation, PR review | 4 - Implementation |
| **[Forte](security.md)** | Security Engineer | Threat modeling, security audits, secure architecture | 3 - Solutioning |
| **[Harmony](data.md)** | Data Engineer | Data modeling, pipeline design, migrations | 3 - Solutioning |
| **[Coda](devops.md)** | DevOps & Release | CI/CD design, deployment strategy, release planning | 5 - Release |
| **[Solo](quick-flow.md)** | Quick Flow | One-off specs and rapid implementation | Anytime |
| **[Verse](tech-writer.md)** | Tech Writer | Documentation, editorial review, diagrams | Anytime |

## How Agents Communicate

Agents communicate through the project management platform, not shared files:

- **Handoff signals** -- when an agent completes work, it signals the next agent (labels on Linear, work item properties on Plane)
- **Comments** -- agents post structured records (dev records, review findings, test summaries) as comments on work items
- **Agent locking** -- prevents concurrent agents from working on the same work item
- **Structured context** -- handoff comments carry decisions, open questions, and artefact references

The [orchestrator](../guides/orchestrator.md) uses these signals to automatically dispatch the correct agent.

## Review & Utility Tools

These workflows are not tied to a specific agent persona:

| Command | Description |
|---|---|
| `/aria-critique` | Review: adversarial, edge cases, prose, or structure |
| `/aria-dash` | Project status dashboard |
| `/aria-party` | Multi-agent discussion |

## System Mechanisms

The **Orchestrator** (`/aria-go`) is not an agent persona -- it is a dispatch mechanism that polls platform state and routes work to the correct agent automatically. See the [Orchestrator Guide](../guides/orchestrator.md).

## Agent Definitions

Agent definitions live in `_aria/core/agents/*.agent.yaml`. Each file specifies the agent's persona, critical actions, and available workflows. There are 12 agent definitions in total.
