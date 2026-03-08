# ARIA

Linear-native agentic development with musical-themed AI agents.

ARIA (Agentic Reasoning & Implementation Architecture) brings 12 AI agent personas to [Linear](https://linear.app). Instead of writing artefacts to local files, agents create and manage Linear Projects (Epics), Issues (Stories), Cycles (Sprints), Milestones (Releases), and Documents (PRDs, architecture docs, UX designs) via Linear MCP tools. Built-in scrum practices include Fibonacci estimation, velocity tracking, sprint capacity planning, and backlog refinement.

**[Full Documentation](https://jacobwlms.github.io/ARIA/)**

## Quick Install

**One-liner (pipe to shell):**

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/JacobWLMS/ARIA/main/install.sh) /path/to/your/project
```

**Or clone and install:**

```bash
git clone https://github.com/JacobWLMS/ARIA.git
cd ARIA
./install.sh /path/to/your/project
```

Then: edit `_aria/linear/module.yaml`, set up the [Linear MCP server](https://jacobwlms.github.io/ARIA/getting-started/mcp-server-setup/), run `/aria-setup`, and `/aria-help`.

## Features

- **36 slash commands** -- type `/aria` in Claude Code and autocomplete to any workflow
- **12 musical agent personas** -- Cadence, Maestro, Lyric, Opus, Tempo, Riff, Pitch, Solo, Verse, Forte, Coda, Harmony
- **4-phase scrum workflow** -- Analysis, Planning, Solutioning, Implementation
- **Linear-native tracking** -- Projects, Issues, Cycles, Milestones, Documents
- **Scrum ceremonies** -- Fibonacci estimation, velocity tracking, sprint capacity, backlog refinement
- **Simplified setup** -- 3-4 essential questions, everything else auto-discovered
- **Workflow inheritance** -- DRY base config with shared includes
- **Configurable autonomy** -- interactive, balanced, or yolo mode
- **Automated orchestrator** -- polls Linear state and dispatches agents autonomously
- **Optional Git/GitHub integration** -- branches, commits, and PRs aligned with Linear issues
- **62 brainstorming techniques** -- comprehensive creative technique library
- **Structured handoffs** -- mandatory context passing between agents

## Slash Commands

Type `/aria` and autocomplete. Run `/aria-help` for context-aware guidance.

| Phase | Key Commands |
|---|---|
| Setup | `/aria-setup`, `/aria-git` |
| Analysis | `/aria-brief`, `/aria-brainstorm`, `/aria-research` |
| Planning | `/aria-prd`, `/aria-epics`, `/aria-ux` |
| Solutioning | `/aria-arch`, `/aria-ready` |
| Security | `/aria-threat`, `/aria-audit`, `/aria-secure` |
| Data | `/aria-data`, `/aria-pipeline`, `/aria-migrate` |
| Implementation | `/aria-dev`, `/aria-cr`, `/aria-sprint`, `/aria-story`, `/aria-test`, `/aria-retro` |
| Release | `/aria-release`, `/aria-cicd`, `/aria-deploy` |
| Quick Flow | `/aria-quick`, `/aria-quick-dev` |
| Advanced | `/aria-go`, `/aria-docs`, `/aria-critique`, `/aria-dash` |

[Full command reference](https://jacobwlms.github.io/ARIA/reference/slash-commands/)

## Linear ↔ Scrum Mapping

| Scrum Concept | Linear Entity | ARIA Tool |
|---|---|---|
| Epic | Project | `save_project` |
| Story | Issue | `save_issue` |
| Story Points | Estimate | `save_issue` with `estimate` |
| Sprint | Cycle | `list_cycles` |
| Release | Milestone | `save_milestone` |
| Dependency | blocks / blockedBy | `save_issue` with relations |

## Links

- [Documentation](https://jacobwlms.github.io/ARIA/)
- [BMAD-METHOD (upstream)](https://github.com/bmadcode/BMAD-METHOD)

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines. ARIA extends the [BMAD-METHOD](https://github.com/bmadcode/BMAD-METHOD) for Linear environments.

## License

MIT -- see [LICENSE](LICENSE) for details.
