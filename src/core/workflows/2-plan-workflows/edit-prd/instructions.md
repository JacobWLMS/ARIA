# Edit PRD — Document Update

<critical>You MUST have already loaded and processed: the workflow.yaml for this workflow</critical>

<workflow>

<step n="1" goal="Load the PRD and any feedback from the platform">

**Progress: Step 1 of 5** — Next: Discover Edit Requirements

### Role & Communication

- Communicate in {communication_language} with {user_name}
- You are a Validation Architect and PRD Improvement Specialist
- Engage in collaborative dialogue, not command-response
- You bring analytical expertise and improvement guidance; the user brings domain knowledge and edit requirements

### 1.1 Locate the PRD on the platform

Invoke the `read-context` task from `{project-root}/_aria/core/tasks/read-context.md` with `context_type: "document"` and `scope_key: "prd"` to locate the PRD document.

If the PRD is not found via key map, search the platform directly:
- Invoke the `read-context` task with `context_type: "document_artefact"` and `query: "PRD"` to search for documents with "PRD" or "Product Requirements" in the title

If multiple PRD documents are found, present candidates and ask the user to select one.

If no PRD is found at all:
- "I cannot find an existing PRD on the platform. Please check or create one first with Create PRD."
- EXIT workflow.

### 1.2 Load Full PRD Content

Load the full PRD content via the `read-context` task with the selected document ID. Store the `document_id`, `title`, and content for later update.

### 1.3 Load Feedback and Comments

Load any existing comments on the PRD:
- Call `list_comments` with the document context to retrieve validation findings and feedback

### 1.4 Detect PRD Format

Analyze the loaded PRD content. Extract all ## Level 2 headers and check for ARIA PRD core sections:
1. Executive Summary
2. Success Criteria
3. Product Scope
4. User Journeys
5. Functional Requirements
6. Non-Functional Requirements

Classify format:
- **ARIA Standard:** 5-6 core sections present
- **ARIA Variant:** 3-4 core sections present, generally follows ARIA patterns
- **Legacy (Non-Standard):** Fewer than 3 core sections, does not follow ARIA structure

### 1.5 Announce Edit Mode

"**Edit Mode: Updating existing PRD on the platform.**

**PRD:** {prd_title}
**Format:** {classification}
**Comments found:** {comment_count}"

### Success Criteria
- PRD located and fully loaded from the platform
- Comments retrieved
- PRD format classified correctly
- Document metadata (ID) stored for update

### Failure Modes
- Not checking key map before searching
- Not loading comments that contain validation findings
- Missing format classification

</step>

<step n="2" goal="Discover what changes are needed and build a change plan">

**Progress: Step 2 of 5** — Next: Review Change Plan

### Step Goal

Understand what the user wants to edit, assess validation findings (if comments exist), and build a detailed section-by-section change plan.

### 2.1 Surface Validation Findings

If comments contain validation findings, summarise them:

| # | Severity | Section | Finding |
|---|---|---|---|
| 1 | Critical | Functional Requirements | Missing traceability to user needs |
| 2 | Major | Acceptance Criteria | Non-measurable criteria in AC-3 |

Ask the user:

"I found {comment_count} review comments on the PRD. Would you like to:

1. **Address all findings** — Systematically resolve every comment
2. **Address specific findings** — Select which findings to address
3. **Make custom changes** — Describe what you want to change instead
4. **Both** — Address findings AND make additional changes"

{if autonomy_level == "interactive"}
  Wait for user selection.
{else}
  If comments contain critical findings, auto-select option 1 (address all).
  {if autonomy_level == "balanced"}
    "Recommending option 1 (address all findings). Press Enter to confirm or select a different option."
  {end_if}
{end_if}

If no comments exist, ask the user to describe the changes they want to make:

"What would you like to edit in this PRD?

- Fix specific issues (information density, implementation leakage, etc.)
- Add missing sections or content
- Improve structure and flow
- General improvements
- Other changes

**Describe your edit goals:**"

Wait for user input.

### 2.2 Legacy PRD Conversion Assessment (if applicable)

If the PRD was classified as Legacy (Non-Standard) in step 1:

Perform a gap analysis against ARIA standard structure. For each of the 6 core sections, assess:
- **Present:** Yes / No / Partial
- **Gap:** What is missing or incomplete
- **Effort:** Minimal / Moderate / Significant

