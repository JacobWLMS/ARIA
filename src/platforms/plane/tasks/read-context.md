# Read Context — Plane Implementation

**Purpose:** Fetch work items, modules, and pages from Plane to build agent context.

## Context Types

### `project_overview`
<action>Call `list_modules` to get all ARIA-managed modules (epics)</action>
<action>Call `list_work_items` to get work item summary</action>
<action>Call `list_work_item_properties` to check ARIA custom properties exist</action>

**Returns:** List of modules with statuses, work item counts by state

### `epic_detail`
<action>Call `retrieve_module` with `module_id: "{scope_id}"`</action>
<action>Call `list_module_work_items` with `module_id: "{scope_id}"` to get all work items</action>

**Returns:** Module details with all child work items and statuses

### `story_detail`
<action>Call `retrieve_work_item` with `work_item_id: "{scope_id}"`</action>
<action>Call `list_work_item_comments` with `work_item_id: "{scope_id}"`</action>
<action>Call `list_work_item_relations` with `work_item_id: "{scope_id}"` for dependencies</action>
<action>Call `list_work_item_links` with `work_item_id: "{scope_id}"` for PR links</action>

**Returns:** Full work item with comments, relations, links

### `sprint_status`
<action>Call `list_cycles` to find active cycles</action>
<action>Call `list_cycle_work_items` with the active cycle ID</action>
<action>Call `list_work_items` with state filter for backlog items</action>

**Returns:** Active cycle work items + backlog

### `document_artefact`
<action>Look up `{scope_id}` in `.key-map.yaml` under `documents`</action>
<action>Call `retrieve_project_page` with `page_id: "{page_id}"`</action>

**Returns:** Page content

### `previous_story_learnings`
<action>Call `list_work_items` with state filter for "Done", limit 3, ordered by updated</action>
<action>For each, call `list_work_item_comments` to extract dev records</action>

**Returns:** Last 3 completed work items' dev records

### `handoff_context`
<action>Call `list_work_item_comments` with `work_item_id: "{scope_id}"`</action>
<action>Find most recent comment containing "## Agent Handoff:"</action>
<action>Parse handoff context (decisions, open_questions, artefact_refs)</action>
<action>Check `aria_handoff_target` property value on the work item</action>

**Returns:** Parsed handoff context with pre-loaded artefacts
