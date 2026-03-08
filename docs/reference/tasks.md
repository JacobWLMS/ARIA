# Task Procedures

ARIA uses reusable task procedures for common operations. Tasks are invoked by workflows and agents, not directly by users.

## Core Tasks

Located in `_aria/core/tasks/` (dispatch to platform-specific implementations):

| Task | Purpose |
|---|---|
| **lock-work-item** | Prevent concurrent agent work on the same work item (labels on Linear, properties on Plane) |
| **set-work-item-state** | Transition a work item to a new state |
| **post-handoff** | Post structured handoff comment with decisions, questions, and artefact refs. Signal next agent. |
| **read-context** | Load project context from the platform: PRD, architecture, stories, handoff history |
| **write-document** | Create or update a document. Register ID in key map. |
| **refine-backlog** | List unestimated backlog work items, prompt for Fibonacci estimates, update |
| **link-pr-to-work-item** | Attach a PR URL to a work item |
| **attach-report** | Attach file (test report, review findings) to a work item |
| **create-epic** | Create an epic with standard fields and register in key map |
| **update-dashboard** | Create or update a project status dashboard document |
| **help** | Context-aware guidance: inspect platform state and recommend next workflow |
| **log-work** | Log effort on a work item for velocity tracking (Plane) |
| **create-intake** | Submit an idea to the intake/triage queue (Plane) |

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
