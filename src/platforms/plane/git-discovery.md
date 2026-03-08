# Plane Git Discovery

**Purpose:** Configure Git/GitHub integration settings for ARIA when running on Plane.

This workflow is identical to the Linear git discovery — git operations are platform-agnostic. The only difference is the branch naming convention uses Plane work item identifiers instead of Linear issue identifiers.

---

## Procedure

### Step 1 — Detect Git repository

<action>Check if the current directory is a git repository: `git rev-parse --git-dir`</action>
<action>If not a git repo, ask the user if they want to initialize one</action>

### Step 2 — Detect GitHub remote

<action>Run `git remote -v` to find GitHub remotes</action>
<action>If a GitHub remote exists, extract the owner/repo</action>
<action>If no remote, ask if the user wants to set one up</action>

### Step 3 — Configure Git settings

Ask the user to confirm or customize:

| Setting | Default | Description |
|---|---|---|
| `git_enabled` | true | Enable git integration |
| `git_github_repo` | auto-detected | GitHub owner/repo |
| `git_default_branch` | main | Default branch name |
| `git_branch_prefix` | `{work_item_identifier}` | Branch naming pattern |
| `git_commit_prefix` | `feat({work_item_identifier})` | Commit message prefix |
| `git_auto_push` | true | Auto-push after implementation |
| `git_auto_pr` | true | Auto-create PR on review transition |
| `git_pr_draft` | true | Create PRs as drafts |

### Step 4 — Save to module.yaml

<action>Update module.yaml with the git settings</action>
<action>Report: "Git integration configured for {git_github_repo}"</action>
