# Write Document — Plane Implementation

**Purpose:** Create or update a page on Plane. Uses native Plane MCP page tools.

## Execution

<step n="1" goal="Resolve target project">
<action>If `project_id` is provided, use it.</action>
<action>If not, read `workspace_project_id` from module.yaml.</action>
</step>

<step n="2" goal="Check if page already exists">
<action>If `key_map_id` is provided, check `.key-map.yaml` for an existing page ID</action>
<action>If found, proceed to step 4 (update)</action>
<action>If not found, proceed to step 3 (create)</action>
</step>

<step n="3" goal="Create new page">
<action>Call `create_project_page` with:</action>

```
project_id: "{resolved_project_id}"
name: "{title}"
description_html: "{body_content converted to HTML}"
```

<action>Record the returned page `id`</action>
<action>Proceed to step 5</action>
</step>

<step n="4" goal="Update existing page">
<action>Call `retrieve_project_page` with `page_id: "{existing_page_id}"` to verify it exists</action>
<action>Update the page content — Plane pages are updated by retrieving and modifying</action>
</step>

<step n="5" goal="Update key map">
<action>If `key_map_id` is provided, update `.key-map.yaml` under `documents.{key_map_id}`:</action>

```yaml
documents:
  {key_map_id}:
    id: "{page_id}"
    title: "{title}"
    project_id: "{resolved_project_id}"
```
</step>
