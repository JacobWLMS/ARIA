# Log Work — Plane Implementation

**Purpose:** Record agent effort using Plane's native work log system.

## Execution

<step n="1" goal="Create work log entry">
<action>Call `create_work_log` with:</action>

```
work_item_id: "{work_item_id}"
duration: "{hours in minutes, e.g., hours * 60}"
description: "{description} ({agent_name or 'ARIA Agent'})"
```
</step>
