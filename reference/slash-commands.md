# Slash Commands

Type `/aria` in Claude Code and autocomplete to browse all commands. Run `/aria-help` for context-aware guidance.

!!! note "Using a different AI tool?"
    Slash commands are Claude Code's native trigger mechanism. In Cursor, Windsurf, or Cline, describe the workflow you want instead (e.g., "Run the brainstorm workflow"). See [Supported AI Tools](../guides/ai-tools.md) for details.

## Setup

| Command | Code | Agent | Description |
|---|---|---|---|
| `/aria-setup` | FS | -- | Select platform, auto-discover team, statuses, and labels |
| `/aria-git` | FG | -- | Configure Git/GitHub integration |
| `/aria-doctor` | DC | -- | Health check: validate MCP, config, version |

## Phase 1 -- Analysis

| Command | Code | Agent | Description |
|---|---|---|---|
| `/aria-brainstorm` | BP | Cadence | Generate ideas through interactive brainstorming (62 techniques) |
| `/aria-research` | FR | Cadence | Market, domain, or technical research |
| `/aria-brief` | CB | Cadence | Create product brief or generate project context |

## Phase 2 -- Planning

| Command | Code | Agent | Description |
|---|---|---|---|
| `/aria-prd` | CP | Maestro | Create, edit, or validate PRD (auto-detects mode) |
| `/aria-ux` | CU | Lyric | Create UX design specification |
| `/aria-epics` | CE | Maestro | Create Epics and Stories |

## Phase 3 -- Solutioning

| Command | Code | Agent | Description |
|---|---|---|---|
| `/aria-arch` | CA | Opus | Create architecture decision document |
| `/aria-ready` | IR | Opus | Validate implementation readiness across all artefacts |
| `/aria-threat` | TM | Forte | STRIDE-based threat model with trust boundaries and mitigations |
| `/aria-audit` | SA | Forte | Code and dependency security audit with OWASP mapping |
| `/aria-secure` | SR | Forte | Security architecture review with findings |
| `/aria-data` | DM | Harmony | ERD and schema design with relationships and indexes |
| `/aria-pipeline` | DPP | Harmony | Data pipeline design with scheduling and error handling |
| `/aria-migrate` | DMG | Harmony | Data migration plan with rollback and validation |

## Phase 4 -- Implementation

| Command | Code | Agent | Description |
|---|---|---|---|
| `/aria-sprint` | SP | Tempo | Sprint planning with capacity checks |
| `/aria-story` | CS | Tempo | Refine story with Fibonacci estimation |
| `/aria-dev` | DS | Riff | Implement the next story with status tracking |
| `/aria-cr` | CR | Pitch | Code review with findings posted as comments |
| `/aria-test` | QA | Pitch | Generate tests for reviewed stories |
| `/aria-retro` | ER | Tempo | Sprint retrospective with velocity tracking |
| `/aria-course` | CC | Tempo | Mid-implementation course correction |

## Phase 5 -- Release

| Command | Code | Agent | Description |
|---|---|---|---|
| `/aria-release` | RP | Coda | Release plan with versioning, changelog, and milestone |
| `/aria-cicd` | CI | Coda | CI/CD pipeline design with quality gates |
| `/aria-deploy` | DPL | Coda | Deployment strategy with rollback procedures |

## Quick Flow

| Command | Code | Agent | Description |
|---|---|---|---|
| `/aria-quick` | QS | Solo | Create a one-off tech spec as a work item |
| `/aria-quick-dev` | QD | Solo | Implement a quick-spec story directly |

## Tech Writing

| Command | Code | Agent | Description |
|---|---|---|---|
| `/aria-docs` | DP | Verse | Document existing project (+ validate mode) |
| `/aria-write` | WD | Verse | Write technical document (+ explain mode) |
| `/aria-diagram` | MG | Verse | Create Mermaid diagrams through conversation |

## Review & Meta

| Command | Code | Agent | Description |
|---|---|---|---|
| `/aria-critique` | RV | -- | Review: adversarial, edge cases, prose, or structure |
| `/aria-dash` | PD | -- | Project status dashboard |
| `/aria-party` | PMD | -- | Multi-agent discussion |
| `/aria-go` | ORC | Orchestrator | Auto-dispatch agents based on platform state |
| `/aria-help` | AH | -- | Context-aware help and next steps |

## Mode Detection

Several commands auto-detect their mode from arguments or platform state:

| Command | Modes | How Detected |
|---|---|---|
| `/aria-prd` | Create / Edit / Validate | No PRD → create; PRD exists + "edit" → edit; "check" or "validate" → validate |
| `/aria-brief` | Brief / Context | Default → brief; "context" or "scan" in arguments → context generation |
| `/aria-docs` | Document / Validate | Default → document; "validate" or "check" → validation mode |
| `/aria-write` | Write / Explain | Default → write; "explain" or "concept" → explanation mode |
