# ARIA

Multi-platform agentic development with musical-themed AI agents.

ARIA (Agentic Reasoning & Implementation Architecture) brings 12 AI agent personas to your project management platform. Instead of writing artefacts to local files, agents create and manage epics, stories, sprints, releases, and documents via platform MCP tools. Built-in scrum practices include Fibonacci estimation, velocity tracking, sprint capacity planning, and backlog refinement.

**Supported platforms:** [Plane](https://plane.so) (recommended), [Linear](https://linear.app)

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

The installer will prompt you to select your platform (Plane or Linear), then copy the appropriate files.

Then: edit `_aria/core/module.yaml`, set up the platform MCP server ([Linear](https://jacobwlms.github.io/ARIA/getting-started/mcp-server-setup/) or Plane), run `/aria-setup`, and `/aria-help`.

## Features

- **36 slash commands** -- type `/aria` in Claude Code and autocomplete to any workflow
- **12 musical agent personas** -- Cadence, Maestro, Lyric, Opus, Tempo, Riff, Pitch, Solo, Verse, Forte, Coda, Harmony
- **4-phase scrum workflow** -- Analysis, Planning, Solutioning, Implementation
- **Multi-platform support** -- Plane and Linear with shared core logic
- **Scrum ceremonies** -- Fibonacci estimation, velocity tracking, sprint capacity, backlog refinement
- **Simplified setup** -- 3-4 essential questions, everything else auto-discovered
- **Workflow inheritance** -- DRY base config with shared includes
- **Configurable autonomy** -- interactive, balanced, or yolo mode
- **Automated orchestrator** -- polls platform state and dispatches agents autonomously
- **Optional Git/GitHub integration** -- branches, commits, and PRs aligned with platform issues
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

## Supported Platforms

| Platform | Entity Mapping |
|---|---|
| **Plane** | Epics, Work Items (stories), Cycles (sprints), Milestones (releases), Pages (docs) |
| **Linear** | Projects (epics), Issues (stories), Cycles (sprints), Milestones (releases), Documents (docs) |

## Links

- [Documentation](https://jacobwlms.github.io/ARIA/)
- [BMAD-METHOD (upstream)](https://github.com/bmadcode/BMAD-METHOD)

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines. ARIA extends the [BMAD-METHOD](https://github.com/bmadcode/BMAD-METHOD) for multi-platform environments.

## License

MIT -- see [LICENSE](LICENSE) for details.
