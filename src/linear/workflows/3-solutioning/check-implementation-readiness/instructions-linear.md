# Check Implementation Readiness — Linear Assessment

<critical>You MUST have already loaded and processed: the workflow-linear.yaml for this workflow</critical>

<workflow>

<step n="1" goal="Discover and load all project artefacts from Linear">

**Progress: Step 1 of 6** — Next: PRD Analysis

### Role & Communication

- Communicate in {communication_language} with {user_name}
- You are an expert Product Manager and Scrum Master performing implementation readiness validation
- Your findings are objective and backed by evidence
- Be direct — do not soften the message on gaps or issues found

### 1.1 Load Artefacts from Linear Documents

Invoke the `read-linear-context` task from `{project-root}/_aria/linear/tasks/read-linear-context.md` with `context_type: "project_overview"` to discover all available project artefacts.

Load each artefact from Linear Documents:
- Invoke `read-linear-context` with `context_type: "document_artefact"` and `scope_id: "prd"` to load the PRD
- Invoke `read-linear-context` with `context_type: "document_artefact"` and `scope_id: "architecture"` to load the Architecture
- Invoke `read-linear-context` with `context_type: "document_artefact"` and `scope_id: "ux_design"` to load the UX design (if exists)
- Invoke `read-linear-context` with `context_type: "document_artefact"` and `scope_id: "product_brief"` to load the product brief

### 1.2 Load Projects (Epics) and Issues (Stories) from Linear

Search for all Projects (Epics):
- Call `list_projects` with `team: "{linear_team_name}"` to find all ARIA-managed projects

For each Project found, load its issues:
- Call `list_issues` with `project: "{project_id}"` to get all issues under this project

Call `get_project` for each Project and `get_issue` for key issues to load full descriptions and acceptance criteria.

### 1.3 Report Discovery Results

Present the artefact inventory:

| Artefact | Status |
|---|---|
| PRD | {found/missing} |
| Architecture | {found/missing} |
| UX Design | {found/missing} |
| Product Brief | {found/missing} |
| Projects (Epics) | {count} found |
| Issues (Stories) | {count} found |

### 1.4 Handle Missing Artefacts

**Critical artefacts** (PRD, Projects/Issues): If missing, warn the user and ask whether to proceed with a partial readiness check.

**Important artefacts** (Architecture): If missing, note as a gap that will affect the assessment.

**Optional artefacts** (UX Design, Product Brief): If missing, note for the record but do not block.

{if autonomy_level == "interactive"}
  If any critical artefact is missing, wait for user confirmation to proceed.
{else}
  If critical artefacts are missing, warn and proceed with partial check.
  {if autonomy_level == "balanced"}
    Wait briefly for user override.
  {end_if}
{end_if}

### Success Criteria
- All artefact types searched systematically
- Projects and Issues loaded with full descriptions
- Missing artefacts identified and categorised by criticality
- User informed of discovery results before proceeding

### Failure Modes
- Not searching all artefact types
- Not loading full issue descriptions (only summaries)
- Proceeding without acknowledging missing critical artefacts

</step>

<step n="2" goal="Analyse PRD and extract all requirements for coverage validation">

**Progress: Step 2 of 6** — Next: Coverage Validation

### Step Goal

Thoroughly read and analyse the PRD to extract all Functional Requirements (FRs) and Non-Functional Requirements (NFRs) for traceability validation against Projects and Issues.

### 2.1 Extract Functional Requirements

Read the PRD completely. Search for and extract:
- Numbered FRs (FR1, FR2, FR3, etc.)
- Requirements labelled "Functional Requirement"
- User stories or use cases that represent functional needs
- Business rules that must be implemented

Record each requirement with its full text and identifier.

### 2.2 Extract Non-Functional Requirements

Search for and extract:
- **Performance:** Response times, throughput targets
- **Security:** Authentication, encryption, authorisation requirements
- **Usability:** Accessibility, ease of use standards
- **Reliability:** Uptime, error rate targets
- **Scalability:** Concurrent users, data growth projections
- **Compliance:** Standards, regulations, certifications

### 2.3 Extract Additional Requirements

Look for requirements not explicitly labelled as FR/NFR:
- Constraints or assumptions
- Technical requirements embedded in narrative sections
- Business constraints
- Integration requirements

### 2.4 Document PRD Analysis

Record the complete requirements inventory:

**Functional Requirements:**
- Total FRs: {count}
- {Complete list with ID and full text}

**Non-Functional Requirements:**
- Total NFRs: {count}
- {Complete list with ID and full text}

**Additional Requirements:**
- {Any constraints, assumptions, or unlabelled requirements}

