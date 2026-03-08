---
description: 'Discover Git/GitHub settings and configure integration for ARIA workflows'
---

IT IS CRITICAL THAT YOU FOLLOW THESE STEPS:

<steps CRITICAL="TRUE">
1. READ the git discovery workflow from {project-root}/_aria/shared/tasks/git-operations.md
2. Detect if this is a git repository (git rev-parse --git-dir)
3. Detect the default branch (git symbolic-ref refs/remotes/origin/HEAD)
4. Detect the GitHub remote (git remote get-url origin)
5. Extract the owner/repo from the remote URL
6. Verify gh CLI is available and authenticated
7. Present discovered settings to the user for confirmation
8. Update module.yaml with git_enabled, git_github_repo, git_default_branch, etc.
</steps>

User input: $ARGUMENTS
