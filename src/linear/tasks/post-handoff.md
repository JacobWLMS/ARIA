# Post Handoff — Cross-Agent Communication

<critical>This is a reusable task. It is invoked by workflows at completion to notify the next agent.</critical>

## Purpose

Posts a structured handoff notification on relevant Linear issues when an agent completes its workflow and work is ready for the next agent. This enables traceability and automated orchestrator dispatch.

---

## Required Inputs

| Input | Description |
|---|---|
| `handoff_to` | The target agent name (e.g., "PM", "Architect", "SM", "Dev", "QA") |
| `handoff_type` | The type of handoff (e.g., "product_brief_complete", "prd_complete", "architecture_complete", "sprint_planned", "story_prepared", "dev_complete", "review_complete", "review_failed") |
| `summary` | Brief description of what was completed and what the next agent should do |
| `issue_ids` | (Optional) Specific Linear issue IDs or identifiers to post the handoff comment on. If not provided, posts on the most relevant project issues. |
| `document_id` | (Optional) Linear document ID of the artefact produced |
| `context_details` | **Required.** Structured context for the next agent. Must contain: `decisions` (key decisions made — at least 1), `open_questions` (unresolved items — can be empty list), `artefact_refs` (document IDs and issue identifiers consulted — at least 1), and optionally `estimated_points` (for sprint-related handoffs). This context is included in the handoff comment so the next agent inherits decisions without re-discovering them. |

---

## Procedure

### Step 1 — Determine target issues

If `issue_ids` are provided, use those directly.

If not, determine the most relevant issues based on `handoff_type`:

- **product_brief_complete / research_complete**: Find issues in the first project via `list_projects` with `team: "{linear_team_name}"` and `limit: 1`. Then `list_issues` for that project with `limit: 1`. If no projects exist yet, skip issue comment (document is the primary artefact).
- **prd_complete / ux_design_complete / architecture_complete / readiness_complete**: `list_projects` with `team: "{linear_team_name}"` to find all ARIA projects. Post on a representative issue from each project via `list_issues` with `project: "{project_id}"` and `limit: 1`.
- **sprint_planned**: Post on each issue that was planned into the cycle.
- **story_prepared**: Post on the specific story issue.
- **dev_complete / review_complete / review_failed / testing_complete**: Post on the specific story issue.
- **retrospective_complete**: Post on a representative issue in the project being retrospected.
- **correct_course_complete**: Post on all affected issues.

### Step 2 — Post handoff comment

For each target Linear issue, call `save_comment` with:

```
issueId: "{target_issue_id}"
body: |
  ## Agent Handoff: {current_agent} --> {handoff_to}

  **Completed:** {handoff_type}
  **Summary:** {summary}
  **Artefact:** {document_url or "See issue updates"}
  **Next Action:** {recommended_next_workflow}

  ### Context

  **Key Decisions:**
  {for_each_decision}
  - {decision}
  {end_for_each}

  **Open Questions:**
  {for_each_question}
  - {question}
  {end_for_each}

  **Referenced Artefacts:**
  {for_each_ref}
  - {artefact_type}: {artefact_id}
  {end_for_each}

  {if estimated_points provided}
  **Story Points:** {estimated_points}
  {end_if}

  ---
  _Posted by ARIA Agent System_
```

<critical>The Context section is MANDATORY. Every handoff must include at least one decision and one artefact reference. If the agent cannot identify any decisions, it should record "No significant decisions — followed standard workflow." If no artefacts were consulted, record "No external artefacts — work was self-contained."</critical>

### Step 3 — Apply handoff label

For each target Linear issue, add a handoff label to signal the orchestrator:

<action>Call `get_issue` with `id: "{target_issue_id}"` to read current labels</action>

<action>Call `save_issue` with:</action>

```
id: "{target_issue_id}"
labels: [{existing_labels}, "aria-handoff-{handoff_to_lowercase}"]
```

Where `{handoff_to_lowercase}` is the target agent name in lowercase (e.g., "aria-handoff-sm", "aria-handoff-dev").

### Step 4 — Update key map (if applicable)

If a `document_id` was provided, ensure it is recorded in `{key_map_file}` under the appropriate `documents` entry.

### Step 5 — Log completion

Report the handoff:

```
Handoff posted: {current_agent} --> {handoff_to}
Issues notified: {issue_id_list}
Label applied: aria-handoff-{handoff_to_lowercase}
```

---

## Handoff Type Reference

| Handoff Type | From Agent | To Agent | Next Workflow |
|---|---|---|---|
| `product_brief_complete` | Analyst | PM | Create PRD |
| `research_complete` | Analyst | PM | Create PRD |
| `prd_complete` | PM | UX Designer | Create UX Design |
| `ux_design_complete` | UX Designer | Architect | Create Architecture |
| `architecture_complete` | Architect | SM | Create Epics and Stories |
| `readiness_complete` | SM | SM | Sprint Planning |
| `sprint_planned` | SM | SM | Create Story |
| `story_prepared` | SM | Dev | Dev Story |
| `dev_complete` | Dev | QA | Code Review |
| `review_complete` | QA | SM | Next Story or Retrospective |
| `review_failed` | QA | Dev | Fix Findings + Re-submit for Review |
| `testing_complete` | QA | SM | Next Story or Retrospective |
| `retrospective_complete` | SM | SM | Next Epic or Complete |
| `correct_course_complete` | SM | Dev/SM | Resume work |

---

## Orchestrator Integration

The orchestrator's state reader scans for `aria-handoff-*` labels during its polling cycle using `list_issues` with `label` filter. When detected:

1. The label indicates which agent should be dispatched next
2. The orchestrator reads the handoff comment for context via `list_comments`
3. After dispatching the agent, the `aria-handoff-*` label is removed via `save_issue`

This creates a reliable, label-based signalling mechanism that survives across sessions and is visible in the Linear UI.
