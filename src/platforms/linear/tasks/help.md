---
name: help
description: 'Analyzes project state in Linear and recommends the next workflow. Use when user says "what should I do next" or at the end of any workflow.'
---

# Task: ARIA Help

Inspects Linear to detect project progress, then recommends the next workflow based on phase sequencing and artifact completion.

## ROUTING RULES

- **Empty `phase` = anytime** -- Universal tools work regardless of workflow state
- **Numbered phases indicate sequence** -- `0-setup` --> `1-analysis` --> `2-planning` --> `3-solutioning` --> `4-implementation`
- **Phase with no required steps** -- Entire phase is optional. Recommend it, but be clear about the true next required item.
- **`required=true` blocks progress** -- Required workflows must complete before proceeding to later phases
- **Artifacts reveal completion** -- Search Linear for documents and labeled issues to determine what's done
- **Descriptions contain routing** -- Read for alternate paths (e.g., "back to previous if fixes needed")

## DISPLAY RULES

All workflows in this module have slash commands. Show them prefixed with `/`:

```
Create PRD (CP)
Command: /aria-prd
Agent: Maestro (PM)
Description: Create, edit, or validate the Product Requirements Document
```

## EXECUTION

### Step 1 -- Load configuration and manifest

<action>Read project config: `{project-root}/_aria/core/module.yaml`</action>
<action>Read workflow manifest (if exists): `{project-root}/_aria/core/data/workflow-manifest.csv`</action>
<action>Read key map if it exists: `{project-root}/_aria/core/data/.key-map.yaml`</action>
<action>Extract `communication_language` -- present all output in this language</action>

### Step 2 -- Check setup completeness

Verify the Linear configuration is ready:

| Check | How to verify |
|---|---|
| `team_name` | Non-empty in module.yaml |
| `team_id` | Non-empty in module.yaml (UUID format) |
| `status_names` | At least `in_progress` and `done` populated |

<check if="any check fails">

**FIRST-RUN / SETUP INCOMPLETE MODE**

Present a warm welcome and guide the user through setup:

```
## Welcome to ARIA!

Let's get your project connected to Linear.
```

**Step 0 -- Linear MCP Server Setup**

Check if the user has the Linear MCP server configured. This is required for all Linear operations.

```
### Required: Linear MCP Server

ARIA requires the Linear MCP server for Claude Code.

Add to your Claude Code MCP settings (.claude/settings.json):
  {
    "mcpServers": {
      "linear-server": {
        "command": "npx",
        "args": ["-y", "@anthropic/linear-mcp-server"],
        "env": {
          "LINEAR_API_KEY": "your-linear-api-key"
        }
      }
    }
  }

Generate a Linear API key at: https://linear.app/settings/api
```

**If `team_name` or `team_id` is missing:**
```
Step 1: Run /aria-setup
This will auto-discover your Linear team, statuses, labels, and users.
```

**Step 1.5 -- Git Integration (Optional):**
```
If you want ARIA agents to create branches, commits, and PRs automatically:
  Run /aria-git
This detects your git repo, GitHub remote, and gh CLI, then configures the git
section in module.yaml. Skip this if you prefer to manage git manually.
```

**After setup is done:**
```
Step 2: Run /aria-help again to start building!
```

**Stop here** -- do not proceed to artifact detection until setup is complete.

</check>

### Step 3 -- Detect completed artifacts

<check if="setup is complete">

Use Linear MCP tools to check what exists. Run these searches **in parallel**:

1. **Linear documents** -- Search for ARIA documents:
   ```
   list_documents: query: "aria"
   ```

2. **Linear projects (epics)** -- Check if projects exist:
   ```
   list_projects: team: "{team_name}"
   ```

3. **Linear issues by status** -- Check implementation progress:
   ```
   list_issues: team: "{team_name}", state: "Done", limit: 5
   list_issues: team: "{team_name}", state: "In Progress", limit: 5
   list_issues: team: "{team_name}", state: "In Review", limit: 5
   ```

4. **Pending handoffs** -- Check for handoff signals:
   ```
   list_issues: team: "{team_name}", label: "aria-handoff-analyst"
   list_issues: team: "{team_name}", label: "aria-handoff-pm"
   list_issues: team: "{team_name}", label: "aria-handoff-architect"
   list_issues: team: "{team_name}", label: "aria-handoff-sm"
   list_issues: team: "{team_name}", label: "aria-handoff-dev"
   list_issues: team: "{team_name}", label: "aria-handoff-qa"
   ```

5. **Review-failed issues** -- Check for stuck issues:
   ```
   list_issues: team: "{team_name}", label: "aria-review-failed"
   ```

Build a completion map:

