# Editorial Review Prose — Plane Implementation

**Purpose:** Review document prose quality on Plane.

## Execution

<step n="1" goal="Load document">
<action>Call `retrieve_project_page` with `page_id: "{document_id}"`</action>
</step>

<step n="2" goal="Review prose">
<action>Analyze clarity, tone, consistency, jargon usage, sentence structure</action>
</step>

<step n="3" goal="Post findings">
<action>Call `create_work_item_comment` with three-column table: Location | Issue | Suggested Fix</action>
</step>
