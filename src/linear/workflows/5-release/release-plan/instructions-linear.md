# Release Plan — Linear Document + Milestone Output

<critical>You MUST have already loaded and processed: the workflow-linear.yaml for this workflow</critical>

## Overview

Creates a comprehensive release plan covering version strategy, changelog generation, release checklists, and rollback procedures. All output is written to Linear Documents exclusively. When milestones are in use, creates or updates a Linear Milestone for the release. Posts deployment checklists as comments on affected issues.

## Execution Rules

- NEVER generate content without user input — you are a facilitator, not a content generator
- ALWAYS treat this as collaborative planning between DevOps peers
- ABSOLUTELY NO TIME ESTIMATES — AI development speed has fundamentally changed
- ALWAYS speak in {communication_language}
- Show your analysis before taking any action
- At each step boundary, present the A/P/C menu and WAIT for the user's selection before proceeding
- Autonomy: when `autonomy_level` is `yolo`, auto-proceed on obvious steps; when `balanced`, auto-proceed only when unambiguous; when `interactive`, always wait for explicit user input

## A/P/C Menu Protocol (used in steps 2-6)

After generating content in each step, present:
- **[A] Advanced Elicitation** — Invoke `{project-root}/_aria/shared/tasks/advanced-elicitation.md`, then return to this menu with refined content
- **[P] Party Mode** — Invoke `{project-root}/_aria/shared/workflows/party-mode/instructions.md`, then return to this menu with enhanced analysis
- **[C] Continue** — Accept the content and proceed to the next step

User accepts/rejects A or P results before proceeding. FORBIDDEN to advance until C is selected.

---

<workflow>

<step n="1" goal="Initialize and load project context from Linear">

<action>Communicate in {communication_language} with {user_name}</action>

**1A. Check for existing release plans:**

<action>Call `list_documents` and search for documents with "Release Plan" in the title</action>

If found, present continuation menu:

"Welcome back {user_name}! I found existing Release Plan work for {project_name}.
- **[R] Resume** — Continue from where we left off
- **[C] Continue** — Jump to the next logical step
- **[O] Overview** — See all remaining steps
- **[X] Start over** — Begin fresh (creates a new document)"

R/C: Read existing document via `get_document`, analyse what sections are complete, jump to next incomplete step. O: List all 7 steps with descriptions, let user choose. X: Confirm with user, then proceed with fresh setup below.

**1B. Load project context:**

<action>Invoke the `read-linear-context` task from `{project-root}/_aria/linear/tasks/read-linear-context.md` with `context_type: "project_overview"`</action>
<action>Invoke the `read-linear-context` task with `context_type: "document_artefact"` and `scope_id: "architecture"` (if available)</action>
<action>Invoke the `read-linear-context` task with `context_type: "document_artefact"` and `scope_id: "prd"` (if available)</action>

**1C. Load all projects and issues:**

<action>Call `list_projects` with `team: "{linear_team_name}"` to discover all ARIA projects</action>
<action>For each Project, call `list_issues` with `project: "{project_id}"` to load all issues and their statuses</action>

**1D. Check for existing milestones:**

<action>Call `list_milestones` to discover any existing milestones</action>

**1E. Report and confirm:**

"Welcome {user_name}! Release planning workspace ready for {project_name}.

**Context Loaded:**
- Architecture: {status}
- PRD: {status}
- Projects: {project_count} projects with {issue_count} total issues
- Existing Milestones: {milestone_count}

What version are we planning? Any specific release goals or constraints?"

**Success:** All context loaded, issue statuses understood. **Failure:** Not loading issues, not checking existing milestones.
</step>

<step n="2" goal="Assess completed and in-progress work">

**2A. Categorise issues by status:**

For each project, group issues into:
- **Done** — Completed and ready for release
- **In Progress** — Started but not complete
- **Blocked** — Has blockers or dependencies
- **Not Started** — Backlog items

**2B. Identify release candidates:**

From completed issues, determine:
- Which features/fixes are ready to ship
- Which have dependencies on in-progress work
- Which can be released independently

**2C. Identify blockers and risks:**

- In-progress issues that block release
- Cross-project dependencies not yet resolved
- Known bugs or regressions
- Missing test coverage

**2D. Present assessment:**

"Here's the current state of {project_name}:

**Ready for Release ({done_count} issues):**
{grouped by project — issue title, key, type}

