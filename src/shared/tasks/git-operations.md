---
name: git-operations
description: 'Reusable git/GitHub operations task. No-op when git_enabled is false. Fault-tolerant — git failures never block tracking system operations.'
---

# Task: Git Operations

Performs git and GitHub operations for ARIA workflows. Each operation checks `git.enabled` in module.yaml first — if false or missing, the operation is a silent no-op.

**Tool precedence:** GitHub MCP plugin > `gh` CLI > raw `git`

**Fault tolerance:** All operations are wrapped in try/catch. If a git operation fails, log the error and return `{ success: false, error: "..." }` without blocking the calling workflow. Tracking system operations must never be affected by git failures.

---

## Operations

### `create_branch`

Creates a feature branch for a story.

**Parameters:**
- `issue_key` — Issue identifier (e.g., `TEAM-42`)
- `summary` — Story summary (will be kebab-cased for branch name)

**Procedure:**

<action>Check `git.enabled` in the module's `module.yaml`. If not `true`, return `{ success: true, skipped: true, reason: "git.enabled is false" }` and stop.</action>

<action>Read `git.branch_prefix` and `git.default_branch` from module.yaml config.</action>

<action>Build the branch name:</action>
1. Extract the issue number from `issue_key` (e.g., `42` from `PROJ-42`)
2. Convert `summary` to kebab-case (lowercase, spaces/special chars to hyphens, max 50 chars)
3. Branch name = `{branch_prefix}-{number}/{kebab-summary}`
   - Example: `PROJ-42/add-user-authentication`

<action>Create the branch:</action>
1. Run `git fetch origin`
2. Check if branch already exists: `git branch --list "{branch_name}"` and `git branch -r --list "origin/{branch_name}"`
3. If branch exists locally, just check it out: `git checkout {branch_name}`
4. If branch exists only on remote, check it out tracking remote: `git checkout -b {branch_name} origin/{branch_name}`
5. If branch does not exist, create it: `git checkout -b {branch_name} origin/{default_branch}`

<action>Return `{ success: true, branch_name: "{branch_name}" }`</action>

---

### `commit_and_push`

Stages, commits, and optionally pushes changes.

**Parameters:**
- `issue_key` — Issue identifier for commit message prefix
- `message` — Commit description

**Procedure:**

<action>Check `git.enabled` in module.yaml. If not `true`, return `{ success: true, skipped: true }` and stop.</action>

<action>Read `git.commit_prefix` and `git.auto_push` from module.yaml config.</action>

<action>Build the commit message:</action>
1. Replace `{issue_key}` in `commit_prefix` with the actual issue key
2. Full message = `{resolved_prefix}: {message}`
   - Example: `feat(PROJ-42): implement user authentication endpoint`

<action>Stage and commit:</action>
1. Run `git add -A`
2. Run `git commit -m "{full_message}"`
3. If commit fails (nothing to commit), return `{ success: true, nothing_to_commit: true }`

<action>If `auto_push` is `true`:</action>
1. Run `git push origin HEAD`
2. If push fails (e.g., no remote, auth issue), log the error but still return success for the commit

<action>Return `{ success: true, commit_sha: "{sha}", pushed: {bool} }`</action>

---

### `create_pr`

Creates a pull request for the current branch.

**Parameters:**
- `issue_key` — Issue identifier
- `title` — PR title
- `body` — PR body/description (include issue link)

**Procedure:**

<action>Check `git.enabled` and `git.auto_pr` in module.yaml. If either is not `true`, return `{ success: true, skipped: true }` and stop.</action>

<action>Read `git.github_repo`, `git.default_branch`, and `git.pr_draft` from module.yaml config.</action>

<action>Ensure changes are pushed first:</action>
1. Run `git push origin HEAD`

<action>Check if a PR already exists for this branch:</action>
1. Try `gh pr list --head {current_branch} --json number,url --state open`
2. If a PR already exists, return `{ success: true, existing: true, pr_url: "{url}", pr_number: {number} }`

<action>Create the PR:</action>

1. **Try `gh` CLI first:**
   ```
   gh pr create \
     --title "{issue_key}: {title}" \
     --body "{body}" \
     --base {default_branch} \
     --head {current_branch} \
     {--draft if pr_draft is true}
   ```

