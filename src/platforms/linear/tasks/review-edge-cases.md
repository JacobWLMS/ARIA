---
name: review-edge-cases
description: 'Walk every branching path and boundary condition in code, report unhandled edge cases. Posts findings as Linear comment.'
---

# Task: Edge Case Hunter

**Purpose:** Methodically walk every branching path, boundary condition, and error path in code to surface unhandled edge cases. Method-driven and systematic -- unlike the adversarial review, this is about thoroughness, not attitude. Posts findings as a structured Linear comment.

---

## Parameters

| Parameter | Required | Description |
|---|---|---|
| `target` | Yes | Linear issue identifier (e.g., `TEAM-42`) or comma-separated file paths to review |
| `issue_id` | No | If target is file paths, the Linear issue to post findings to (optional) |

---

## Execution

<workflow>

<step n="1" goal="Resolve target and load code">

**If target matches `[A-Z]+-\d+` (Linear issue identifier):**
<action>Call `get_issue` with `id: "{target}"` to load issue details including description</action>
<action>Call `list_comments` with `issueId: "{target}"` to load comments (look for Dev Agent Records or file references)</action>
<action>Extract file paths and implementation details from the issue description and comments</action>
<action>Read each referenced file to load the code under review</action>
<action>Set `issue_id` to `{target}` for posting results</action>

**If target is file path(s):**
<action>Read each file at the given path(s)</action>
<action>Record file contents for analysis</action>
</step>

<step n="2" goal="Walk every branching path and boundary condition">

For each file and function under review, systematically analyze:

| Category | What to check |
|---|---|
| **Null/Empty Inputs** | What happens when arguments are null, undefined, empty string, empty array, empty object? Are there guards? |
| **Boundary Values** | Integer min/max, zero, negative numbers, empty collections, single-element collections, maximum-length strings |
| **Concurrent Access** | Race conditions, shared mutable state, missing locks, time-of-check-time-of-use (TOCTOU) bugs |
| **Error Propagation** | Are errors caught and handled? Do they propagate correctly up the call stack? Are error messages useful? Are there swallowed exceptions? |
| **Type Coercion** | Implicit conversions, string-to-number edge cases, truthiness/falsiness traps, unexpected type inputs |
| **Off-by-One** | Loop bounds, array indexing, pagination, range calculations, fence-post errors |
| **Resource Exhaustion** | Memory leaks, unbounded collections, missing timeouts, connection pool exhaustion, file handle leaks |
| **State Transitions** | Invalid state transitions, partially completed operations, cleanup on failure, idempotency |
| **External Dependencies** | Network failures, timeout behavior, retry logic, fallback paths, partial responses |
| **Input Validation** | Missing validation, inconsistent validation, validation bypass paths |

For each finding, record:
- **File:Line** -- exact location in the code
- **Condition** -- the specific input or state that triggers the issue
- **Expected Behavior** -- what should happen
- **Actual/Missing Behavior** -- what does happen or what is missing
</step>

<step n="3" goal="Format findings">

Format all findings as a structured list:

```
## Edge Case Review

**Target:** {issue identifier or file list}
**Reviewed:** {timestamp}
**Files Analyzed:** {count}
**Total Findings:** {count}

---

### 1. {Short title}
**File:** `{file_path}:{line_number}`
**Condition:** {what triggers this edge case}
**Expected:** {what should happen}
**Actual/Missing:** {what happens or what is not handled}

### 2. {Short title}
...

---

**Summary by Category:**
| Category | Count |
|---|---|
| Null/Empty Inputs | {n} |
| Boundary Values | {n} |
| ... | ... |
```

Order findings by file, then by line number within each file.
</step>

<step n="4" goal="Post findings to Linear">

**If `issue_id` is set:**
<action>Post the formatted findings as a comment using `save_comment` with `issueId: "{issue_id}"` and `body: "{formatted_findings}"`</action>

**If no issue ID:**
<action>Print the formatted findings to the console output</action>
</step>

</workflow>

---

## Return Value

Returns the count of edge cases found by category and the Linear issue ID where findings were posted (if applicable).
