# Task Procedures

ARIA uses reusable task procedures for common operations. Tasks are invoked by workflows and agents, not directly by users.

## Linear Tasks

Located in `_aria/linear/tasks/`:

| Task | Purpose |
|---|---|
| **lock-issue** | Apply/remove `aria-active` label to prevent concurrent agent work on the same issue |
| **set-issue-state** | Transition an issue to a new state via `save_issue` with state field |
| **post-handoff** | Post structured handoff comment with decisions, questions, and artefact refs. Apply handoff label. |
| **read-linear-context** | Load project context from Linear: PRD, architecture, stories, handoff history |
| **write-to-linear-doc** | Create or update a Linear Document. Register ID in key map. |
| **refine-backlog** | List unestimated backlog issues, prompt for Fibonacci estimates, update via `save_issue` |
| **link-pr-to-issue** | Attach a PR URL to a Linear issue via `save_issue` with `links` field |
| **attach-report** | Attach file (test report, review findings) to a Linear issue via `create_attachment` |
| **create-project-epic** | Create a Linear Project (Epic) with standard fields and register in key map |
| **update-project-dashboard** | Create or update a project status dashboard as a Linear Document |
| **help** | Context-aware guidance: inspect Linear state and recommend next workflow |

## Review Tasks

| Task | Purpose |
|---|---|
| **review-adversarial** | Cynical adversarial review of any document or artefact |
| **review-edge-cases** | Find unhandled edge cases and boundary conditions |
| **editorial-review-prose** | Review prose clarity, tone, and readability |
| **editorial-review-structure** | Review document organization and structure |

## Shared Tasks

Located in `_aria/shared/tasks/`:

| Task | Purpose |
|---|---|
| **git-operations** | Git/GitHub operations: create branch, commit, push, create PR, approve/request changes |
| **advanced-elicitation** | Advanced requirements elicitation techniques for complex discovery |