**In Progress ({in_progress_count} issues):**
{grouped by project — issue title, key, status}

**Blocked ({blocked_count} issues):**
{each with blocker description}

**Release Risks:**
- {risk items}

Does this match your understanding? Should any in-progress items be included in this release?"

**2E. Generate content:**

```markdown
## Release Readiness Assessment

### Completed Work
{issues grouped by project/feature area}

### In Progress
{issues with current status and blockers}

### Release Risks
{identified risks with severity}

### Release Scope Decision
{which items are in/out for this release and why}
```

**Present A/P/C menu.** On C, hold content and proceed to step 3.

**Success:** All issues assessed, risks identified, scope agreed. **Failure:** Not checking blockers, missing cross-project dependencies.
</step>

<step n="3" goal="Determine version number using semantic versioning">

**3A. Analyse change types:**

Categorise completed work:
- **Breaking changes** — API changes, schema migrations, removed features
- **New features** — New capabilities, new endpoints, new UI components
- **Bug fixes** — Corrections to existing behaviour
- **Performance improvements** — Optimisations without functional change
- **Documentation** — Docs-only changes
- **Infrastructure** — CI/CD, deployment, tooling changes

**3B. Apply semantic versioning rules:**

- MAJOR: Breaking changes present → bump major version
- MINOR: New features without breaking changes → bump minor version
- PATCH: Bug fixes only → bump patch version

**3C. Check previous versions:**

<action>Call `list_milestones` to find previous version milestones and determine the current version baseline</action>

**3D. Present version recommendation:**

"Based on the changes in this release:

**Change Summary:**
- Breaking changes: {count} ({list})
- New features: {count} ({list})
- Bug fixes: {count} ({list})

**Recommended Version:** {version} (from {previous_version})
**Rationale:** {why this version bump}

Does this version number work? Any pre-release suffix needed (alpha, beta, rc)?"

**3E. Generate content:**

```markdown
## Version Strategy

### Previous Version: {previous_version}
### Release Version: {new_version}

### Change Classification
**Breaking Changes:** {details}
**New Features:** {details}
**Bug Fixes:** {details}
**Other Changes:** {details}

### Versioning Rationale
{explanation of version bump decision}
```

**Present A/P/C menu.** On C, hold content and proceed to step 4.

**Success:** Version determined with clear rationale, user agreed. **Failure:** Arbitrary version, not checking previous versions.
</step>

<step n="4" goal="Generate changelog from completed issues">

**4A. Group changes by category:**

Organise completed issues into changelog sections:
- **Added** — New features
- **Changed** — Changes to existing functionality
- **Deprecated** — Soon-to-be-removed features
- **Removed** — Removed features
- **Fixed** — Bug fixes
- **Security** — Vulnerability fixes

**4B. Write changelog entries:**

For each issue, create a human-readable changelog entry:
- Clear, user-facing description (not internal jargon)
- Reference to Linear issue ID
- Credit to assignee if applicable

**4C. Generate content:**

```markdown
## Changelog

### [{version}] - {date}

#### Added
- {feature description} ({issue_id})

#### Changed
- {change description} ({issue_id})

#### Fixed
- {fix description} ({issue_id})

#### Security
- {security fix description} ({issue_id})

#### Infrastructure
- {infra change description} ({issue_id})
```

**Present A/P/C menu.** On C, hold content and proceed to step 5.

**Success:** All changes documented in user-friendly language. **Failure:** Copy-pasting issue titles without context, missing changes.
</step>

<step n="5" goal="Create release checklist — pre-release, release, post-release">

**5A. Define pre-release checklist:**

Based on the architecture and project context:
- Code freeze confirmation
- All release-scoped issues in Done status
- Test suite passing (unit, integration, e2e)
- Security scan clean
- Dependency audit (no critical vulnerabilities)
- Database migration tested (if applicable)
- API compatibility verified (if applicable)
- Documentation updated
- Release notes drafted

**5B. Define release checklist:**

- Tag release in version control
- Build release artifacts
- Run deployment pipeline
- Verify health checks pass
- Smoke test critical paths
- Monitor error rates
- Verify monitoring and alerting active

**5C. Define post-release checklist:**

- Monitor error rates for 24 hours
- Verify all integrations functional
- Update status page / release notes
- Close milestone in Linear
- Archive release branch (if applicable)
- Retrospective scheduled (if applicable)
- Communicate release to stakeholders

