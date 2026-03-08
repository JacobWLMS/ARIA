# Git Discovery — Git/GitHub Integration Setup

**Purpose:** Discover git and GitHub settings for the current project and generate the `git:` configuration block for module.yaml. Run this once during setup to enable git integration alongside Linear tracking.

---

## Prerequisites

- The project should already have ARIA installed (`_aria/linear/module.yaml` exists)
- Linear discovery should already be completed (team name configured)
- Git must be installed on the system

---

## Discovery Workflow

<workflow>

<step n="1" goal="Check for git repository">
<action>Run `git rev-parse --git-dir` to check if the current directory is inside a git repo</action>

**If not a git repo:**
- Ask the user: "This directory is not a git repository. Would you like to initialize one?"
- If yes: run `git init`
- If no: inform the user that git integration requires a git repo and stop

**If it is a git repo:**
- Report: "Git repository detected."
</step>

<step n="2" goal="Detect GitHub remote">
<action>Run `git remote -v` to list remotes</action>

**If no remotes:**
- Ask the user: "No remote configured. Would you like to:"
  1. Add an existing GitHub remote (enter URL)
  2. Create a new GitHub repo via `gh repo create`
  3. Skip remote setup (local git only — PRs will not be available)
- If option 1: run `git remote add origin {url}`
- If option 2: run `gh repo create {name} --source=. --push` (ask public/private)
- If option 3: note that PR features will be unavailable

**If remote exists:**
- Parse the remote URL to extract `owner/repo` (e.g., `JacobWLMS/MyProject`)
- Report: "GitHub remote detected: {owner/repo}"
</step>

<step n="3" goal="Detect default branch">
<action>Run `git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@'` to detect the default branch</action>
<action>If that fails, check for `main` or `master` branches: `git branch -a | grep -E '(main|master)'`</action>

- If detected: confirm with user — "Default branch appears to be `{branch}`. Is this correct?"
- If not detected: ask the user — "What is your default/base branch name?"
</step>

<step n="4" goal="Check gh CLI availability">
<action>Run `gh --version` to check if the GitHub CLI is installed</action>

**If available:**
<action>Run `gh auth status` to check authentication</action>
- If authenticated: report "gh CLI authenticated as {username}"
- If not authenticated: suggest `gh auth login`

**If not available:**
- Report: "gh CLI not found. PR creation and review features will require manual steps."
- Suggest: `brew install gh` or `sudo apt install gh` or visit https://cli.github.com
</step>

<step n="5" goal="Configure branch naming convention">
<action>Read `linear_team_name` from module.yaml</action>

Present the default branch naming convention:

```
Branch name format: {linear_team_name}-{issue_number}/{kebab-case-summary}
Example: TEAM-42/add-user-authentication
```

Linear issues have identifiers like `TEAM-42`. ARIA uses this identifier in branch names for traceability.

- Ask: "Use this branch naming convention? (Y/n, or enter custom format)"
- If custom: accept their format (must include `{issue_identifier}` or `{issue_number}` for Linear linking)
- Record the `branch_prefix` value
</step>

<step n="6" goal="Configure commit message format">
Present the default commit message format:

```
Commit format: feat({issue_identifier}): description
Example: feat(TEAM-42): implement user authentication endpoint
```

- Ask: "Use this commit message format? (Y/n, or enter custom format)"
- If custom: accept their format (must include `{issue_identifier}` placeholder)
- Record the `commit_prefix` value
</step>

<step n="7" goal="Configure PR behavior">
Ask the user about PR preferences:

1. **Auto-create PRs?** "Automatically create a PR when dev transitions to In Review?" (default: yes)
2. **Draft PRs?** "Create PRs as drafts?" (default: yes)
3. **Auto-push?** "Automatically push commits to remote?" (default: yes)
4. **Auto-approve?** "Automatically approve PR when code review passes?" (default: yes)
5. **Auto-merge?** "Automatically merge PR when approved?" (default: no — merging is destructive)

Record all preferences.
</step>

<step n="8" goal="Configure PR-to-Linear linking">
Explain to the user:

"When a PR is created, ARIA can automatically link it to the Linear issue using `save_issue` with the `links` field. This creates a clickable link on the Linear issue."

- Ask: "Enable automatic PR-to-Linear linking?" (default: yes)
- This uses the `link-pr-to-issue` task from `{project-root}/_aria/linear/tasks/link-pr-to-issue.md`
</step>

<step n="9" goal="Output configuration">
<action>Generate the complete git configuration:</action>

```yaml
# --- Git/GitHub Integration ---
git_enabled: "true"
git_github_repo: "{owner/repo}"
git_default_branch: "{detected_or_user_specified}"
git_branch_prefix: "{linear_team_name}"
git_commit_prefix: "feat({issue_identifier})"
git_auto_push: "true"
git_auto_pr: "true"
git_pr_draft: "true"
git_pr_auto_approve: "true"
git_pr_auto_merge: "false"
```

<action>Present the config to the user and ask: "Update your module.yaml with these git settings?"</action>

**If yes:** Update the git settings section in `{project-root}/_aria/linear/module.yaml`.

**If no:** Print the YAML block for manual addition.

<action>Report completion:</action>

```
Git integration configured!

Summary:
  - Repository: {owner/repo}
  - Default branch: {default_branch}
  - Branch format: {team_name}-{N}/{kebab}
  - Auto PR: {yes/no} (draft: {yes/no})
  - Auto push: {yes/no}
  - Auto approve: {yes/no}
  - Auto merge: {yes/no}
  - PR-to-Linear linking: {yes/no}
  - Tool chain: {gh CLI / git only}

The dev-story and code-review workflows will now include git operations.
Set git_enabled to "false" in module.yaml to disable at any time.

Next steps:
  1. Run /aria-help to see available workflows
  2. Run /aria-brief to start your first project
```
</step>

</workflow>
