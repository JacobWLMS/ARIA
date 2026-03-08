# Validate UX Design — Document Review

<critical>You MUST have already loaded and processed: the workflow.yaml for this workflow</critical>

## Overview

Validates an existing UX design on the platform through a comprehensive 10-step validation methodology. Each step performs a specific quality check, building a cumulative findings list. After all checks complete, posts a comment on the document with the overall validation verdict and creates a validation report. This is not a casual review — it is a rigorous, systematic validation against ARIA UX Design standards.

---

<workflow>

<step n="1" goal="Document discovery — locate and load the UX design from the platform">
<action>Communicate in {communication_language} with {user_name}</action>
<action>Announce: "**Validate Mode: Comprehensive UX design validation against ARIA quality standards.**"</action>

<action>Invoke the `read-context` task from `{project-root}/_aria/core/tasks/read-context.md` with `context_type: "document"` and `scope_key: "ux_design"` to locate the UX design document</action>

<action>If the UX design is not found via key map, search the platform directly:</action>
<action>Invoke the `read-context` task with `context_type: "document_artefact"` and `query: "UX Design"` to search for documents with "UX Design" or "UX Specification" in the title</action>

<action>If multiple UX design documents are found, present candidates and ask the user to select one</action>
<action>If no UX design documents are found, ask user to provide the document title or ID</action>
<action>Load the full UX design content via the `read-context` task with the selected document ID</action>

<action>Store the UX design document ID, title, and full body content for use in all subsequent steps</action>

<action>Load the PRD if available:</action>
<action>Invoke `read-context` with `context_type: "document"` and `scope_key: "prd"` to load the PRD for cross-validation</action>

<action>Load the UX design checklist from `{checklist}` — the master checklist of UX design quality criteria</action>

<action>Initialize an internal findings list. Each finding will have: section, severity (Critical/Major/Minor), check_name, finding text, and recommendation. This list accumulates across all steps and is posted to the platform at the end.</action>
</step>