2. **If `gh` is not available, instruct user:**
   Return `{ success: false, fallback: "manual", message: "gh CLI not available. Create PR manually for branch {branch_name}" }`

<action>Return `{ success: true, pr_url: "{url}", pr_number: {number} }`</action>

---

### `approve_pr`

Approves a pull request (submits an approval review).

**Parameters:**
- `issue_key` — Issue identifier (to find the PR by branch naming convention)

**Procedure:**

<action>Check `git.enabled` and `git.pr_auto_approve` in module.yaml. If either is not `true`, return `{ success: true, skipped: true }` and stop.</action>

<action>Find the PR:</action>
1. Get current branch or find branch matching issue key pattern
2. Run `gh pr list --head {branch_name} --json number,url --state open`
3. If no PR found, return `{ success: false, error: "No open PR found for {issue_key}" }`

<action>Approve the PR:</action>
1. Run `gh pr review {pr_number} --approve --body "Code review passed. Approved by ARIA QA agent."`

<action>Return `{ success: true, pr_number: {number}, action: "approved" }`</action>

---

### `request_changes`

Requests changes on a pull request (submits a changes-requested review).

**Parameters:**
- `issue_key` — Issue identifier
- `findings` — Review findings summary

**Procedure:**

<action>Check `git.enabled` in module.yaml. If not `true`, return `{ success: true, skipped: true }` and stop.</action>

<action>Find the PR (same as approve_pr).</action>

<action>Request changes:</action>
1. Run `gh pr review {pr_number} --request-changes --body "{findings}"`

<action>Return `{ success: true, pr_number: {number}, action: "changes_requested" }`</action>

---

### `get_pr_diff`

Gets the diff for the PR or current branch for review purposes.

**Parameters:**
- `issue_key` — Issue identifier

**Procedure:**

<action>Check `git.enabled` in module.yaml. If not `true`, return `{ success: true, skipped: true }` and stop.</action>

<action>Read `git.default_branch` from module.yaml config.</action>

<action>Get the diff:</action>

1. **Try PR diff first:** `gh pr diff --name-only` then `gh pr diff` for full content
2. **Fall back to git diff:** `git diff {default_branch}...HEAD`

<action>Return `{ success: true, diff: "{diff_content}", files_changed: ["{file_list}"] }`</action>

---

## Configuration Reference

These values are read from the `git:` section of the module's `module.yaml`:

| Config Key | Used By | Default |
|---|---|---|
| `git.enabled` | All operations | `false` |
| `git.github_repo` | `create_pr` | `""` |
| `git.default_branch` | `create_branch`, `create_pr`, `get_pr_diff` | `main` |
| `git.branch_prefix` | `create_branch` | `{project_key}` |
| `git.commit_prefix` | `commit_and_push` | `feat({issue_key})` |
| `git.auto_push` | `commit_and_push` | `true` |
| `git.auto_pr` | `create_pr` | `true` |
| `git.pr_draft` | `create_pr` | `true` |
| `git.pr_auto_approve` | `approve_pr` | `true` |
| `git.pr_auto_merge` | (reserved for future use) | `false` |

---

## Worktree Compatibility

When the agent runs inside a Claude Code worktree (dispatched with `isolation: "worktree"` on the Agent tool), all git operations automatically target the worktree's working directory. No code changes are needed — operations are path-agnostic.

- **`create_branch`** — Creates the feature branch inside the worktree. The worktree starts on the default branch, so `git checkout -b` works normally. The branch is visible to the main repo.
- **`commit_and_push`** — Commits and pushes from the worktree. The push goes to the same remote.
- **`create_pr`** — Creates a PR from the worktree's branch. Works identically to non-worktree operation.
- **`get_pr_diff`** — Reads diffs from the worktree or via `gh pr diff`. Works identically.

### Concurrent Safety

When two agents run in separate worktrees simultaneously:
- Each worktree has its own working directory, index, and HEAD
- Issue-specific branch naming prevents branch conflicts between agents
- Issue locks (enforced by the orchestrator) prevent two agents from working on the same story
