# Create Intake — Plane Implementation

**Purpose:** Add an idea to Plane's native intake/triage queue.

## Execution

<step n="1" goal="Create intake work item">
<action>Call `create_intake_work_item` with:</action>

```
name: "{title}"
description_html: |
  <p><strong>Source:</strong> {source or "manual"}</p>
  {description as HTML}
  <hr/>
  <p><em>Created via ARIA intake flow</em></p>
```
</step>

<step n="2" goal="Return intake ID">
<action>Record the returned intake work item ID</action>
</step>
