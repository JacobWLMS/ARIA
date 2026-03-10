<div align="center">

```
 █████╗ ██████╗ ██╗ █████╗
██╔══██╗██╔══██╗██║██╔══██╗
███████║██████╔╝██║███████║
██╔══██║██╔══██╗██║██╔══██║
██║  ██║██║  ██║██║██║  ██║
╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═╝
```

**Agentic Reasoning & Implementation Architecture**

Multi-platform agentic development with musical-themed AI agents for [Claude Code](https://claude.ai/claude-code).

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-2.0.0-green.svg)](CHANGELOG.md)
[![Platforms](https://img.shields.io/badge/platforms-Plane%20%7C%20Linear-purple.svg)](#supported-platforms)

[Documentation](https://jacobwlms.github.io/ARIA/) · [Getting Started](#quick-start) · [Commands](#slash-commands) · [Agents](#agents)

</div>

---

## What is ARIA?

ARIA brings 12 AI agent personas to your project management platform. Each agent has a distinct musical identity, specialized capabilities, and structured workflows. Instead of writing artefacts to local files, agents create and manage epics, stories, sprints, releases, and documents directly on **Plane** or **Linear** via native MCP tools.

An automated orchestrator polls platform state to determine which agent should work next, enabling fully autonomous project progression from idea to deployment.

---

## Why ARIA?

- **Cross-phase context retrieval** — any agent can pull artefacts from any phase at any time. The dev reads the architect's rationale. QA checks the PRD's acceptance criteria. Security reviews the data model. Every decision made earlier in the lifecycle is available to every agent later — no context is ever lost between phases.
- **No context switching** — agents read from and write to your project management platform directly
- **Structured methodology** — 5-phase scrum workflow with built-in quality gates and handoffs
- **Platform-native** — uses Plane/Linear MCP tools for zero-latency integration, not REST APIs
- **Autonomous orchestration** — agents hand off work to each other with full context preservation
- **Extensible** — task-based abstraction layer makes adding new platforms straightforward

---

## Features

| Feature | Description |
|---|---|
| **38 slash commands** | Type `/aria` in Claude Code and autocomplete to any workflow |
| **12 agent personas** | Musical-themed agents with distinct capabilities and communication styles |
| **5-phase workflow** | Analysis → Planning → Solutioning → Implementation → Release |
| **Multi-platform** | Plane (recommended) and Linear with shared core logic |
| **Scrum practices** | Fibonacci estimation, velocity tracking, sprint capacity, backlog refinement |
| **Automated orchestrator** | Polls platform state and dispatches agents autonomously |
| **Cross-phase memory** | Any agent can retrieve artefacts from any phase — architecture informs dev, PRD informs QA, nothing is lost |
| **Structured handoffs** | Mandatory context passing with decisions, questions, and artefact references |
| **Git/GitHub integration** | Branches, commits, and PRs aligned with work items (optional) |
| **Configurable autonomy** | Interactive, balanced, or fully autonomous modes |
| **62 brainstorming techniques** | Comprehensive creative technique library for ideation |

---

## Agents

| Icon | Name | Role | Capabilities |
|---|---|---|---|
| 🎵 | **Cadence** | Analyst | Brainstorming, market/domain/technical research, product briefs |
| 🎼 | **Maestro** | Product Manager | PRDs, epic & story creation, requirements validation |
| 🎨 | **Lyric** | UX Designer | User research, interaction design, UI patterns |
| 🏛️ | **Opus** | Architect | Architecture decisions, tech stack selection, system design |
| 🛡️ | **Forte** | Security Engineer | Threat modeling, OWASP analysis, security audits |
| 📊 | **Harmony** | Data Engineer | ERD design, ETL/ELT pipelines, data migration |
| ⏱️ | **Tempo** | Scrum Master | Sprint planning, story preparation, retrospectives |
| 💻 | **Riff** | Developer | Story implementation, TDD, code delivery |
| 🔍 | **Pitch** | QA Engineer | Code review, test generation, quality assurance |
| 🚀 | **Coda** | DevOps Engineer | Release planning, CI/CD design, deployment strategy |
| 🏎️ | **Solo** | Quick Flow Dev | Rapid specs and implementation for one-off tasks |
| ✍️ | **Verse** | Tech Writer | Documentation, diagrams, technical explanations |

---

## Quick Start

### Operating Systems

| OS | Status | Install Method |
|---|---|---|
| **macOS** | Fully supported | Pipe-to-shell or clone |
| **Linux** | Fully supported | Pipe-to-shell or clone |
| **Windows (WSL)** | Fully supported | Pipe-to-shell or clone (inside WSL) |
| **Windows (native)** | Supported | Clone and install via Git Bash |

ARIA is pure YAML + Markdown — no compilation, no native dependencies. It runs wherever Claude Code runs. The installer requires a bash-compatible shell (`bash`, `zsh`, Git Bash).

### Prerequisites

- [Claude Code](https://claude.ai/claude-code) CLI installed
- A [Plane](https://plane.so) or [Linear](https://linear.app) account
- The corresponding MCP server configured in Claude Code

### Install

**AI Agent Install (any AI coding tool):**

Paste this into Claude Code, Cursor, Cline, Windsurf, or any AI coding tool:

> Read the instructions at https://raw.githubusercontent.com/JacobWLMS/ARIA/main/agent-install.md and follow them to install ARIA into this project.

**Shell install:**

```bash
# Install to current directory (default)
curl -fsSL https://raw.githubusercontent.com/JacobWLMS/ARIA/main/install.sh | bash

# Install to a specific directory
curl -fsSL https://raw.githubusercontent.com/JacobWLMS/ARIA/main/install.sh | bash -s -- /path/to/project

# Install for a specific AI tool (default: claude-code)
curl -fsSL https://raw.githubusercontent.com/JacobWLMS/ARIA/main/install.sh | bash -s -- --tool cursor
```

**Or clone and install:**

```bash
git clone https://github.com/JacobWLMS/ARIA.git
cd ARIA
./install.sh                          # install to current dir
./install.sh /path/to/project         # install to specific dir
./install.sh --tool cursor            # install for Cursor
./install.sh --tool all               # install for all supported tools
```

The installer prompts you to select your platform (Plane or Linear), then copies the appropriate files to `_aria/` in your project.

### Setup

```bash
# 1. Auto-discover your team and configure workflow states
/aria-setup

# 2. Configure Git/GitHub integration (optional)
/aria-git

# 3. Get context-aware guidance on what to do next
/aria-help
```

---

## Slash Commands

Type `/aria` in Claude Code and use autocomplete. Run `/aria-help` for context-aware guidance.

| Phase | Commands | Description |
|---|---|---|
| **Setup** | `/aria-setup`, `/aria-git`, `/aria-doctor` | Platform discovery, Git config, health check |
| **Analysis** | `/aria-brief`, `/aria-brainstorm`, `/aria-research` | Product briefs, ideation, market/domain/tech research |
| **Planning** | `/aria-prd`, `/aria-epics`, `/aria-ux` | PRDs, epic & story creation, UX design |
| **Solutioning** | `/aria-arch`, `/aria-ready` | Architecture decisions, implementation readiness |
| **Security** | `/aria-threat`, `/aria-audit`, `/aria-secure` | Threat models, security audits, architecture review |
| **Data** | `/aria-data`, `/aria-pipeline`, `/aria-migrate` | Data modeling, ETL pipelines, migration plans |
| **Implementation** | `/aria-sprint`, `/aria-story`, `/aria-dev`, `/aria-cr`, `/aria-test`, `/aria-status` | Sprint planning, story prep, development, review, QA, status |
| **Release** | `/aria-release`, `/aria-cicd`, `/aria-deploy` | Release plans, CI/CD design, deployment strategy |
| **Quick Flow** | `/aria-quick`, `/aria-quick-dev` | Rapid spec and implementation for one-off tasks |
| **Reviews** | `/aria-critique`, `/aria-docs`, `/aria-write`, `/aria-diagram` | Adversarial review, documentation, diagrams |
| **Orchestration** | `/aria-go`, `/aria-dash`, `/aria-help` | Auto-dispatch, project dashboard, guidance |

[Full command reference →](https://jacobwlms.github.io/ARIA/reference/slash-commands/)

---

## Supported Platforms

ARIA uses a platform abstraction layer — core agents and workflows are platform-agnostic, with platform-specific task implementations for each supported platform.

| Capability | Plane | Linear |
|---|---|---|
| Work items (stories) | ✅ Native | ✅ Native |
| Epics (grouping) | ✅ Modules | ✅ Projects |
| Sprints | ✅ Cycles | ✅ Cycles |
| Documents | ✅ Pages | ✅ Documents |
| Milestones/Releases | ✅ Initiatives | ✅ Milestones |
| Comments | ✅ Native | ✅ Native |
| Labels | ✅ Native | ✅ Native |
| Relations/Dependencies | ✅ Native | ✅ Native |
| Custom Properties | ✅ Work Item Properties | ❌ Uses labels |
| Time Tracking | ✅ Work Logs | ❌ Comment fallback |
| Activity Feed | ✅ Activities API | ❌ Polling |
| Intake/Triage Queue | ✅ Intake | ❌ Backlog fallback |
| Custom Work Item Types | ✅ Native | ❌ Uses labels |
| Workflow State Management | ✅ `create_state` | ✅ `list_issue_statuses` |

---

## Supported AI Tools

ARIA's agents, workflows, and templates are tool-agnostic. The installer generates the appropriate config for your AI coding tool.

| Tool | Support | Install Flag | Features |
|---|---|---|---|
| **[Claude Code](https://claude.ai/claude-code)** | Full | `--tool claude-code` (default) | 38 slash commands, orchestrator, subagent spawning |
| **[Cursor](https://cursor.com)** | Core | `--tool cursor` | All workflows via `.cursor/rules/` |
| **[Windsurf](https://windsurf.com)** | Core | `--tool windsurf` | All workflows via `.windsurf/rules/` |
| **[Cline](https://cline.bot) / Roo Code** | Core | `--tool cline` | All workflows via `.clinerules/` |
| **Other** | Manual | — | Install `_aria/`, reference workflow index manually |

**Full** = orchestrator can autonomously dispatch agents via subagent spawning (Claude Code exclusive). **Core** = all individual agent workflows work; tell the agent which workflow to run (e.g., "Run the brainstorm workflow").

---

## Architecture

```
src/
├── core/                    # Platform-agnostic
│   ├── agents/              # 12 agent YAMLs + base critical actions
│   ├── workflows/           # All workflow YAMLs + instructions
│   ├── orchestrator/        # Agent dispatch rules
│   ├── tasks/               # 17 generic task dispatchers
│   ├── data/                # Key map template, workflow manifest
│   ├── artefact-mapping.yaml
│   └── module.yaml          # Project configuration
├── platforms/
│   ├── linear/              # Linear MCP implementations
│   │   ├── platform.yaml    # Tool mapping + capabilities
│   │   ├── discovery.md     # Team/status setup
│   │   ├── tasks/           # 17 Linear-specific task files
│   │   └── orchestrator/    # Linear state reader
│   └── plane/               # Plane MCP implementations
│       ├── platform.yaml    # Tool mapping + capabilities
│       ├── discovery.md     # Workspace/project setup
│       ├── tasks/           # 17 Plane-specific task files
│       └── orchestrator/    # Activity-driven state reader
└── shared/                  # Templates, checklists, data files
```

**How it works:** Agents invoke generic task dispatchers in `core/tasks/`. Each dispatcher reads the `_aria/.platform` marker file and delegates to the corresponding implementation in `platforms/{linear,plane}/tasks/`. Platform-specific files contain the actual MCP tool calls.

---

## Configuration

After installation, configure ARIA via `_aria/core/module.yaml`:

| Setting | Description | Default |
|---|---|---|
| `project_name` | Your project name | Directory name |
| `team_name` | Platform team/project | Auto-discovered |
| `platform` | `plane` or `linear` | Set by installer |
| `user_skill_level` | `beginner`, `intermediate`, `expert` | `intermediate` |
| `autonomy_level` | `interactive`, `balanced`, `yolo` | Derived from skill |
| `git_enabled` | Enable Git/GitHub integration | `true` |

See [Configuration Reference →](https://jacobwlms.github.io/ARIA/reference/configuration/)

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines. ARIA extends the [BMAD-METHOD](https://github.com/bmadcode/BMAD-METHOD) for multi-platform environments.

## Credits

- [BMAD-METHOD](https://github.com/bmadcode/BMAD-METHOD) — upstream methodology by [@bmadcode](https://github.com/bmadcode)
- [Plane](https://plane.so) — open-source project management
- [Linear](https://linear.app) — streamlined issue tracking
- [Claude Code](https://claude.ai/claude-code) — AI coding assistant by Anthropic

## License

MIT — see [LICENSE](LICENSE) for details.
