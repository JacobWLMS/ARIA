# ARIA

**Linear-native agentic development with musical-themed AI agents.**

ARIA (Agentic Reasoning & Implementation Architecture) brings 12 AI agent personas to Linear. Instead of writing artefacts to local files, agents create and manage Linear Projects (Epics), Issues (Stories), Cycles (Sprints), Milestones (Releases), and Documents via Linear MCP tools.

---

## What It Does

ARIA guides your project through a structured 5-phase scrum workflow:

1. **Analysis** -- Cadence brainstorms ideas, creates product briefs and research as Linear Documents
2. **Planning** -- Maestro creates PRDs and defines Epics & Stories in Linear; Lyric creates UX design docs
3. **Solutioning** -- Opus creates architecture decisions; Forte performs security reviews; Harmony models data; Maestro validates implementation readiness
4. **Implementation** -- Tempo manages sprints with capacity planning; Riff implements code; Pitch reviews and tests
5. **Release** -- Coda plans releases, designs CI/CD pipelines, and defines deployment strategies

An automated **orchestrator** polls Linear state to determine which agent should work next, enabling autonomous project progression.

---

## Key Features

- **36 slash commands** -- type `/aria` in Claude Code and autocomplete to any workflow
- **12 musical agent personas** -- each with distinct capabilities, communication styles, and workflows
- **Linear-native tracking** -- Projects, Issues, Cycles, Milestones, and Documents managed via MCP tools
- **Scrum practices** -- Fibonacci estimation, velocity tracking, sprint capacity, backlog refinement
- **Structured handoffs** -- mandatory context passing with decisions, questions, and artefact references
- **Automated orchestrator** -- polls Linear state and dispatches agents autonomously
- **Optional Git/GitHub integration** -- branches, commits, and PRs aligned with Linear issues
- **Simplified setup** -- 3-4 essential questions, everything else auto-discovered

---

## Quick Start

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/JacobWLMS/ARIA/main/install.sh) /path/to/your/project
```

Or clone and install:

```bash
git clone https://github.com/JacobWLMS/ARIA.git
cd ARIA
./install.sh /path/to/your/project
```

Then:

1. Run `/aria-setup` to auto-discover your Linear team and configure statuses
2. Run `/aria-git` to configure Git/GitHub integration (optional)
3. Run `/aria-help` to get started

[Get Started :material-arrow-right:](getting-started/index.md){ .md-button .md-button--primary }

---

## Links

- [GitHub Repository](https://github.com/JacobWLMS/ARIA)
- [BMAD-METHOD (upstream)](https://github.com/bmadcode/BMAD-METHOD)
