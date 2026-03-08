---
description: 'Health check — validates platform MCP connection, configuration, and setup completeness'
---

IT IS CRITICAL THAT YOU FOLLOW THESE STEPS:

<steps CRITICAL="TRUE">
1. READ the installed ARIA version from {project-root}/_aria/core/VERSION (if missing, report "version unknown")

2. READ the platform identifier from {project-root}/_aria/.platform (e.g., "linear", "plane")

3. READ project configuration from {project-root}/_aria/core/module.yaml

4. Run the following checks and report results as a checklist:

   **Configuration:**
   - [ ] module.yaml exists
   - [ ] `team_name` is set (not empty/placeholder)
   - [ ] `team_id` is set
   - [ ] `status_names` are configured
   - [ ] `user_name` is set

   **Platform MCP Connection:**
   - [ ] Call the platform's list teams/projects API — if it succeeds, MCP is connected
   - [ ] Team from config is accessible in results
   - [ ] Issue statuses match config

   **Key Map:**
   - [ ] {project-root}/_aria/core/data/.key-map.yaml exists

   **Git Integration (if git_enabled is true):**
   - [ ] Current directory is a git repository
   - [ ] Remote is configured
   - [ ] `gh` CLI is available and authenticated

5. Report results:

   "**ARIA Health Check** (v{version}) — platform: {platform}

   {checklist with pass/fail for each item}

   **Status:** {N}/{total} checks passed"

6. For any failed checks, suggest the fix:
   - Missing module.yaml → "Run `/aria-setup`"
   - MCP not connected → "Configure the platform MCP server in .claude/settings.json"
   - Team not found → "Run `/aria-setup` to re-discover your team"
   - Git issues → "Run `/aria-git` to configure git integration"
   - Key map missing → "Run `/aria-setup` — the key map is created during setup"
</steps>

User input: $ARGUMENTS
