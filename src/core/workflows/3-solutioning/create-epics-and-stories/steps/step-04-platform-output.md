# Step 4: Output Projects (Epics) and Issues (Stories) to the platform

**This step replaces the default file-write output step.** The elicitation and analysis steps (1-3) remain unchanged — they build the epics/stories structure in the agent's working memory. This step writes that structure to the platform.

---

## Prerequisites

- Steps 1-3 have completed: you have a fully formed epics/stories structure with:
  - Epic titles, goals, and FR coverage
  - Story titles, user stories (As a / I want / So that), and acceptance criteria (Given/When/Then)
  - Story point estimates and dependencies
- Configuration loaded: `{team_name}`, `{agent_label_prefix}`, `{key_map_file}`, `{project_prefix}`
- PRD document exists (look up `documents.prd` in `{key_map_file}`)

---

<workflow>

<step n="4.0" goal="Resolve default assignee">
<action>Read `default_assignee` from module.yaml</action>
<action>If `default_assignee` is non-empty, call `list_users` with `query: "{default_assignee}"` to resolve the platform user</action>
<action>Store the resolved user `id` for use in all subsequent create calls</action>
<action>If `default_assignee` is empty or the lookup fails, proceed without setting assignee</action>
</step>

<step n="4.1" goal="Ensure required labels exist">
<action>Before creating issues, ensure all required labels exist for the team</action>
<action>Invoke the platform's label listing to get existing labels for `{team_name}`</action>

Check if these labels exist:
- `{agent_label_prefix}pm`
- `aria-epic`
- `aria-story`

<action>For each missing label, invoke the platform's label creation for team `{team_name}` with the label name</action>

<action>Record label names for use in subsequent steps</action>
</step>

<step n="4.2" goal="Resolve team ID">
<action>Call `list_teams` with `query: "{team_name}"` to resolve the team ID</action>
<action>Record the team ID for use in project and issue creation</action>
<action>If team not found, warn user and attempt to use `{team_id}` from module.yaml as fallback</action>
</step>

<step n="4.3" goal="Create epics (Epics)">
<action>For each Epic in the structure, invoke the `create-epic` task from `{project-root}/_aria/core/tasks/create-epic.md` with:</action>

```
epic_name: "{project_prefix} {N}: {epic_title}"
epic_description: |
  ## Goal
  {epic_goal}

  ## User Value
  {what_users_can_accomplish}

  ## Requirements Coverage
  {fr_coverage_for_this_epic}

  ## Dependencies
  {epic_dependencies_or_none}
team_name: "{team_name}"
lead: "{resolved_user_id}"   # omit if no default_assignee
```

<action>Record each returned project ID (e.g., `project_id_1`, `project_id_2`)</action>
<action>Update `{key_map_file}` under `projects`: `epic-{N}: "{project_id}"`</action>
</step>

<step n="4.4" goal="Create work items (Stories) under Projects">
<action>For each Story under each Epic, invoke the `create-work-item` task from `{project-root}/_aria/core/tasks/create-work-item.md` with `project` set to the Epic's project ID:</action>

```
team: "{team_name}"
title: "Story {N}.{M}: {story_title}"
description: |
  ## User Story
  As a {user_type},
  I want {capability},
  So that {value_benefit}.

  ## Acceptance Criteria

  {for_each_ac}
  **Given** {precondition}
  **When** {action}
  **Then** {expected_outcome}
  {end_for_each}

  ## Technical Notes
  {implementation_considerations}

  ## Dependencies
  {dependency_list_or_none}

  ## Story Points
  {story_points}
project: "{parent_epic_project_id}"
assignee: "{resolved_user_id}"   # omit if no default_assignee
labels: ["{agent_label_prefix}pm", "aria-story"]
estimate: {story_points}
priority: {priority_number}
state: "Backlog"
```

<action>The `project` field links the Issue to its Project (Epic) automatically — issues appear under the project in the platform's project view</action>
<action>Update `{key_map_file}` under `issues`: `{N}-{M}-{kebab_title}: "{issue_id}"`</action>

**Kebab-case conversion rules:**
- Replace period with dash: `1.1` -> `1-1`
- Convert title to kebab-case: `User Authentication` -> `user-authentication`
- Final key: `1-1-user-authentication`
</step>

<step n="4.5" goal="Create dependency links between stories">
<action>For stories that have dependencies on other stories, create dependency relationships:</action>

For each story with dependencies:

