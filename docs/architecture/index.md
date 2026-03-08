# Architecture

ARIA's internal structure and key concepts.

## Directory Structure

When installed into a project, ARIA creates this structure:

```
_aria/
├── core/                            # Platform-agnostic core
│   ├── module.yaml                  # Configuration (team, git, autonomy, platform)
│   ├── .key-map.yaml                # Auto-populated entity ID lookups
│   ├── artefact-mapping.yaml        # Where each artefact type goes
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
│   ├── tasks/                       # Core task dispatchers (delegate to platform tasks)
│   ├── orchestrator/                # State reader + dispatch rules
│   ├── data/                        # Workflow manifest, key map template
│   ├── discovery.md                 # /aria-setup workflow
│   └── git-discovery.md             # /aria-git workflow
├── platforms/                       # Platform-specific implementations
│   ├── linear/                      # Linear MCP tool wrappers
│   │   ├── platform.yaml            # Linear tool mapping + terminology
│   │   └── tasks/                   # Linear-specific task procedures
│   └── plane/                       # Plane MCP tool wrappers
│       ├── platform.yaml            # Plane tool mapping + terminology
│       └── tasks/                   # Plane-specific task procedures
└── shared/                          # Shared across modules
    ├── templates/                   # 16 document templates
    ├── checklists/                  # 7 validation checklists
    ├── data/                        # Reference data (brainstorming techniques, etc.)
    └── tasks/                       # Shared tasks (git operations, elicitation)
```

!!! note "Platform Abstraction"
    Core tasks in `_aria/core/tasks/` are platform-agnostic dispatchers. They read the `platform` setting from `module.yaml` and delegate to the appropriate platform-specific task in `_aria/platforms/{linear,plane}/tasks/`. Agents and workflows never reference MCP tools directly -- they invoke core tasks which handle platform routing.

## Key Concepts

### Cross-Phase Context Retrieval

Every artefact an agent creates — PRDs, architecture documents, security reviews, data models, handoff notes — is stored on the platform and registered in the key map. Any agent at any phase can retrieve any of these artefacts on demand via the `read-context` task. This means:

- **Riff** (dev) can read Opus's architecture decisions to understand *why* a design choice was made before implementing it
- **Pitch** (QA) can check the original PRD acceptance criteria when reviewing a story
- **Forte** (security) can review Harmony's data model when performing a threat assessment
- **Tempo** (SM) can read all handoff history to understand blockers across the sprint

No context is lost between phases. The platform serves as persistent institutional memory for the entire project lifecycle.

### Key Map

`_aria/core/.key-map.yaml` is an auto-populated lookup file that maps logical names to platform entity IDs. When an agent creates a document (e.g., a PRD), it stores the entity ID in the key map. Subsequent agents look up that ID instead of re-querying the platform.

### Agent Locking

Before modifying an issue, agents apply the `aria-active` label via the `lock-work-item` task. This prevents concurrent agents from working on the same issue. The label is removed when work completes.

### Handoff Labels

When an agent completes work, it applies an `aria-handoff-{agent}` label (e.g., `aria-handoff-dev`) and posts a structured handoff comment. The next agent or orchestrator uses this signal to determine what to do.

### Structured Handoffs

Handoff comments are structured with mandatory fields:

- **decisions** -- key decisions made during the workflow (at least 1)
- **open_questions** -- unresolved items for the next agent
- **artefact_refs** -- platform entity IDs consulted or created (at least 1)

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

## Platform ↔ BMAD Differences

ARIA is adapted from the [BMAD-METHOD](https://github.com/bmadcode/BMAD-METHOD). Key differences:

| Aspect | BMAD-METHOD | ARIA |
|---|---|---|
| Output destination | Local markdown files | Platform entities (Documents, Work Items, Epics) |
| Tracking | Manual or external | Platform-native (states, labels/properties, comments) |
| Transitions | Jira transition IDs | Platform state names |
| Agent names | Human names (Mary, John) | Musical names (Cadence, Maestro) |
| Platforms | Jira + Confluence | Plane or Linear (selectable) |
| Wiki/Docs | Confluence pages | Platform documents (Plane pages / Linear documents) |
| Handoff mechanism | File-based | Label/property + structured comment |
| Workflow config | Full YAML per workflow | Inherited from base + unique overrides |
