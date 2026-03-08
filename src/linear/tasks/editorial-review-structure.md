---
name: editorial-review-structure
description: 'Review document organization for logical flow, section coherence, and information architecture. Posts suggestions to Linear.'
---

# Task: Editorial Review -- Structure

**Purpose:** Analyze a Linear document's organization -- section ordering, heading hierarchy, information grouping, and logical flow. Proposes cuts, reorganizations, and simplifications while preserving comprehension. Posts findings as a comment on the associated issue.

---

## Parameters

| Parameter | Required | Description |
|---|---|---|
| `target` | Yes | Linear document ID or slug |
| `issue_id` | No | Linear issue ID to post findings on (if not provided, output to console) |

---

## Execution

<workflow>

<step n="1" goal="Load the Linear document content">
<action>Call `get_document` with `id: "{target}"` to load the full document content</action>
<action>Record the full document content, ID, title, and extract the heading hierarchy (H1, H2, H3, etc.)</action>
<action>If the document content contains embedded images (markdown image syntax or Linear-hosted URLs), call `extract_images` with the document content to view diagrams and screenshots. Diagrams often encode structural information (flow charts, architecture diagrams, entity relationships) that should be evaluated alongside the textual structure.</action>
</step>

<step n="2" goal="Map the current document structure">

Build a structural outline of the document:

```
Current Structure:
- H1: {title}
  - H2: {section 1}
    - H3: {subsection}
  - H2: {section 2}
  ...
```

For each section, note:
- Approximate word count
- Key topics covered
- Dependencies on other sections (references, forward/backward)
</step>

<step n="3" goal="Analyze structure across all dimensions">

Evaluate the document organization against these criteria:

| Dimension | What to look for |
|---|---|
| **Section Ordering** | Does the sequence follow a logical progression? Does the reader have the context they need when they need it? Are prerequisites introduced before they are referenced? |
| **Heading Hierarchy** | Are heading levels used consistently? Do H3s belong under their parent H2? Are there skipped levels (H1 to H3)? Are headings descriptive enough to serve as a table of contents? |
| **Information Grouping** | Are related concepts scattered across sections? Could sections be merged? Are there sections that cover too many distinct topics? |
| **Redundancy Between Sections** | Is the same information stated in multiple places? Are there sections that largely repeat each other? |
| **Missing Sections** | Are there expected sections for this document type that are absent? (e.g., a design doc without a "Risks" section, a spec without "Non-Goals") |
| **Logical Flow** | Does each section naturally lead to the next? Are there jarring transitions? Would a reader feel lost at any point? |
| **Section Weight** | Are some sections disproportionately long or short relative to their importance? |

For each finding, record:
- **Type:** Reorder / Merge / Split / Cut / Add / Rename
- **Target:** Which section(s) are affected
- **Rationale:** Why the change improves comprehension
- **Proposed Change:** Specific recommendation
</step>

<step n="4" goal="Generate proposed restructured outline">

If significant restructuring is warranted, propose a new outline:

```
## Editorial Review -- Structure

**Document:** {document_title}
**Reviewed:** {timestamp}

### Current Structure
{current outline with section word counts}

### Findings

| # | Type | Section(s) | Rationale | Proposed Change |
|---|---|---|---|---|
| 1 | {type} | {section} | {why} | {what to do} |
| ... | ... | ... | ... | ... |

### Proposed Structure
{new outline showing the recommended organization}

- Sections marked with [NEW] are additions
- Sections marked with [CUT] should be removed or absorbed
- Sections marked with [MOVED] indicate repositioning
- Sections marked with [MERGED] indicate consolidation

---

**Overall Assessment:**
{2-3 sentence summary: is this a minor tune-up or a significant reorganization? What is the single biggest structural improvement?}
```
</step>

<step n="5" goal="Post findings">

**If `issue_id` is provided:**
<action>Call `save_comment` with `issueId: "{issue_id}"` and `body: "{formatted_findings}"`</action>

**If no `issue_id`:**
<action>Print the formatted findings to the console output</action>

<action>Do NOT call `update_document` -- this task produces suggestions only, never modifies the document content</action>
</step>

</workflow>

---

## Return Value

Returns the document ID and the count of structural findings posted. The author reviews the findings and applies reorganization at their discretion.
