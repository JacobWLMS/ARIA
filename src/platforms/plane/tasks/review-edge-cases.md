# Edge Case Review — Plane Implementation

**Purpose:** Walk branching paths in referenced code to find unhandled edge cases.

## Execution

<step n="1" goal="Load target">
**If target_type is "document":**
<action>Call `retrieve_project_page` with `page_id: "{target_id}"`</action>

**If target_type is "work_item":**
<action>Call `retrieve_work_item` with `work_item_id: "{target_id}"`</action>
</step>

<step n="2" goal="Analyze for edge cases">
<action>Walk branching paths, identify boundary conditions, null states, concurrency issues, error propagation</action>
</step>

<step n="3" goal="Post findings">
<action>Call `create_work_item_comment` with edge case findings and file:line references</action>
</step>