| Artifact | How to detect | Found? |
|---|---|---|
| Brainstorming | Key map `documents.brainstorming` or doc title search | |
| Research Reports | Key map `documents.research` or doc title search | |
| Product Brief | Key map `documents.brief` or doc title search | |
| Project Context | Key map `documents.project_context` or doc title search | |
| PRD | Key map `documents.prd` or doc title search | |
| UX Design | Key map `documents.ux` or doc title search | |
| Architecture | Key map `documents.architecture` or doc title search | |
| Projects (Epics) | `list_projects` returns results | |
| Readiness Report | Key map `documents.readiness` or doc title search | |
| Active Cycle | `list_cycles` with type "current" | |
| Issues In Progress | Issues with "In Progress" state | |
| Issues In Review | Issues with "In Review" state | |
| Issues Done | Issues with "Done" state | |

</check>

### Step 4 -- Determine current phase and next step

Walk the workflow manifest in phase + sequence order. Apply routing rules:

**Priority 0 -- Pending handoffs**
If any `aria-handoff-*` labels found: these are the highest priority. Tell the user which agent should be dispatched and for which issue. Recommend `/aria-go` to handle automatically.

**Priority 1 -- Review-failed issues**
If any issues have `aria-review-failed` label: recommend `/aria-dev` to address review findings.

**Phase 0 -- Setup**
- If `team_id` not populated --> `/aria-setup`

**Phase 1 -- Analysis** (all optional)
- If NO artifacts exist at all --> **This is a fresh project.** Present two paths:
  1. **Full planning track** (recommended): Start with `/aria-brief` to nail down your product idea
  2. **Quick flow** (for small tasks): Use `/aria-quick` for one-off features
  3. **Brownfield project**: Use `/aria-docs` to analyze existing code first
- Optional enrichment: `/aria-brainstorm`, `/aria-research`, `/aria-brief context`

**Phase 2 -- Planning** (PRD is required)
- If no PRD exists --> **Next required: `/aria-prd`**
- Optional: `/aria-ux` (recommended if project has a UI)
- If PRD exists, suggest `/aria-prd check` to validate before proceeding

**Phase 3 -- Solutioning** (Architecture, Epics, Readiness are required)
- If PRD exists but no Architecture --> **Next required: `/aria-arch`**
- If Architecture exists but no Projects (Epics) --> **Next required: `/aria-epics`**
- If Projects exist but no Readiness Report --> **Next required: `/aria-ready`**

**Phase 4 -- Implementation** (Sprint Planning, Story Prep, Dev are required)
- If no active cycle --> **Next required: `/aria-sprint`** (includes backlog refinement + capacity check)
- If issues in Backlog but none in Todo --> **Next: `/aria-story`** (estimates + prepares story)
- If issues in Todo/ready state --> **Next: `/aria-dev`**
  - If `git_enabled` is true: Dev will auto-create branches and PRs
- If issues In Review --> **Recommend: `/aria-cr`** (ideally with different LLM)
  - If `git_enabled` is true: QA will review PR diff and approve/request-changes
- If all issues in a project are Done --> **Recommend: `/aria-retro`** (includes velocity metrics)
- If ALL projects Done --> **Project complete!**

**Anytime workflows** -- Always mention these are available:
- `/aria-course` -- if major changes needed mid-implementation
- `/aria-go` -- to let the system auto-dispatch agents
- `/aria-critique` -- adversarial review, edge cases, prose, or structure review

### Step 5 -- Present recommendations

Format output clearly:

```
## Project Status: {project_name}

**Current Phase:** {detected_phase}
**Linear Team:** {team_name}

### Completed
- [x] {completed items with checkmarks}
- [ ] {incomplete items}

### Next Step (Required)

**{workflow_name}** ({code})
Command: `/{command}`
Agent: {agent_persona}
{brief description}

### Also Available
{optional workflows at this phase, each with command and one-line description}

---
Run each workflow in a **fresh context window** for best results.
For validation/review workflows, consider using a **different LLM** for adversarial quality.
```

**Presentation rules:**
- Lead with the **single most important next action**
- If the user asked a question, answer it in context of the detected project state
- If the project just started (no artifacts), give a warm welcome and walk through the first step
- If a workflow was just completed (invoked from workflow ending), focus on what's next -- don't repeat what was just done
- Show "anytime" workflows in a compact secondary section

### Step 6 -- Handle user questions

If additional input was provided, interpret it as a question and answer in context:

- "what should I do next?" --> Step 4 logic
- "I have an idea for X" --> `/aria-brief`
- "I already have a PRD" --> Check documents, suggest import or `/aria-prd check`
- "how do I set up Linear?" --> Point to module.yaml + `/aria-setup`
- "what's the orchestrator?" --> Explain `/aria-go`
- "can I skip X?" --> Explain which items are required vs optional
- "I want quick flow" --> `/aria-quick` + `/aria-quick-dev`

Return to the calling process after presenting recommendations.
