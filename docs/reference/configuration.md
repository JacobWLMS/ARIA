# Configuration

ARIA is configured through `_aria/linear/module.yaml`. The `/aria-setup` workflow auto-populates most fields.

## Essential (Asked During Setup)

These are the only fields you need to provide:

| Variable | Description | Example |
|---|---|---|
| `project_name` | Your project name | `"My SaaS App"` |
| `linear_team_name` | Linear team name (auto-discovered) | `"Engineering"` |
| `user_skill_level` | beginner / intermediate / expert | `"intermediate"` |
| `git_enabled` | Enable Git/GitHub integration | `"true"` |

## Auto-Derived (Populated by /aria-setup)

These fields are discovered automatically -- do not edit manually:

| Variable | Description | Source |
|---|---|---|
| `user_name` | Your display name | git config or Linear profile |
| `linear_team_id` | Linear team UUID | `list_teams` |
| `status_names` | Workflow state names | `list_issue_statuses` |
| `workspace_project_id` | ARIA workspace project ID | Auto-created |
| `autonomy_level` | interactive / balanced / yolo | Derived from `user_skill_level` |

### Autonomy Derivation

| Skill Level | Autonomy Level | Behavior |
|---|---|---|
| beginner | interactive | Always asks for confirmation |
| intermediate | balanced | Auto-proceeds when obvious, asks on ambiguous actions |
| expert | yolo | Fully autonomous (except course corrections) |

## Defaults

These have sensible defaults. Override only if needed:

| Variable | Default | Description |
|---|---|---|
| `communication_language` | `"English"` | Language for agent communication |
| `document_output_language` | `"English"` | Language for generated documents |
| `project_prefix` | `""` | Prefix for Linear artefact titles |
| `use_cycles` | `"true"` | Whether to use Linear Cycles for sprints |

## Git Settings

Configured via `/aria-git`. Only relevant when `git_enabled` is `"true"`:

| Variable | Default | Description |
|---|---|---|
| `git_github_repo` | `""` | GitHub repo in `owner/repo` format |
| `git_default_branch` | `"main"` | Base branch for PRs |
| `git_branch_prefix` | `"{issue_identifier}"` | Branch name prefix |
| `git_commit_prefix` | `"feat({issue_identifier})"` | Commit message prefix |
| `git_auto_push` | `"true"` | Auto-push commits to remote |
| `git_auto_pr` | `"true"` | Auto-create PRs on review transition |
| `git_pr_draft` | `"true"` | Create PRs as drafts |
| `git_pr_auto_approve` | `"true"` | Auto-approve PR on review pass |
| `git_pr_auto_merge` | `"false"` | Auto-merge approved PRs |

## Label Conventions

| Variable | Default | Description |
|---|---|---|
| `agent_label_prefix` | `"aria-agent-"` | Prefix for agent tracking labels |
| `lock_label` | `"aria-active"` | Label for issue locking |
| `handoff_label_prefix` | `"aria-handoff-"` | Prefix for handoff signal labels |

## System (Do Not Edit)

| Variable | Value | Description |
|---|---|---|
| `tracking_system` | `"linear"` | Always "linear" for this module |
| `key_map_file` | `.linear-key-map.yaml` path | Location of key map |

!!! note "No Transition IDs"
    Unlike Jira-based systems, Linear uses state names directly. ARIA sets issue states via `save_issue` with `state: "In Progress"` -- no transition ID discovery needed.
