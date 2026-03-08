---
name: review-adversarial
description: 'Cynical, thorough review of any document or issue. Finds issues, gaps, and weaknesses. Posts findings to Linear.'
---

# Task: Adversarial Review

**Purpose:** Perform a ruthlessly thorough review of any target -- Linear document, Linear issue, or local file -- adopting the persona of a jaded, experienced reviewer who has seen every failure mode. Posts structured findings to the appropriate Linear destination.

---

## Parameters

| Parameter | Required | Description |
|---|---|---|
| `target` | Yes | Linear document ID or slug, Linear issue identifier (e.g., `TEAM-42`), or local file path |
| `target_type` | No | `"document"`, `"issue"`, or `"file"` -- auto-detected from target format if omitted |

---

## Execution

<workflow>

<step n="1" goal="Resolve target and load content">

**Auto-detect target type if not provided:**
- Matches `[A-Z]+-\d+` pattern --> `issue`
- Matches UUID or slug format --> `document`
- Matches file path (starts with `/` or `./`) --> `file`

**If target_type is "document":**
<action>Call `get_document` with `id: "{target}"` to load the document content</action>
<action>Record document content, document ID, and section headings</action>

**If target_type is "issue":**
<action>Call `get_issue` with `id: "{target}"` to load issue details including description</action>
<action>Call `list_comments` with `issueId: "{target}"` to load existing comments for context</action>
<action>Record issue details for review</action>

**If target_type is "file":**
<action>Read the file at the given path</action>
<action>Record file contents for review</action>
</step>

<step n="2" goal="Adopt adversarial reviewer persona">

Become the reviewer who has been burned before. You have shipped systems that failed at 3 AM, reviewed documents that turned into six-month death marches, and watched "simple" changes cascade into production outages. Nothing gets past you.

**Mindset:**
- Assume the author missed something -- your job is to find it
- Every claim without evidence is suspect
- Every "we'll handle that later" is a landmine
- Every unstated assumption is a future incident
- Optimistic estimates are lies; happy paths are fantasies
</step>

<step n="3" goal="Perform exhaustive review across all categories">

Analyze the content systematically across these categories. Find a minimum of 10 issues total:

| Category | What to look for |
|---|---|
| **Logical Gaps** | Arguments that don't follow, missing reasoning steps, circular logic |
| **Missing Edge Cases** | Unhandled scenarios, boundary conditions, error paths not addressed |
| **Unstated Assumptions** | Dependencies taken for granted, environmental assumptions, skill assumptions |
| **Scalability Concerns** | Will this work at 10x? 100x? What breaks first? |
| **Security Issues** | Data exposure, auth gaps, injection vectors, trust boundary violations |
| **Maintainability Problems** | Coupling, complexity, bus factor, unclear ownership |
| **Missing Details** | Vague requirements, undefined terms, ambiguous acceptance criteria |
| **Contradictions** | Statements that conflict with each other within the document |
| **Missing Stakeholders** | Who should have been consulted but wasn't? |
| **Operational Risk** | Deployment risk, rollback difficulty, monitoring gaps, incident response |

For each finding, record:
- **Severity:** Critical / Major / Minor
- **Location:** Section heading, line reference, or field name
- **Description:** What the issue is and why it matters
- **Suggested Fix:** Concrete recommendation to address it
</step>

<step n="4" goal="Format findings">

Format all findings as a numbered list:

```
## Adversarial Review Findings

**Target:** {target identifier}
**Reviewed:** {timestamp}
**Total Findings:** {count} ({critical_count} Critical, {major_count} Major, {minor_count} Minor)

---

### 1. [{Severity}] {Short title}
**Location:** {section/line/field}
**Issue:** {description}
**Fix:** {suggested fix}

### 2. [{Severity}] {Short title}
...
```

Order findings by severity: Critical first, then Major, then Minor.
</step>

<step n="5" goal="Post findings to appropriate destination">

**If target_type is "document":**
<action>Look up the key map to find an issue associated with this document</action>
<action>If an associated issue exists, post the formatted findings as a comment via `save_comment` with `issueId: "{associated_issue_id}"`</action>
<action>If no associated issue, report findings to console output</action>

**If target_type is "issue":**
<action>Post the formatted findings as a comment using `save_comment` with `issueId: "{target}"` and `body: "{formatted_findings}"`</action>

**If target_type is "file":**
<action>Print the formatted findings to the console output</action>
<action>If a Linear issue ID was provided as additional context, also post findings via `save_comment`</action>
</step>

</workflow>

---

## Return Value

Returns the count of findings by severity and the destination where they were posted. The calling process can use this to gate approval workflows.
