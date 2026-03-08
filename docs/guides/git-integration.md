# Git/GitHub Integration

ARIA optionally integrates with Git and GitHub to manage branches, commits, and pull requests alongside work item tracking.

## Setup

Run `/aria-git` to configure Git integration. The workflow detects your repository settings and asks about preferences.

### What Gets Configured

| Setting | Default | Description |
|---|---|---|
| `git_github_repo` | Auto-detected | GitHub repo in `owner/repo` format |
| `git_default_branch` | `main` | Base branch for PRs |
| `git_branch_prefix` | `{issue_identifier}` | Branch name prefix |
| `git_commit_prefix` | `feat({issue_identifier})` | Commit message prefix |
| `git_auto_push` | `true` | Push commits to remote automatically |
| `git_auto_pr` | `true` | Create PR when story transitions to review |
| `git_pr_draft` | `true` | Create PRs as drafts |
| `git_pr_auto_approve` | `true` | Approve PR when code review passes |
| `git_pr_auto_merge` | `false` | Merge PR when approved (disabled by default) |

## Branch Naming

Branches follow the pattern:

```
{team_name}-{issue_number}/{kebab-case-summary}
```

Example: `ENG-42/add-user-authentication`

The issue identifier in the branch name enables automatic work item linking.

## Commit Messages

Commits follow the pattern:

```
feat({issue_identifier}): description
```

Example: `feat(ENG-42): implement user authentication endpoint`

## Dev Workflow

When `git_enabled` is `true`, the dev agent (Riff) automatically:

1. Creates a feature branch from the default branch
2. Implements the story with commits prefixed by issue identifier
3. Pushes to remote
4. Creates a draft PR linking back to the work item
5. Records branch, commit SHA, and PR URL in the dev agent record

## Code Review Integration

When `git_enabled` is `true`, the QA agent (Pitch) also:

- Loads the PR diff as additional review surface
- Approves the PR when code review passes (if `pr_auto_approve` is enabled)
- Requests changes when review fails with findings

## PR-to-Work-Item Linking

ARIA links PRs to work items via platform-specific mechanisms. This creates a clickable link on the work item that points to the GitHub PR.

## Safety

- Git failures never block platform operations -- if a push or PR creation fails, the agent logs the error and continues with platform tracking
- Auto-merge is disabled by default since merging is destructive
- Set `git_enabled` to `"false"` in module.yaml to disable all git operations at any time
