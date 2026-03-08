# First Project Setup

Once ARIA is installed and the Linear MCP server is configured, set up your project.

## Step 1: Run `/aria-setup`

This interactive workflow auto-discovers your Linear workspace and configures ARIA. It asks 3-4 essential questions:

1. **Project name** -- what is your project called?
2. **Linear team** -- auto-discovered via `list_teams`, you confirm
3. **Skill level** -- beginner, intermediate, or expert (controls autonomy level)
4. **Git integration** -- enable or disable

Everything else is auto-derived:

- Team ID, workflow statuses, and labels are discovered from Linear
- User name is detected from git config or Linear profile
- Autonomy level is derived from your skill level (beginner → interactive, intermediate → balanced, expert → yolo)
- A workspace project is created in Linear for early-phase documents

Configuration is saved to `_aria/linear/module.yaml`.

## Step 2: Run `/aria-git` (Optional)

If you enabled git integration, this workflow configures:

- GitHub remote detection or setup
- Default branch detection
- Branch naming convention (e.g., `TEAM-42/add-auth`)
- Commit message format (e.g., `feat(TEAM-42): implement auth`)
- PR behavior (auto-create, draft mode, auto-push, auto-approve, auto-merge)

## Step 3: Run `/aria-help`

Get context-aware guidance on what to do next. ARIA inspects your Linear workspace and recommends the appropriate workflow based on your project's current state.

!!! tip "Fresh Project?"
    For a brand new project, the typical starting sequence is:

    1. `/aria-brainstorm` -- generate ideas
    2. `/aria-brief` -- formalize into a product brief
    3. `/aria-prd` -- create a product requirements document
    4. `/aria-arch` -- define architecture
    5. `/aria-epics` -- break down into epics and stories
    6. `/aria-sprint` -- plan your first sprint
