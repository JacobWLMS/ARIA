# Attach Report — Plane Implementation

**Purpose:** Attach a report URL or file reference to a work item using Plane's native link system.

## Execution

<step n="1" goal="Create link on work item">
<action>Call `create_work_item_link` with:</action>

```
work_item_id: "{work_item_id}"
url: "{url or file_path}"
title: "{filename}"
```
</step>
