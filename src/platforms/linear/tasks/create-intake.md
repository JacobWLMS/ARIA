# Create Intake — Linear Implementation

**Note:** Linear does not have a native intake/triage queue. This task creates a backlog issue instead.

## Execution

<step n="1" goal="Create backlog issue as intake substitute">
<action>Call `save_issue` with:</action>

```
title: "[Intake] {title}"
team: "{team_name}"
description: |
  **Source:** {source or "manual"}

  {description}

  ---
  _Created via ARIA intake flow_
state: "Backlog"
labels: ["aria-intake"]
```
</step>

<step n="2" goal="Return created issue ID">
<action>Record the returned issue ID for key map storage if needed</action>
</step>