<step n="2" goal="Format detection — classify UX design structure and determine validation scope">
<action>Extract all Level 2 (##) headers from the UX design content</action>
<action>List them in order — this is the UX design's structural skeleton</action>

<action>Check for the 7 ARIA UX Design core sections (accept common variations):</action>

1. **Executive Summary** — also matches: Overview, Project Understanding, UX Vision
2. **Core User Experience** — also matches: Core Experience, Defining Experience, Experience Definition
3. **Desired Emotional Response** — also matches: Emotional Design, Emotional Goals, Emotional Journey
4. **Visual Design Foundation** — also matches: Visual Foundation, Colors & Typography, Design Tokens
5. **User Journey Flows** — also matches: User Flows, Journey Maps, Interaction Flows
6. **Component Strategy** — also matches: Component Library, Component Specifications, UI Components
7. **Responsive Design & Accessibility** — also matches: Accessibility, Responsive Strategy, Inclusive Design

<action>Count how many of the 7 core sections are present and classify:</action>

- **ARIA Standard** (6-7 present) — UX design follows ARIA structure closely. Proceed with full validation.
- **ARIA Variant** (4-5 present) — Recognizable as ARIA-style with structural differences. Proceed with full validation, noting missing sections.
- **Non-Standard** (0-3 present) — Does not follow ARIA structure. Ask user whether to proceed with validation as-is or exit.

<action>For Non-Standard UX designs, present the user with options:</action>

- **[A] Parity Check** — Analyze each of the 7 missing core sections, estimate the effort to add them, and present a gap summary before continuing
- **[B] Validate As-Is** — Proceed with validation using the current structure
- **[C] Exit** — Exit validation and report format findings

<action>For ARIA Standard and Variant, auto-proceed to Step 3 without pausing</action>

<action>Record format findings internally:</action>
- Format classification
- Sections present vs missing
- Count of core sections matched
</step>

<step n="3" goal="Parity check — compare UX design structure against ARIA template for missing or empty sections">
<action>Compare the UX design's actual sections against the full ARIA UX Design template structure</action>

<action>For each expected ARIA section, determine:</action>

- **Present and populated** — Section exists and has substantive content (detailed specifications, not just a sentence)
- **Present but shallow** — Section exists but contains only a sentence or two, placeholder text, or generic advice
- **Missing entirely** — Section header not found in the UX design

<action>Check specifically for placeholder indicators:</action>

- Template variables: `{variable}`, `{{variable}}`, `[placeholder]`, `[TBD]`, `TODO`
- Boilerplate phrases: "To be determined", "Will be defined later", "Pending design exploration"
- Empty sections: Section header followed immediately by another header with no content between

<action>Build the parity matrix:</action>

| Section | Status | Notes |
|---------|--------|-------|
| Executive Summary | Present/Shallow/Missing | {specific notes} |
| Core User Experience | Present/Shallow/Missing | {specific notes} |
| Desired Emotional Response | Present/Shallow/Missing | {specific notes} |
| Visual Design Foundation | Present/Shallow/Missing | {specific notes} |
| User Journey Flows | Present/Shallow/Missing | {specific notes} |
| Component Strategy | Present/Shallow/Missing | {specific notes} |
| Responsive Design & Accessibility | Present/Shallow/Missing | {specific notes} |

<action>Scoring:</action>

- **Pass** — All 7 core sections present and populated
- **Needs Improvement** — 1-2 sections shallow or missing
- **Fail** — 3+ sections shallow or missing, or any section contains only placeholder text

<action>For each missing or shallow section, add a finding:</action>

- Severity: **Critical** if User Journey Flows, Component Strategy, or Responsive Design & Accessibility are missing; **Major** if Executive Summary, Core User Experience, or Visual Design Foundation are missing; **Minor** if a section exists but is shallow
- Finding: "[Section] is {missing/contains only placeholder text/has insufficient content}"
- Recommendation: Specific guidance on what content should be added
</step>

<step n="4" goal="User research validation — verify personas, journeys, and pain points are grounded">
<action>Validate user research foundations across the UX design</action>

<action>**Personas:**</action>
- Are user personas defined with behavioral attributes (not just demographics)?
- Do personas include goals, frustrations, context of use, and tech proficiency?
- Are personas referenced in subsequent sections (journeys, components, accessibility)?
- Flag personas that are demographic-only ("25-35 year old professionals") without behavioral depth

<action>**User Journeys:**</action>
- Are user journeys mapped end-to-end (entry to completion)?
- Do journeys include decision points with branching paths?
- Are error paths and recovery flows documented?
- Do journeys map to PRD user stories (if PRD loaded)?
- Flag journeys that only show the happy path without error states

<action>**Pain Points:**</action>
- Are current user pain points identified and explicitly addressed in the design?
- Do design decisions reference specific pain points they resolve?
- Are pain points grounded in research or stated assumptions (not invented)?

<action>Scoring:</action>

- **Fail** — No personas defined, or journeys missing error paths entirely
- **Needs Improvement** — Personas shallow, or journeys incomplete, or pain points not connected to design decisions
- **Pass** — Personas behavioral, journeys complete with error paths, pain points addressed in design

<action>For each issue, add a finding:</action>

- Severity: **Critical** if no personas or no user journeys; **Major** if personas lack behavioral depth or journeys lack error paths; **Minor** if pain points are not explicitly connected to design decisions
- Finding: "{specific issue with user research coverage}"
- Recommendation: "{specific improvement}"
</step>

<step n="5" goal="Information architecture validation — navigation, hierarchy, and content structure">
<action>Validate information architecture across the UX design</action>

<action>**Navigation Structure:**</action>
- Is the navigation model clearly defined (tabs, sidebar, breadcrumbs, etc.)?
- Is the navigation consistent across device types?
- Is the information hierarchy logical (primary > secondary > tertiary)?
- Does the navigation support the most common user tasks with minimal clicks/taps?
- Are navigation patterns consistent with the chosen design system?

<action>**Content Hierarchy:**</action>
- Is the content hierarchy documented (what appears first, what's nested)?
- Are content priorities clear for each screen or view?
- Is the hierarchy consistent across similar screens?

<action>**Sitemap / Screen Inventory:**</action>
- Is there a complete inventory of screens or views?
- Are relationships between screens documented (parent/child, lateral)?
- Are entry points and exit points defined for key flows?

<action>Scoring:</action>

- **Fail** — No navigation structure defined, or major content hierarchy gaps
- **Needs Improvement** — Navigation defined but incomplete, or hierarchy inconsistent across screens
- **Pass** — Navigation clear and consistent, hierarchy documented, screen relationships mapped

<action>For each issue, add a finding with severity, description, and recommendation</action>
</step>

<step n="6" goal="Interaction design validation — flows, states, and error handling">
<action>Validate interaction design quality</action>

<action>**User Flows:**</action>
- Are key user flows documented step-by-step?
- Do flows include all interaction states (initiation, interaction, feedback, completion)?
- Are decision points clearly marked with branching paths?
- Are Mermaid diagrams or equivalent flow visualizations included?

<action>**Key Interactions:**</action>
- Is the core interaction (defining experience) specified in detail?
- Are interaction mechanics concrete enough for a developer to implement?
- Are feedback mechanisms defined (visual, auditory, haptic)?
- Are loading states specified for async operations?

<action>**Error States:**</action>
- Are error states defined for all key interactions?
- Do error messages explain what went wrong AND how to recover?
- Are empty states designed (not just "no results found")?
- Is form validation timing specified (inline, on blur, on submit)?
- Are edge cases documented (network failure, permission denied, timeout)?

<action>Scoring:</action>

- **Fail** — Key flows missing, or no error states defined
- **Needs Improvement** — Flows exist but lack error paths, or error states are generic
- **Pass** — Flows complete with error paths, interactions specified in detail, error states thoughtful

<action>For each issue, add a finding:</action>

- Severity: **Critical** if key user flows are missing entirely; **Major** if flows lack error paths or error states are undefined; **Minor** if edge cases are missing or error messages are generic
- Finding: "{specific interaction design issue}"
- Recommendation: "{specific improvement}"
</step>

<step n="7" goal="Visual design validation — design system, typography, color, and spacing">
<action>Validate visual design specifications</action>

<action>**Design System:**</action>
- Is a design system referenced or defined?
- Is the selection rationale documented?
- Is the customization strategy specified?

<action>**Typography:**</action>
- Is a complete type scale defined (h1 through caption)?
- Are font families specified with fallbacks?
- Are line heights and letter spacing defined?
- Are maximum line lengths specified for readability?

<action>**Color System:**</action>
- Are brand colors defined with hex values?
- Are semantic colors defined (success, error, warning, info)?
- Is a neutral palette specified (backgrounds, surfaces, text hierarchy)?
- Are color contrast ratios documented against WCAG standards?

<action>**Spacing:**</action>
- Is a spacing scale defined with a base unit?
- Is a grid system specified (columns, gutters, breakpoints)?
- Are layout principles documented?

<action>Scoring:</action>

- **Fail** — No design system, or missing color/typography specifications entirely
- **Needs Improvement** — Specifications exist but are incomplete (missing contrast ratios, no spacing scale, etc.)
- **Pass** — Complete visual specifications with design system, type scale, color system, and spacing

<action>For each issue, add a finding with severity, description, and recommendation</action>
</step>

<step n="8" goal="Accessibility validation — WCAG compliance and inclusive design">
<action>Validate accessibility coverage against WCAG 2.1 AA standards</action>

<action>**Visual Accessibility:**</action>
- Are color contrast ratios specified (4.5:1 normal text, 3:1 large text)?
- Is color-independence ensured (never color alone for meaning)?
- Is `prefers-reduced-motion` respected?
- Are focus indicators defined?

<action>**Motor Accessibility:**</action>
- Are minimum touch/click target sizes specified (44x44px)?
- Is full keyboard navigation documented?
- Is tab order specified for complex components?
- Are there no time-dependent interactions (or alternatives provided)?

<action>**Cognitive Accessibility:**</action>
- Is navigation consistent across the product?
- Is plain language used in UI copy and error messages?
- Do error messages explain what went wrong AND how to fix it?
- Are help text and empty states designed to reduce confusion?

<action>**Assistive Technology:**</action>
- Are semantic HTML requirements specified?
- Are ARIA labels defined for custom components?
- Are screen reader announcements specified for dynamic content?
- Is focus management documented for modals and overlays?

<action>**Testing Strategy:**</action>
- Is accessibility testing planned (automated and manual)?
- Are specific tools mentioned (axe, Lighthouse, screen readers)?
- Is user testing with disabled participants planned?

<action>Scoring:</action>

- **Fail** — No accessibility section, or WCAG compliance target not stated
- **Needs Improvement** — Accessibility mentioned but incomplete (missing keyboard nav, no contrast ratios, no testing plan)
- **Pass** — Comprehensive accessibility coverage across visual, motor, cognitive, and assistive technology with testing strategy

<action>For each issue, add a finding:</action>

- Severity: **Critical** if no accessibility section or WCAG target not stated; **Major** if key areas missing (keyboard navigation, contrast ratios, screen reader support); **Minor** if testing strategy incomplete or specific ARIA labels missing
- Finding: "{specific accessibility issue}"
- Recommendation: "{specific improvement with WCAG reference}"
</step>

<step n="9" goal="Consistency and PRD alignment — verify internal consistency and cross-document alignment">
<action>Validate internal consistency across the UX design</action>

<action>**Internal Consistency:**</action>
- Are design patterns used consistently (same button hierarchy, same feedback patterns throughout)?
- Are terminology and naming conventions consistent?
- Do component specifications match the design system foundation?
- Are color and typography references consistent (no rogue values outside the defined system)?
- Do responsive breakpoints match across all sections?

<action>**PRD Alignment** (if PRD loaded):</action>
- Do user journeys in the UX design cover all PRD user stories?
- Are PRD functional requirements reflected in the interaction design?
- Do success criteria from the PRD have corresponding UX metrics?
- Are PRD personas consistent with UX design personas?
- Are scope boundaries respected (no UX for out-of-scope features)?

<action>**Content Strategy:**</action>
- Are microcopy guidelines defined?
- Are empty states specified with helpful messaging and CTAs?
- Is help text placement consistent?
- Is error message tone and structure consistent?

<action>Scoring:</action>

- **Fail** — Major inconsistencies across sections, or significant PRD misalignment
- **Needs Improvement** — Minor inconsistencies, or partial PRD coverage
- **Pass** — Internally consistent, PRD aligned, content strategy defined

<action>For each issue, add a finding:</action>

- Severity: **Critical** if PRD user journeys are missing from UX design; **Major** if internal inconsistencies in design patterns or PRD features not covered; **Minor** if terminology inconsistencies or minor content strategy gaps
- Finding: "{specific consistency or alignment issue}"
- Recommendation: "{specific improvement}"
</step>

<step n="10" goal="Compile results, post validation report to the platform, and hand off">
<action>Before posting results, retrieve existing comments to track review history:</action>
<action>Call `list_comments` for the UX design document context to retrieve any previous validation comments</action>
<action>Categorize previous comments: how many are open vs resolved</action>
<action>This review history will be included in the validation report</action>

<action>**Perform final checklist validation using `{checklist}`:**</action>

Run through every item in the UX design checklist. For each item, mark Pass/Fail and note specific findings. Add any new findings to the cumulative list.

<action>**Create validation report as a document:**</action>

<action>Invoke the `write-document` task from `{project-root}/_aria/core/tasks/write-document.md` with:</action>

```
title: "[{team_name}] UX Design Validation Report"
content: |
  ## UX Design Validation Report

  **Reviewer:** ARIA UX Design Validation Agent (UX Designer Lyric)
  **Date:** {date}
  **Verdict:** {PASS | PASS WITH NOTES | NEEDS REVISION}

  ### Findings Overview
  - Critical: {critical_count}
  - Major: {major_count}
  - Minor: {minor_count}

  ### Review History
  - Previous reviews: {previous_review_count}
  - New findings this review: {new_finding_count}

  ### Validation Results
  | Check | Result | Notes |
  |---|---|---|
  | Format & Structure | {pass/needs improvement/fail} | {classification}: {core_sections_count}/7 core sections |
  | Section Parity | {pass/needs improvement/fail} | {populated}/{total} sections populated |
  | User Research | {pass/needs improvement/fail} | {personas_quality}, {journeys_quality}, {pain_points_quality} |
  | Information Architecture | {pass/needs improvement/fail} | {nav_quality}, {hierarchy_quality} |
  | Interaction Design | {pass/needs improvement/fail} | {flows_quality}, {error_states_quality} |
  | Visual Design | {pass/needs improvement/fail} | {design_system}, {type_scale}, {color_system} |
  | Accessibility | {pass/needs improvement/fail} | WCAG {level}: {compliance_summary} |
  | Consistency & Alignment | {pass/needs improvement/fail} | {internal_consistency}, {prd_alignment} |
  | Checklist Completeness | {pass/needs improvement/fail} | {checklist_pass}/{checklist_total} items |

  ### Overall Quality Rating
  **{rating}/5 — {label}**

  ### Top 3 Improvements
  1. {improvement_1}
  2. {improvement_2}
  3. {improvement_3}

  ### Verdict Explanation
  {1-3 sentence explanation of why this verdict was reached, referencing the most significant findings}

  ### Detailed Findings
  {all findings with severity, section, finding text, and recommendation}
key_map_entry: "documents.ux_design_validation_report"
```

<action>**Post summary comment on the UX design document:**</action>
<action>Invoke the `post-comment` task from `{project-root}/_aria/core/tasks/post-comment.md` with:</action>

```
issue_id_or_document_context: appropriate context for the UX design
body: |
  **UX Design Validation: {verdict}**
  Quality Rating: {rating}/5
  Findings: {total_count} ({critical_count} critical, {major_count} major, {minor_count} minor)
  Full report: {validation_report_document_title}
```

<action>**Determine the overall verdict:**</action>

- **PASS** — No Critical findings AND no more than 2 Major findings. Quality rating >= 4/5. UX design is ready for architecture alignment and developer handoff.
- **PASS WITH NOTES** — No Critical findings, but 3+ Major findings OR quality rating 3/5. UX design can proceed but improvements are recommended.
- **NEEDS REVISION** — Any Critical findings exist OR quality rating <= 2/5. UX design must be revised before proceeding.

<action>**Overall Quality Rating (1-5):**</action>
- **5/5 Excellent** — Exemplary UX design. Ready for architecture and implementation.
- **4/5 Good** — Strong UX design with minor improvements needed. Can proceed.
- **3/5 Adequate** — Acceptable but needs refinement in specific areas.
- **2/5 Needs Work** — Significant gaps or quality issues. Should be revised before proceeding.
- **1/5 Problematic** — Major flaws throughout. Requires substantial revision.

<action>**Report to user:**</action>

**UX Design Validation: {verdict}**

- **document:** {ux_design_document_title}
- **Quality Rating:** {rating}/5 — {label}
- **Findings:** {total_count} ({critical_count} critical, {major_count} major, {minor_count} minor)
- **Validation Report:** {validation_report_document_title}

{if verdict is PASS}
**Next Steps:**
1. UX design is ready — proceed with [Create Architecture] or [Create Epics & Stories]
{end if}

{if verdict is PASS WITH NOTES}
**Next Steps:**
1. Review the validation report on the platform for improvement suggestions
2. Optionally run [Edit UX Design] to address major findings
3. UX design can proceed to architecture/stories in parallel
{end if}

{if verdict is NEEDS REVISION}
**Next Steps:**
1. Review the validation report on the platform for critical issues
2. Run [Edit UX Design] to address critical and major findings
3. Re-run [Validate UX Design] after revisions
{end if}

**Top 3 Improvements:**
1. {improvement_1}
2. {improvement_2}
3. {improvement_3}

<action>Invoke the `post-handoff` task from `{project-root}/_aria/core/tasks/post-handoff.md` with:</action>

```
handoff_to: "UX Designer"
handoff_type: "ux_design_validated"
summary: "UX design validation complete. Verdict: {verdict}. {critical_count} critical, {major_count} major, {minor_count} minor findings. Quality rating: {rating}/5."
document_id: "{ux_design_document_id}"
```

<action>Invoke the help task at `{project-root}/_aria/core/tasks/help.md` to present context-aware next-step recommendations to the user</action>
</step>

</workflow>