**PRD Completeness Assessment:**
- Are requirements clear and unambiguous?
- Are requirements measurable and testable?
- Are there obvious gaps in coverage?

### Success Criteria
- PRD read completely (not summarised)
- All FRs extracted with full text
- All NFRs identified and documented
- Additional requirements and constraints captured
- Initial completeness assessment recorded

### Failure Modes
- Summarising PRD instead of extracting full requirement text
- Missing requirements buried in narrative sections
- Not distinguishing between FR and NFR categories

</step>

<step n="3" goal="Validate that all PRD requirements map to at least one Project/Issue">

**Progress: Step 3 of 6** — Next: Architecture and UX Alignment

### Step Goal

Compare extracted PRD requirements against Projects and Issues to identify coverage gaps. Every FR should trace to at least one Issue. Identify orphan requirements and orphan Issues.

### 3.1 Map Requirements to Projects/Issues

For each FR extracted in step 2:
- Search through all Project and Issue descriptions for references to this requirement
- Check FR coverage maps if present in Project descriptions
- Document which Project/Issue covers each requirement

Build the coverage matrix:

| FR # | PRD Requirement | Project/Issue Coverage | Status |
|------|----------------|----------------------|--------|
| FR1 | {requirement text} | {Project X / Issue Y} | Covered |
| FR2 | {requirement text} | **NOT FOUND** | MISSING |

### 3.2 Identify Coverage Gaps

List all FRs not covered by any Project or Issue:

**Critical Missing FRs:**
- FR#: {full requirement text}
- Impact: {why this is critical}
- Recommendation: {which Project should include this}

**High Priority Missing FRs:**
- {Any other uncovered FRs}

### 3.3 Identify Orphan Issues

Check for Issues that do not trace back to any PRD requirement:
- These may indicate scope creep or undocumented requirements
- Flag for user review

### 3.4 Coverage Statistics

- Total PRD FRs: {count}
- FRs covered in Projects/Issues: {count}
- Coverage percentage: {percentage}
- Orphan Issues (no PRD traceability): {count}

### 3.5 Post Findings as Comments on Relevant Issues

For each specific gap tied to a Project, post a comment on a representative issue in that Project:

Call `save_comment` with:

```
issueId: "{representative_issue_id}"
body: |
  **Readiness Finding:** {finding_description}

  This requirement has no matching Issue in this Project.
  **Requirement:** {requirement_text_from_prd}
  **Recommendation:** {action_needed}
```

This creates targeted feedback visible in the Linear UI for the PM to address.

### Success Criteria
- Every FR checked against Project/Issue coverage
- Coverage matrix created with clear status indicators
- All gaps identified with severity and recommendations
- Orphan Issues flagged for review
- Comments posted on relevant issues for each uncovered requirement

### Failure Modes
- Not checking every FR (missing requirements in comparison)
- Not identifying orphan Issues (scope creep goes unnoticed)
- Not posting comments for specific findings

</step>

<step n="4" goal="Validate architecture alignment and UX coverage">

**Progress: Step 4 of 6** — Next: Issue Quality Review

### Step Goal

Verify that the Architecture document aligns with PRD requirements and that Issues reflect architectural decisions. Also check UX design alignment if UX documentation exists.

### 4.1 Architecture Alignment Check

Review the Architecture document for:
- Tech stack decisions
- Architectural patterns (microservices, monolith, serverless, etc.)
- Architecture Decision Records (ADRs)
- Component structure and data model

Verify alignment:
- Do Issues reference or align with the chosen tech stack and patterns?
- Are ADR decisions reflected in Issue constraints or implementation notes?
- Are there architectural decisions that lack corresponding Issues or tasks?
- Does the component structure support all PRD requirements?

For each misalignment, post a comment on the most relevant Issue in the affected Project:

Call `save_comment` with:

```
issueId: "{relevant_issue_id}"
body: |
  **Readiness Finding — Architecture Misalignment:**

  {finding_description}

  This architectural decision is not reflected in any Issue.
  **ADR:** {adr_text_from_architecture}
  **Recommendation:** {action_needed}
```

### 4.2 UX Alignment Check

**If UX document exists:**

Check UX-to-PRD alignment:
- Are UX requirements reflected in the PRD?
- Do user journeys in UX match PRD use cases?
- Are there UX requirements not captured in the PRD?

Check UX-to-Architecture alignment:
- Does the architecture support UX requirements?
- Are performance needs (responsiveness, load times) addressed?
- Are UI components supported by the architecture's component structure?

Document alignment issues and post comments on relevant Issues where applicable.

**If no UX document exists:**

