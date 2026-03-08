# Architecture

ARIA's internal structure and key concepts.

## Directory Structure

When installed into a project, ARIA creates this structure:

```
_aria/
├── linear/                          # Linear module
│   ├── module.yaml                  # Configuration (team, git, autonomy)
│   ├── .linear-key-map.yaml         # Auto-populated Linear ID lookups
│   ├── artefact-mapping.yaml        # Where each artefact type goes in Linear
│   ├── agents/                      # 12 agent definitions + base critical actions
│   │   ├── base-critical-actions.yaml
│   │   ├── analyst.agent.yaml       # Cadence
│   │   ├── pm.agent.yaml            # Maestro
│   │   ├── ux-designer.agent.yaml   # Lyric
│   │   ├── architect.agent.yaml     # Opus
│   │   ├── security.agent.yaml      # Forte
│   │   ├── data.agent.yaml          # Harmony
│   │   ├── sm.agent.yaml            # Tempo
│   │   ├── dev.agent.yaml           # Riff
│   │   ├── qa.agent.yaml            # Pitch
│   │   ├── devops.agent.yaml        # Coda
│   │   ├── quick-flow.agent.yaml    # Solo
│   │   └── tech-writer.agent.yaml   # Verse
│   ├── workflows/                   # Phase-organized workflow instructions
│   │   ├── base-workflow.yaml       # Shared workflow config (all inherit from this)
│   │   ├── includes/                # Reusable instruction fragments
│   │   │   ├── autonomy-logic.md
│   │   │   ├── step-menu.md
│   │   │   └── workflow-header.md
│   │   ├── 0-quick-flow/
│   │   ├── 1-analysis/
│   │   ├── 2-plan-workflows/
│   │   ├── 3-solutioning/
│   │   ├── 4-implementation/
│   │   └── 5-release/
│   ├── tasks/                       # Reusable task procedures
│   ├── orchestrator/                # State reader + dispatch rules
│   ├── data/                        # Workflow manifest, key map template
│   ├── linear-discovery.md          # /aria-setup workflow
│   └── git-discovery.md             # /aria-git workflow
└── shared/                          # Shared across modules
    ├── templates/                   # 16 document templates
    ├── checklists/                  # 7 validation checklists
    ├── data/                        # Reference data (brainstorming techniques, etc.)
    └── tasks/                       # Shared tasks (git operations, elicitation)
```

## Key Concepts

### Key Map

`_aria/linear/.linear-key-map.yaml` is an auto-populated lookup file that maps logical names to Linear entity IDs. When an agent creates a Linear Document (e.g., a PRD), it stores the document ID in the key map. Subsequent agents look up that ID instead of re-querying Linear.

### Agent Locking

Before modifying an issue, agents apply the `aria-active` label via the `lock-issue` task. This prevents concurrent agents from working on the same issue. The label is removed when work completes.

### Handoff Labels

When an agent completes work, it applies an `aria-handoff-{agent}` label (e.g., `aria-handoff-dev`) and posts a structured handoff comment. The next agent or orchestrator uses this signal to determine what to do.

### Structured Handoffs

Handoff comments are structured with mandatory fields:

- **decisions** -- key decisions made during the workflow (at least 1)
- **open_questions** -- unresolved items for the next agent
- **artefact_refs** -- Linear entity IDs consulted or created (at least 1)

### Workflow Inheritance

All workflow YAML files inherit from `base-workflow.yaml` using an `inherits:` directive. Each workflow only declares its unique fields (agent, instructions path, phase). The base file contains shared config source references and task paths.

### Shared Includes

Common instruction patterns are extracted into `workflows/includes/`:

- `autonomy-logic.md` -- standard conditional behavior by autonomy level
- `step-menu.md` -- A/P/C menu pattern
- `workflow-header.md` -- common critical directives (language, output, tracking)

Workflow instructions reference these with `{include: path}` directives to avoid repetition.

### Review Failure Loop

When code review (Pitch) fails a story, it transitions back to In Progress and posts findings. Riff picks up the story again, addresses findings, and re-submits for review. This loop continues until review passes.

## Linear ↔ BMAD Differences

ARIA is adapted from the [BMAD-METHOD](https://github.com/bmadcode/BMAD-METHOD). Key differences:

| Aspect | BMAD-METHOD | ARIA |
|---|---|---|
| Output destination | Local markdown files | Linear entities (Documents, Issues, Projects) |
| Tracking | Manual or external | Linear-native (states, labels, comments) |
| Transitions | Jira transition IDs | Linear state names (direct) |
| Agent names | Human names (Mary, John) | Musical names (Cadence, Maestro) |
| Epic concept | Jira Epic issue type | Linear Project |
| Sprint concept | Jira Sprint | Linear Cycle |
| Story points | Custom field or label | Linear native `estimate` field |
| Dependencies | Issue links | Linear `blocks`/`blockedBy` relations |
| Wiki/Docs | Confluence pages | Linear Documents |
| Handoff mechanism | File-based | Label + structured comment |
| Workflow config | Full YAML per workflow | Inherited from base + unique overrides |
