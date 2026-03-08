# Create Epic — Plane Implementation

**Purpose:** Create a new Module in Plane (equivalent to a Linear Project / Epic).

## Execution

<step n="1" goal="Create module">
<action>Call `create_module` with:</action>

```
name: "{name}"
description: "{description}"
status: "{state or 'backlog'}"
```
</step>

<step n="2" goal="Return module ID">
<action>Record the returned module ID for key map storage</action>
</step>