Present the assessment:

"**Legacy PRD — Conversion Assessment**

Core sections present: {count}/6
Overall conversion effort: {Quick / Moderate / Substantial}

**How would you like to proceed?**

- [R] Restructure to ARIA — Convert to ARIA format, then apply your edits
- [I] Targeted Improvements — Apply edits to existing structure without restructuring
- [E] Edit & Restructure — Do both: convert format AND apply your edits"

Wait for user selection and note the conversion mode.

### 2.3 Build Change Plan

Organise changes by PRD section. For each section (in order):
- **Current State:** Brief description of what exists
- **Issues Identified:** From validation comments or manual analysis
- **Changes Needed:** Specific changes required
- **Priority:** Critical / High / Medium / Low
- **User Requirements Met:** Which user edit goals this addresses

Include:
- Sections to add (if missing)
- Sections to update (if present but needs work)
- Content to remove (if incorrect or contains implementation leakage)
- Structure changes (if reformatting needed)

Summarise the plan:

**Changes by Type:**
- **Additions:** {count} sections to add
- **Updates:** {count} sections to update
- **Removals:** {count} items to remove
- **Restructuring:** {yes/no}

**Priority Distribution:**
- **Critical:** {count} changes
- **High:** {count} changes
- **Medium:** {count} changes

**Estimated Effort:** {Quick / Moderate / Substantial}

### 2.4 Present Change Plan

"**Deep Review Complete — Change Plan**

**PRD Analysis:** {brief summary of current state}

{if validation comments exist:}
**Validation Findings:** {count} issues identified: {critical} critical, {warning} warnings
{end_if}

**Your Edit Requirements:** {summary of user's goals}

**Proposed Change Plan:**

**By Section:**
{section-by-section breakdown}

**By Priority:**
- Critical: {count} items
- High: {count} items
- Medium: {count} items

**Estimated Effort:** {effort level}

**Questions:**
1. Does this change plan align with what you had in mind?
2. Any sections I should add/remove/reprioritise?
3. Any concerns before I proceed with edits?"

### 2.5 Menu

"**Select:** [A] Advanced Elicitation [P] Party Mode [C] Continue to Apply Edits (Step 3 of 5)"

- IF A: Invoke `{project-root}/_aria/shared/tasks/advanced-elicitation.md` with the current change plan. Process enhanced insights. Ask user if they accept improvements. If yes, update plan and redisplay menu. If no, keep original and redisplay menu.
- IF P: Invoke `{project-root}/_aria/shared/workflows/party-mode/instructions.md` with the current change plan. Process collaborative insights. Ask user if they accept changes. If yes, update and redisplay. If no, keep original and redisplay.
- IF C: Proceed to step 3.

{if autonomy_level == "interactive"}
  Wait for user selection and plan confirmation before proceeding.
{else}
  Auto-proceed with C after presenting the plan.
  {if autonomy_level == "balanced"}
    Wait briefly for user override.
  {end_if}
{end_if}

### Success Criteria
- Validation findings surfaced and categorised by severity
- User edit requirements clearly understood
- Legacy conversion assessed if applicable
- Section-by-section change plan built with priorities
- User confirms or adjusts the plan before proceeding

### Failure Modes
- Not surfacing validation comments as actionable findings
- Building a superficial plan without section-by-section breakdown
- Proceeding without user approval of the plan
- Missing legacy conversion assessment when PRD is non-standard

</step>

<step n="3" goal="Apply approved changes to the PRD content">

**Progress: Step 3 of 5** — Next: Update document

### Step Goal

Execute the approved change plan section by section. Apply content updates, structure improvements, and format conversion (if needed) to produce the updated PRD content.

### 3.1 Announce Edit Start

"**Starting PRD Edits**

**Change Plan:** {summary}
**Total Changes:** {count}
**Estimated Effort:** {effort level}

**Proceeding with edits section by section...**"

### 3.2 Execute Changes Section by Section

For each section in the approved plan (in priority order):

**a) Review current section content** — Read the existing content and note what exists.

**b) Apply changes per plan:**
- **Additions:** Create new sections with proper content
- **Updates:** Modify existing content per plan
- **Removals:** Remove specified content (implementation leakage, filler, etc.)
- **Restructuring:** Reformat content to ARIA standard structure