**5D. Create rollback plan:**

- Rollback trigger criteria (error rate thresholds, health check failures)
- Rollback procedure (step by step)
- Database rollback strategy (if migrations involved)
- Communication plan during rollback
- Post-rollback verification steps

**5E. Generate content:**

```markdown
## Release Checklist

### Pre-Release
- [ ] {checklist items tailored to project}

### Release Day
- [ ] {checklist items tailored to deployment strategy}

### Post-Release
- [ ] {checklist items tailored to monitoring setup}

## Rollback Plan

### Trigger Criteria
{when to initiate rollback}

### Rollback Procedure
{step-by-step rollback instructions}

### Post-Rollback Verification
{verification steps after rollback}
```

**Present A/P/C menu.** On C, hold content and proceed to step 6.

**Success:** Comprehensive checklists covering all phases, rollback plan included. **Failure:** Generic checklists not tailored to the project.
</step>

<step n="6" goal="Known issues and future considerations">

**6A. Document known issues:**

- Issues discovered but not fixed in this release
- Workarounds for known limitations
- Technical debt items deferred

**6B. Document future considerations:**

- Features planned for next release
- Architectural improvements needed
- Performance optimisation opportunities
- Security hardening items

**6C. Generate content:**

```markdown
## Known Issues

| Issue | Severity | Workaround | Planned Fix |
|---|---|---|---|
| {description} | {severity} | {workaround} | {target version} |

## Future Considerations

### Next Release Candidates
{items likely for next version}

### Technical Debt
{deferred items with priority}

### Performance Improvements
{optimisation opportunities}
```

**Present A/P/C menu.** On C, hold content and proceed to step 7.

**Success:** Transparent about limitations, clear path forward. **Failure:** Hiding known issues, no forward planning.
</step>

<step n="7" goal="Write release plan to Linear Document, create Milestone, and hand off">

**7A. Celebrate completion** — summarise what was accomplished: version determined, changelog generated, checklists created, rollback plan defined.

**7B. Compile the complete release plan:**

<action>Compile all content from steps 2-6 in order:</action>

1. Release Readiness Assessment (step 2)
2. Version Strategy (step 3)
3. Changelog (step 4)
4. Release Checklist + Rollback Plan (step 5)
5. Known Issues + Future Considerations (step 6)

<action>Generate in {document_output_language}</action>

**7C. Write to Linear Document:**

<action>Invoke the `write-to-linear-doc` task from `{project-root}/_aria/linear/tasks/write-to-linear-doc.md` with:</action>

```
title: "[{linear_team_name}] Release Plan: {version}"
body_content: "{compiled_release_plan_content}"
key_map_id: "release_plan"
```

<action>Update `{key_map_file}` with new document ID under `documents.release_plan`</action>

**7D. Create or update Linear Milestone:**

If milestones are in use:
<action>Call `save_milestone` with:</action>

```
name: "v{version}"
description: "Release {version} — {release_summary}"
targetDate: "{planned_release_date}"
```

**7E. Post deployment checklists as comments on affected issues:**

<action>For each issue included in the release, call `save_comment` with the pre-release and release-day checklist items relevant to that issue</action>

**7F. Post handoff:**

<action>Invoke the `post-handoff` task from `{project-root}/_aria/linear/tasks/post-handoff.md` with:</action>

```
handoff_to: "SM"
handoff_type: "release_plan_complete"
summary: "Release plan v{version} created and published to Linear Document. Milestone created. Ready for release execution."
document_id: "{release_plan_document_id}"
```

**7G. Report to user:**

**Release Plan Complete**
- **Linear Document:** {release_plan_document_title}
- **Version:** {version}
- **Milestone:** {milestone_name} (if created)
- **Issues in Release:** {issue_count}
- **Handoff:** SM agent notified

**Next Steps:**
1. Review the release plan in Linear Documents
2. Execute pre-release checklist items
3. Run [CI/CD Design] to set up the deployment pipeline
4. Run [Deploy Strategy] to finalize deployment approach

<action>Invoke the help task at `{project-root}/_aria/linear/tasks/help.md`</action>

**Success:** Document published, Milestone created, checklists posted, SM notified. **Failure:** Not publishing, missing milestone, no handoff.
</step>

</workflow>
