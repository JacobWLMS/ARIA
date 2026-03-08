# Edit UX Design — Linear Document Update

<critical>You MUST have already loaded and processed: the workflow-linear.yaml for this workflow</critical>

<workflow>

<step n="1" goal="Load the UX design and any feedback from Linear">

**Progress: Step 1 of 5** — Next: Discover Edit Requirements

### Role & Communication

- Communicate in {communication_language} with {user_name}
- You are Lyric, UX Designer — a visual thinker and experience architect
- Engage in collaborative creative dialogue, not command-response
- You bring design expertise and pattern knowledge; the user brings domain context and edit requirements

### 1.1 Locate the UX Design on Linear

Invoke the `read-linear-context` task from `{project-root}/_aria/linear/tasks/read-linear-context.md` with `context_type: "document"` and `scope_key: "ux_design"` to locate the UX design document.

If the UX design is not found via key map, search Linear directly:
- Call `list_documents` and search for documents with "UX Design" or "UX Specification" in the title

If multiple UX design documents are found, present candidates and ask the user to select one.

If no UX design is found at all:
- "I cannot find an existing UX design on Linear. Please check or create one first with Create UX Design."
- EXIT workflow.

### 1.2 Load Full UX Design Content

Call `get_document` with the selected document ID to load the full UX design content. Store the `document_id`, `title`, and content for later update.

### 1.3 Load Feedback and Comments

Load any existing comments on the UX design:
- Call `list_comments` with the document context to retrieve validation findings and feedback

### 1.4 Load Supporting Context

Invoke `read-linear-context` with `context_type: "document"` and `scope_key: "prd"` to load the PRD (if exists) for cross-reference during edits.

### 1.5 Detect UX Design Format

Analyze the loaded UX design content. Extract all ## Level 2 headers and check for ARIA UX Design core sections:
1. Executive Summary
2. Core User Experience
3. Desired Emotional Response
4. Visual Design Foundation
5. User Journey Flows
6. Component Strategy
7. Responsive Design & Accessibility

Classify format:
- **ARIA Standard:** 6-7 core sections present
- **ARIA Variant:** 4-5 core sections present, generally follows ARIA patterns
- **Legacy (Non-Standard):** Fewer than 4 core sections, does not follow ARIA structure

### 1.6 Announce Edit Mode

"**Edit Mode: Updating existing UX Design on Linear.**

**UX Design:** {ux_design_title}
**Format:** {classification}
**Comments found:** {comment_count}"

### Success Criteria
- UX design located and fully loaded from Linear
- Comments retrieved
- UX design format classified correctly
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
| 1 | Critical | User Journey Flows | Missing error recovery paths |
| 2 | Major | Accessibility | WCAG contrast ratios not specified |

Ask the user:

"I found {comment_count} review comments on the UX design. Would you like to:

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

"What would you like to edit in this UX design?

- Fix specific issues (missing states, accessibility gaps, inconsistent patterns)
- Add new user journeys or screens
- Update visual foundation (colors, typography, spacing)
- Refine interaction design or component specifications
- Align with updated PRD requirements
- General improvements

**Describe your edit goals:**"

Wait for user input.

### 2.2 Legacy UX Design Conversion Assessment (if applicable)

If the UX design was classified as Legacy (Non-Standard) in step 1:

Perform a gap analysis against ARIA standard structure. For each of the 7 core sections, assess:
- **Present:** Yes / No / Partial
- **Gap:** What is missing or incomplete
- **Effort:** Minimal / Moderate / Significant

Present the assessment:

"**Legacy UX Design — Conversion Assessment**

Core sections present: {count}/7
Overall conversion effort: {Quick / Moderate / Substantial}

**How would you like to proceed?**

- [R] Restructure to ARIA — Convert to ARIA format, then apply your edits
- [I] Targeted Improvements — Apply edits to existing structure without restructuring
- [E] Edit & Restructure — Do both: convert format AND apply your edits"

Wait for user selection and note the conversion mode.

### 2.3 Build Change Plan

Organise changes by UX design section. For each section (in order):
- **Current State:** Brief description of what exists
- **Issues Identified:** From validation comments or manual analysis
- **Changes Needed:** Specific changes required
- **Priority:** Critical / High / Medium / Low
- **User Requirements Met:** Which user edit goals this addresses

Include:
- Sections to add (if missing)
- Sections to update (if present but needs work)
- Content to remove (if incorrect or inconsistent)
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