**c) Apply ARIA PRD quality standards:**
- High information density (no filler)
- Measurable requirements with clear thresholds
- Clear structure with proper markdown formatting
- No implementation leakage (keep requirements abstract from implementation)
- Proper traceability between sections

**d) Report progress after each section:**
"**Section Updated:** {section_name}
Changes: {brief summary}
{More sections remaining...}"

### 3.3 Handle Restructuring (if conversion mode selected)

If the user chose restructuring in step 2:

Reorganise the PRD to follow ARIA standard structure:
1. Executive Summary
2. Success Criteria
3. Product Scope
4. User Journeys
5. Domain Requirements (if applicable)
6. Innovation Analysis (if applicable)
7. Project-Type Requirements
8. Functional Requirements
9. Non-Functional Requirements

Ensure proper ## Level 2 headers and logical section ordering.

"**PRD Restructured** — ARIA standard structure applied.
{Sections added/reordered}"

### 3.4 Generate Document in Output Language

Generate all edited content in {document_output_language}.

### 3.5 Final Verification

Review the complete updated PRD:
- All approved changes applied correctly
- PRD structure is sound
- No unintended modifications
- No inconsistencies introduced between sections

If issues found, fix them and note corrections.

### 3.6 Present Edit Summary

"**PRD Edits Complete**

**Changes Applied:** {count} sections modified
**Summary of Changes:**
{bulleted list of major changes}

Ready to publish to the platform."

{if autonomy_level == "interactive"}
  "Review the changes above. [C] Continue to publish, or [A] Adjust to make additional edits?"
  Wait for user confirmation.
{else}
  Auto-proceed to step 4.
  {if autonomy_level == "balanced"}
    Wait briefly for user override.
  {end_if}
{end_if}

### Success Criteria
- All approved changes from step 2 applied correctly
- Changes executed in priority order
- Restructuring completed if conversion mode was selected
- Quality standards enforced (density, measurability, no leakage)
- Final verification confirms changes are consistent

### Failure Modes
- Making changes beyond the approved plan without user approval
- Not following priority order
- Skipping restructuring when conversion mode was selected
- Introducing inconsistencies between sections

</step>

<step n="4" goal="Update the document with the edited PRD">

**Progress: Step 4 of 5** — Next: Report and Recommend

### 4.1 Compile Updated Content

Compile the complete updated PRD content with all approved changes applied into a single document body.

### 4.2 Update document

Call `update_document` with:

```
document_id: "{prd_document_id}"
title: "{existing_document_title}"
content: "{updated_prd_content}"
```

### 4.3 Update Key Map

Update `{key_map_file}` if the document ID or title changed.

### 4.4 Track Addressed Findings

If changes were made in response to comments, note which findings have been fully addressed. The resolved comments will serve as a record of what was fixed.

### Success Criteria
- document updated successfully with full content
- Key map updated if needed
- Comment resolution tracked

### Failure Modes
- Not including the complete PRD content in the update
- Not updating key map when metadata changes

</step>

<step n="5" goal="Report changes and recommend next steps">

**Progress: Step 5 of 5** — Final Step

### 5.1 Report Completion

"**PRD Updated**

- **document:** {prd_document_title}
- **Changes Applied:** {change_count}
- **Sections Modified:** {modified_sections_list}

**Change Summary:**
{brief_description_of_each_change}

**PRD is now ready for:**
- Downstream workflows (UX Design, Architecture)
- Validation to re-check quality if major changes were made
- Production use"

### 5.2 Recommend Next Steps

**Next Steps:**
1. Review the updated PRD on the platform
2. Run **Validate PRD** to re-check quality if major changes were made
3. Proceed with **Create Architecture** or **Create UX Design** when satisfied

### 5.3 Help and Handoff

Invoke the help task at `{project-root}/_aria/core/tasks/help.md` to present context-aware next-step recommendations to the user.

### Success Criteria
- Complete change summary reported to user
- Appropriate next steps recommended based on scope of changes
- Help task invoked for context-aware guidance

### Failure Modes
- Missing changes in summary
- Not recommending validation after major edits
- Not invoking help task

</step>

</workflow>
