# Link PR to Work Item — Plane Implementation

**Purpose:** Attach a pull request URL to a Plane work item for traceability.

## Execution

<step n="1" goal="Create PR link">
<action>Call `create_work_item_link` with:</action>

```
work_item_id: "{work_item_id}"
url: "{pr_url}"
title: "PR: {pr_title}"
```
</step>
