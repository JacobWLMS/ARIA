# Adversarial Review — Plane Implementation

**Purpose:** Perform cynical review of a document or work item on Plane.

## Execution

<step n="1" goal="Load target content">
**If target_type is "document":**
<action>Call `retrieve_project_page` with `page_id: "{target_id}"` to load page content</action>

**If target_type is "work_item":**
<action>Call `retrieve_work_item` with `work_item_id: "{target_id}"` to load work item details</action>
</step>

<step n="2" goal="Perform adversarial review">
<action>Review content critically, finding at least 10 issues across categories: logic gaps, missing requirements, unstated assumptions, scalability concerns, security oversights, UX issues, testability gaps</action>
</step>

<step n="3" goal="Post findings">
<action>Call `create_work_item_comment` with findings formatted as structured HTML</action>
</step>