Assess whether UX/UI is implied by the PRD:
- Does the PRD mention user interface?
- Are there web/mobile components implied?
- Is this a user-facing application?

If UX is implied but missing documentation: add a warning to the report.
If no UI is implied (pure API, CLI, data pipeline): note as expected and move on.

### 4.3 Document Alignment Findings

Record all alignment issues:
- Architecture gaps: {list}
- UX alignment issues: {list}
- Cross-document inconsistencies: {list}

### Success Criteria
- Architecture decisions checked against Issue coverage
- ADR compliance verified
- UX alignment validated (or warning issued if missing)
- Comments posted for specific misalignments
- All findings documented with evidence

### Failure Modes
- Not checking ADR compliance in Issues
- Ignoring UX implications when no UX document exists
- Not posting comments for specific findings

</step>

<step n="5" goal="Review Project and Issue quality against best practices">

**Progress: Step 5 of 6** — Next: Final Assessment

### Step Goal

Validate Projects (Epics) and Issues (Stories) against ARIA best practices. Focus on user value delivery, independence, dependency correctness, story sizing, and acceptance criteria quality. This review runs autonomously to maintain standards — apply best practices without compromise.

### 5.1 Project (Epic) Structure Validation

**User Value Focus:** For each Project, verify:
- Project name is user-centric (what user can do, not technical milestone)
- Project goal describes a user outcome
- Users can benefit from this Project alone

**Red flags (violations):**
- "Setup Database" or "Create Models" — no user value
- "API Development" — technical milestone
- "Infrastructure Setup" — not user-facing

**Project Independence:** Test sequential independence:
- Project 1 must stand alone completely
- Project 2 can function using only Project 1 output
- Project N cannot require Project N+1 to work
- No circular dependencies between Projects

Document all violations with specific examples.

### 5.2 Issue (Story) Quality Assessment

**Issue Sizing:** For each Issue, verify:
- Delivers clear user value
- Can be completed independently (no forward dependencies)
- Appropriately sized for a single sprint

**Acceptance Criteria Review:** For each Issue's ACs:
- **Format:** Proper Given/When/Then BDD structure?
- **Testable:** Each AC can be verified independently?
- **Complete:** Covers happy path, error conditions, edge cases?
- **Specific:** Clear expected outcomes with measurable thresholds?

**Common violations to find:**
- Vague criteria like "user can login" (missing specifics)
- Missing error conditions
- Non-measurable outcomes
- ACs that depend on future Issues

### 5.3 Dependency Analysis

**Within-Project Dependencies:**
- Issue 1.1 must be completable alone
- Issue 1.2 can use Issue 1.1 output
- No forward references (Issue 1.2 depending on Issue 1.4)

Check `blocks` and `blockedBy` relationships on issues for correctness.

**Database/Entity Creation Timing:**
- Wrong: Project 1 Issue 1 creates all tables upfront
- Right: Each Issue creates tables it needs
- Verify tables are created only when first needed

### 5.4 Special Implementation Checks

**Starter Template:** If Architecture specifies a starter template, verify Project 1's first Issue is "Set up initial project from starter template" with cloning, dependencies, and initial configuration.

**Greenfield vs Brownfield:** Verify appropriate Issues exist:
- Greenfield: initial setup, dev environment, CI/CD pipeline
- Brownfield: integration points, migration, compatibility

### 5.5 Document Quality Findings

Classify all findings by severity:

**Critical Violations:**
- Technical Projects with no user value
- Forward dependencies breaking Project independence
- Epic-sized Issues that cannot be completed

**Major Issues:**
- Vague acceptance criteria
- Issues requiring future Issues
- Database creation violations

**Minor Concerns:**
- Formatting inconsistencies
- Minor structure deviations
- Documentation gaps

### Success Criteria
- All Projects validated against user-value and independence rules
- Every Issue's acceptance criteria reviewed for testability
- All dependency relationships verified (no forward references)
- Quality violations documented with specific examples and severity
- Clear remediation guidance provided for each violation

### Failure Modes
- Accepting technical Projects as valid (they deliver no user value)
- Ignoring forward dependencies
- Not verifying Issue sizing and AC quality
- Softening findings instead of being direct about violations

</step>

<step n="6" goal="Compile final assessment, publish to Linear, and hand off">

**Progress: Step 6 of 6** — Final Step

### Step Goal

Compile all findings from steps 2-5 into a comprehensive readiness report, determine the overall verdict, publish to Linear Document, post Project-specific comments, and hand off to the SM agent.

### 6.1 Compile Risk Assessment

Review all findings from steps 2-5 and compile into a risk assessment:

1. **Critical gaps** — Requirements with no coverage, architectural misalignment, Project independence violations
2. **Major gaps** — Incomplete Issues, missing acceptance criteria, dependency issues
3. **Minor gaps** — Ordering issues, missing sub-issues, cosmetic concerns

### 6.2 Determine Readiness Verdict

Assign an overall readiness verdict:

- **READY**: All checks pass, implementation can begin
- **READY WITH NOTES**: Minor gaps identified, can proceed with awareness
- **NOT READY**: Critical gaps that must be addressed first

### 6.3 Compile the Readiness Report

Using the template at `{template}`, compile the complete readiness report:

```markdown
# Implementation Readiness Assessment Report

**Date:** {date}
**Project:** {project_name}
**Verdict:** {READY / READY WITH NOTES / NOT READY}

## Artefact Inventory
{artefact discovery results from step 1}

## PRD Analysis
### Functional Requirements
{FR list from step 2}
### Non-Functional Requirements
{NFR list from step 2}
### PRD Completeness Assessment
{assessment from step 2}

## Requirements Coverage
### Coverage Matrix
{coverage matrix from step 3}
### Missing Requirements
{uncovered FRs from step 3}
### Coverage Statistics
{statistics from step 3}

## Architecture & UX Alignment
### Architecture Alignment
{findings from step 4}
### UX Alignment
{findings from step 4}

## Project & Issue Quality
### Project (Epic) Validation
{findings from step 5}
### Issue (Story) Quality
{findings from step 5}
### Dependency Analysis
{findings from step 5}

## Summary and Recommendations
### Overall Readiness Status
{verdict with justification}
### Critical Issues Requiring Immediate Action
{list of critical issues}
### Recommended Next Steps
1. {action item 1}
2. {action item 2}
3. {action item 3}

### Final Note
This assessment identified {X} issues across {Y} categories. Address the critical issues before proceeding to implementation.
```

Generate the report in {document_output_language}.

### 6.4 Publish to Linear Document

Invoke the `write-to-linear-doc` task from `{project-root}/_aria/linear/tasks/write-to-linear-doc.md` with:

```
title: "[{linear_team_name}] Implementation Readiness Report: {project_name} ({date})"
body_content: "{compiled_readiness_report}"
key_map_id: "readiness_report"
```

Update `{key_map_file}` with the new Linear Document ID under `documents.readiness_report`.

### 6.5 Post Project-Specific Comments in Linear

For each Project (Epic), post a summary comment on a representative issue with findings specific to that Project:

<action>Call `list_issues` with `project: "{project_id}"` and `limit: 1` to find a representative issue</action>

Call `save_comment` with:

```
issueId: "{representative_issue_id}"
body: |
  ## Implementation Readiness: {verdict}

  **Date:** {date}
  **Report:** See Linear Document "{readiness_report_title}"

  ### Project-Specific Findings
  {findings_for_this_project}

  ### Action Items
  {action_items_for_this_project}
```

### 6.6 Post Handoff

Invoke the `post-handoff` task from `{project-root}/_aria/linear/tasks/post-handoff.md` with:

```
handoff_to: "SM"
handoff_type: "readiness_complete"
summary: "Implementation readiness check completed. Verdict: {verdict}. Report published to Linear Document."
document_id: "{readiness_report_document_id}"
```

### 6.7 Report to User

"**Implementation Readiness: {verdict}**

- **Linear Document:** {readiness_report_title}
- **Projects Reviewed:** {project_count}
- **Issues Reviewed:** {issue_count}
- **Findings:** {critical_count} critical, {major_count} major, {minor_count} minor"

{if verdict == "READY" or verdict == "READY WITH NOTES"}
"**Next Steps:**
1. Begin Phase 4 with **Sprint Planning** to create the first cycle
2. Use **Create Story** to prepare stories with full dev context"
{end_if}

{if verdict == "NOT READY"}
"**Action Required:**
{list_of_critical_gaps}
Address these gaps before beginning implementation."
{end_if}

### 6.8 Help

Invoke the help task at `{project-root}/_aria/linear/tasks/help.md` to present context-aware next-step recommendations to the user.

### Success Criteria
- All findings compiled from steps 2-5 with evidence
- Clear verdict assigned with justification
- Readiness report published to Linear Document
- Project-specific comments posted on representative issues
- Handoff posted to SM agent
- User understands verdict and required next steps

### Failure Modes
- Not reviewing findings from all previous steps
- Assigning READY verdict when critical gaps exist
- Not publishing report to Linear Document
- Not posting Project-specific comments
- Missing handoff to SM agent

</step>

</workflow>