<action>Invoke the platform's work-item relation mechanism to create a `blockedBy` link from `{dependent_story_issue_id}` to `{blocking_story_issue_id}`</action>

And for the blocking story:

<action>Invoke the platform's work-item relation mechanism to create a `blocks` link from `{blocking_story_issue_id}` to `{dependent_story_issue_id}`</action>

<action>This creates bidirectional dependency links visible in the platform's issue view</action>
</step>

<step n="4.6" goal="Create milestones for projects (if applicable)">
<action>If the epic structure includes milestones or release targets, create milestones within each project:</action>

For each milestone:

<action>Invoke the platform's milestone creation with:</action>

```
project: "{project_id}"
name: "{milestone_name}"
description: "{milestone_description}"
targetDate: "{target_date_iso}"   # ISO 8601 format, e.g., "2026-06-30"
```

<action>Record milestone IDs in `{key_map_file}` under `milestones`</action>
</step>

<step n="4.7" goal="Add document links to Project descriptions">
<action>Look up `documents.prd` in `{key_map_file}` to get the PRD document ID</action>

<action>For each Project (Epic) created, invoke the platform's project update to append a Related Documents section to the description:</action>

```
id: "{project_id}"
description: |
  {existing_project_description}

  ---
  ## Related Documents
  - PRD: {prd_document_id}
  {if architecture exists: '- Architecture: {architecture_document_id}'}
  {if ux_design exists: '- UX Design: {ux_design_document_id}'}
```

<action>If Architecture or UX Design documents also exist in `{key_map_file}`, include those references too</action>
</step>

<step n="4.8" goal="Verify key map is updated">
<action>Confirm all created project and issue IDs have been recorded in `{key_map_file}`</action>

The key map should now contain:

```yaml
projects:
  epic-1: "{project_id_1}"
  epic-2: "{project_id_2}"
  # ...

issues:
  1-1-{kebab-title}: "{issue_id}"
  1-2-{kebab-title}: "{issue_id}"
  2-1-{kebab-title}: "{issue_id}"
  # ...

milestones:
  {milestone-name}: "{milestone_id}"
  # ...
```

<action>This ensures downstream workflows can look up project and issue IDs</action>
</step>

<step n="4.9" goal="Post handoff">
<action>Invoke the `post-handoff` task from `{project-root}/_aria/core/tasks/post-handoff.md` with:</action>

```
handoff_to: "Architect"
handoff_type: "epics_stories_complete"
summary: "Created {epic_count} projects and {story_count} issues in the platform. Ready for architecture review or implementation readiness check."
issue_ids: ["{representative_issue_ids}"]
```
</step>

<step n="4.10" goal="Report results">
<action>Present a summary to the user:</action>

**Platform Output Complete**

| Type | Count | Team |
|---|---|---|
| Projects (Epics) created | {epic_count} | {team_name} |
| Issues (Stories) created | {story_count} | {team_name} |
| Project-Issue links | {link_count} (via project field) | -- |
| Dependency links | {dependency_count} (via blocks/blockedBy) | -- |
| Milestones created | {milestone_count} | -- |
| Document links | {doc_link_count} (embedded in descriptions) | -- |

**Key Map Updated:** `{key_map_file}`

**Next Steps:**
1. Review the created projects and issues in the platform
2. Run **Create Architecture** to create the Architecture Decision Document (if not done)
3. Run **Check Implementation Readiness** to validate completeness
4. Run **Sprint Planning** to organise stories into cycles

<action>Invoke the help task at `{project-root}/_aria/core/tasks/help.md` to present context-aware next-step recommendations to the user</action>
</step>

</workflow>

---

## Success Criteria

- All epics created as epics with full descriptions and FR coverage
- All stories created as work items with complete acceptance criteria in descriptions
- Stories linked to their parent Projects via the `project` field
- Dependencies created with `blocks`/`blockedBy` relationships
- Labels created before use (no silent failures from missing labels)
- Milestones created if applicable
- Document references added to Project descriptions
- Key map updated with all project IDs, issue IDs, and milestone IDs
- Handoff posted to Architect agent
- User informed of results with next-step guidance

## Failure Conditions

- Not creating labels before applying them (silent failure — issues created without labels)
- Not linking stories to projects (orphaned issues with no project association)
- Not creating dependency links (stories worked out of order)
- Not updating key map (subsequent workflows cannot find issues)
- Creating duplicate projects (not checking for existing ones in step 1)
- Not adding document references to project descriptions