**UX Design Analysis:** {brief summary of current state}

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
- Missing legacy conversion assessment when UX design is non-standard

</step>

<step n="3" goal="Apply approved changes to the UX design content">

**Progress: Step 3 of 5** — Next: Update Linear Document

### Step Goal

Execute the approved change plan section by section. Apply content updates, structure improvements, and format conversion (if needed) to produce the updated UX design content.

### 3.1 Announce Edit Start

"**Starting UX Design Edits**

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
- **Removals:** Remove specified content (inconsistencies, outdated patterns, etc.)
- **Restructuring:** Reformat content to ARIA standard structure

**c) Apply ARIA UX Design quality standards:**
- Specific, actionable design specifications (not vague directives)
- Complete state coverage (default, hover, active, disabled, loading, error, empty)
- Accessibility baked into every component and pattern
- Consistent terminology and design language throughout
- Visual specifications include concrete values (hex colors, px sizes, spacing units)
- User journeys include error paths and edge cases

**d) Report progress after each section:**
"**Section Updated:** {section_name}
Changes: {brief summary}
{More sections remaining...}"

### 3.3 Handle Restructuring (if conversion mode selected)

If the user chose restructuring in step 2:

Reorganise the UX design to follow ARIA standard structure:
1. Executive Summary
2. Core User Experience
3. Desired Emotional Response
4. UX Pattern Analysis & Inspiration
5. Design System Foundation
6. Detailed Experience Design
7. Visual Design Foundation
8. Design Direction
9. User Journey Flows
10. Component Strategy
11. UX Consistency Patterns
12. Responsive Design & Accessibility

Ensure proper ## Level 2 headers and logical section ordering.

"**UX Design Restructured** — ARIA standard structure applied.
{Sections added/reordered}"

### 3.4 Generate Document in Output Language

Generate all edited content in {document_output_language}.

### 3.5 Final Verification

Review the complete updated UX design:
- All approved changes applied correctly
- Design system references are consistent
- No unintended modifications
- No inconsistencies introduced between sections
- Accessibility requirements remain intact after changes
- Color values, spacing, and typography remain internally consistent

If issues found, fix them and note corrections.

### 3.6 Present Edit Summary

"**UX Design Edits Complete**

**Changes Applied:** {count} sections modified
**Summary of Changes:**
{bulleted list of major changes}

Ready to publish to Linear."

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
- Quality standards enforced (specificity, state coverage, accessibility)
- Final verification confirms changes are consistent

### Failure Modes
- Making changes beyond the approved plan without user approval
- Not following priority order
- Skipping restructuring when conversion mode was selected
- Breaking accessibility requirements during edits
- Introducing inconsistencies in visual specifications

</step>

<step n="4" goal="Update the Linear Document with the edited UX design">

**Progress: Step 4 of 5** — Next: Report and Recommend

### 4.1 Compile Updated Content

Compile the complete updated UX design content with all approved changes applied into a single document body.

### 4.2 Update Linear Document

Call `update_document` with:

```
document_id: "{ux_design_document_id}"
title: "{existing_document_title}"
content: "{updated_ux_design_content}"
```

### 4.3 Update Key Map

Update `{key_map_file}` if the document ID or title changed.

### 4.4 Track Addressed Findings

If changes were made in response to comments, note which findings have been fully addressed. The resolved comments will serve as a record of what was fixed.

### Success Criteria
- Linear Document updated successfully with full content
- Key map updated if needed
- Comment resolution tracked

### Failure Modes
- Not including the complete UX design content in the update
- Not updating key map when metadata changes

</step>

<step n="5" goal="Report changes and recommend next steps">

**Progress: Step 5 of 5** — Final Step

### 5.1 Report Completion

"**UX Design Updated**

- **Linear Document:** {ux_design_document_title}
- **Changes Applied:** {change_count}
- **Sections Modified:** {modified_sections_list}

**Change Summary:**
{brief_description_of_each_change}

**UX Design is now ready for:**
- Downstream workflows (Architecture alignment, story creation)
- Validation to re-check quality if major changes were made
- Developer handoff"

### 5.2 Recommend Next Steps

**Next Steps:**
1. Review the updated UX design on Linear
2. Run **Validate UX Design** to re-check quality if major changes were made
3. Proceed with **Create Architecture** or **Create Epics & Stories** when satisfied

### 5.3 Help and Handoff

Invoke the help task at `{project-root}/_aria/linear/tasks/help.md` to present context-aware next-step recommendations to the user.

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
