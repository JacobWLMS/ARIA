---
description: 'Health check — validates Linear MCP connection, configuration, and setup completeness'
---

IT IS CRITICAL THAT YOU FOLLOW THESE STEPS:

<steps CRITICAL="TRUE">
1. READ the installed ARIA version from {project-root}/_aria/linear/VERSION (if missing, report "version unknown")

2. READ project configuration from {project-root}/_aria/linear/module.yaml

3. Run the following checks and report results as a checklist:

   **Configuration:**
   - [ ] module.yaml exists
   - [ ] `linear_team_name` is set (not empty/placeholder)
   - [ ] `linear_team_id` is set
   - [ ] `status_names` are configured
   - [ ] `user_name` is set

   **Linear MCP Connection:**
   - [ ] Call `list_teams` — if it succeeds, MCP is connected
   - [ ] Team from config is accessible in results
   - [ ] Call `list_issue_statuses` — statuses match config

   **Key Map:**
   - [ ] {project-root}/_aria/linear/.linear-key-map.yaml exists

   **Git Integration (if git_enabled is true):**
   - [ ] Current directory is a git repository
   - [ ] Remote is configured
   - [ ] `gh` CLI is available and authenticated

4. Report results:

   "**ARIA Health Check** (v{version})

   {checklist with pass/fail for each item}

   **Status:** {N}/{total} checks passed"

5. For any failed checks, suggest the fix:
   - Missing module.yaml → "Run `/aria-setup`"
   - MCP not connected → "Configure the Linear MCP server in .claude/settings.json"
   - Team not found → "Run `/aria-setup` to re-discover your team"
   - Git issues → "Run `/aria-git` to configure git integration"
   - Key map missing → "Run `/aria-setup` — the key map is created during setup"
</steps>

User input: $ARGUMENTS
