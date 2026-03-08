# Editorial Review Structure — Plane Implementation

**Purpose:** Review document structure and organization on Plane.

## Execution

<step n="1" goal="Load document">
<action>Call `retrieve_project_page` with `page_id: "{document_id}"`</action>
</step>

<step n="2" goal="Analyze structure">
<action>Evaluate section flow, heading hierarchy, information architecture, redundancy</action>
</step>

<step n="3" goal="Post findings">
<action>Call `create_work_item_comment` with [NEW]/[CUT]/[MOVED]/[MERGED] annotations</action>
</step>
