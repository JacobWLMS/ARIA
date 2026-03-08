# Help — Plane Implementation

**Purpose:** Inspect current Plane project state and provide context-aware guidance.

## Execution

<step n="1" goal="Discover project state">
<action>Call `list_projects` to list available projects</action>
<action>Call `list_states` to verify ARIA workflow states exist</action>
<action>Call `list_work_item_properties` to verify ARIA properties are configured</action>
<action>Call `list_work_item_types` to check for ARIA work item types</action>
<action>Call `list_work_items` to get a summary of current work</action>
<action>Call `list_modules` to check for epics</action>
<action>Call `list_cycles` to check for active sprints</action>
</step>

<step n="2" goal="Determine project phase">
<action>Check `.key-map.yaml` for existing artefacts (brief, prd, architecture, etc.)</action>
<action>Based on which artefacts exist and work item states, determine the current project phase</action>
</step>

<step n="3" goal="Recommend next steps">
<action>Based on the current phase, suggest the most appropriate ARIA slash command to run next</action>
<action>If setup is incomplete (missing states, properties, or types), recommend running /aria-setup first</action>
</step>
