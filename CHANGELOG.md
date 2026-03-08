# Changelog

## v2.0.0 — Multi-Platform Abstraction

### Added
- **Plane support** — full native MCP integration with 93 Plane tools
- **Platform abstraction layer** — core task dispatchers delegate to platform-specific implementations
- **platform.yaml** — per-platform tool mapping and terminology configuration
- **Work Item Properties** (Plane) — native custom fields replace label workarounds for locks, handoffs, agent tracking
- **Activity-driven polling** (Plane) — orchestrator uses `list_activities` for efficient state detection
- **Work Logs** (Plane) — agents log effort for velocity tracking
- **Intake queue** (Plane) — brainstorming ideas go to triage before backlog
- **Work Item Types** (Plane) — Story, Tech Spec, Bug, Spike, Review Finding
- 2 new core tasks: `log-work`, `create-intake`

### Changed
- **Directory restructure**: `src/linear/` → `src/core/` (platform-agnostic) + `src/platforms/{linear,plane}/` (platform-specific)
- All `workflow-linear.yaml` → `workflow.yaml`
- All `instructions-linear.md` → `instructions.md`
- All Linear MCP tool references in agents/workflows replaced with task invocations
- `linear_team_name` → `team_name`, `linear_team_id` → `team_id` throughout
- `install.sh` now prompts for platform selection (Plane or Linear)
- 17 core task dispatchers bridge agents to platform implementations

### Removed
- Direct MCP tool references from all core files (moved to platform-specific tasks)
- `src/linear/` directory (content split into `src/core/` and `src/platforms/linear/`)

## [1.1.0] - 2026-03-08

### Added
- **Forte (Security Engineer)** — New agent for threat modeling (STRIDE), security audits, and architecture security review. Slash commands: `/aria-threat`, `/aria-audit`, `/aria-secure`
- **Coda (DevOps & Release Engineer)** — New agent for release planning, CI/CD pipeline design, and deployment strategy. Slash commands: `/aria-release`, `/aria-cicd`, `/aria-deploy`
- **Harmony (Data Engineer)** — New agent for data modeling (ERD), pipeline design, and migration planning. Slash commands: `/aria-data`, `/aria-pipeline`, `/aria-migrate`
- **UX Design modes** — `/aria-ux` now auto-detects create, edit, or validate mode (like `/aria-prd`)
- UX design validation checklist
- Threat model template (STRIDE matrix, attack trees, data classification)
- Data model template (ERD, entity definitions, relationships, indexes)
- 9 new workflow directories with instructions

### Changed
- **Orchestrator overhaul** — `/aria-go` now delegates to subagents via Claude Code's Agent tool instead of loading agent personas into its own context. Prevents context drift and keeps the orchestrator lean.
- **Compact state reader** — Reduced from ~22 API calls to ~5 per orchestrator cycle by scanning a single `list_issues` result set in-memory
- **Code review ownership** — Pitch (QA) is now the canonical code review agent. Removed duplicate CR menu items from Dev (Riff) and Quick Flow (Solo).
- Agent count: 9 → 12 musical agents
- Slash command count: 27 → 36

### Fixed
- Orchestrator context bloat causing agent drift after 2-3 dispatch cycles

## 1.0.0 — Initial Release

ARIA (Agentic Reasoning & Implementation Architecture) — Linear-native agentic development with musical-themed AI agents.

### Features

- **27 slash commands** covering the full development lifecycle
- **9 musical agent personas** — Cadence (Analyst), Maestro (PM), Lyric (UX), Opus (Architect), Tempo (SM), Riff (Dev), Pitch (QA), Solo (Quick Flow), Verse (Tech Writer)
- **Linear-native output** — all artefacts stored as Linear Projects, Issues, Cycles, Milestones, and Documents
- **Scrum practices** — Fibonacci estimation (1, 2, 3, 5, 8, 13), sprint velocity tracking, capacity planning, backlog refinement
- **Workflow inheritance** — base workflow config with `inherits:` directive, shared includes for DRY instructions
- **Structured handoffs** — mandatory context passing between agents (decisions, open questions, artefact refs)
- **Simplified setup** — 3-4 essential questions, everything else auto-discovered from Linear
- **Optional Git/GitHub integration** — branches, commits, and PRs aligned with Linear issues
- **Automated orchestrator** (`/aria-go`) — polls Linear state and dispatches agents autonomously
- **Health check** (`/aria-doctor`) — validates MCP connection, configuration, and setup completeness
- **62 brainstorming techniques** across 11 categories
- **16 document templates** for PRDs, architecture, stories, research, and more
- **7 validation checklists** for quality gates
- **30-page documentation site** with getting started guide, agent reference, and workflow guide

### Linear ↔ Scrum Mapping

| Scrum | Linear | Tool |
|---|---|---|
| Epic | Project | `save_project` |
| Story | Issue | `save_issue` |
| Story Points | Estimate | `save_issue` with `estimate` |
| Sprint | Cycle | `list_cycles` |
| Release | Milestone | `save_milestone` |
| Dependency | blocks/blockedBy | `save_issue` with relations |

### Installation

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/JacobWLMS/ARIA/main/install.sh) /path/to/project
```
