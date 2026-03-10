# Configuration

ARIA is configured through `_aria/core/module.yaml`. The `/aria-setup` workflow auto-populates most fields.

## Essential (Asked During Setup)

These are the only fields you need to provide:

| Variable | Description | Example |
|---|---|---|
| `platform` | Project management platform | `"plane"` or `"linear"` |
| `project_name` | Your project name | `"My SaaS App"` |
| `team_name` | Team or project name (auto-discovered) | `"Engineering"` |
| `user_skill_level` | beginner / intermediate / expert | `"intermediate"` |
| `git_enabled` | Enable Git/GitHub integration | `"true"` |

## Auto-Derived (Populated by /aria-setup)

These fields are discovered automatically -- do not edit manually:

| Variable | Description | Source |
|---|---|---|
| `user_name` | Your display name | git config or platform profile |
| `team_id` | Team/project UUID | Platform discovery |
| `status_names` | Workflow state names | Platform discovery |
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
| `project_prefix` | `""` | Prefix for artefact titles |
| `use_cycles` | `"true"` | Whether to use sprint cycles |

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
| `tracking_system` | `"plane"` or `"linear"` | Matches `platform` setting |
| `key_map_file` | `.key-map.yaml` path | Location of key map |

!!! note "State Transitions"
    Both Plane and Linear use state names directly. ARIA sets work item states by name -- no transition ID discovery needed (unlike Jira-based systems).
