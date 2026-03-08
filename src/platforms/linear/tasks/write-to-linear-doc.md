# Write to Linear Document — Reusable Task

**Purpose:** Create or update a Linear document idempotently. Checks if the document already exists before creating a new one.

**Key constraint:** Linear requires every document to be attached to a project or issue. When no specific project is provided, this task uses the **ARIA Workspace** project as a container. Documents can later be reassigned to their specific epic project via `update_document`.

---

## Parameters

| Parameter | Required | Description |
|---|---|---|
| `title` | Yes | Document title (should include project prefix for discoverability) |
| `body_content` | Yes | Markdown content for the document body |
| `project_id` | No | Linear project ID to associate the document with. If omitted, uses `workspace_project_id` from module.yaml. |
| `key_map_id` | No | Identifier to store the document ID under in `.key-map.yaml` (e.g., `prd`, `architecture`, `brief`) |
| `icon` | No | Emoji icon for the document |

---

## Execution

<workflow>

<step n="1" goal="Resolve target project">
<action>If `project_id` is provided, use it as the target project.</action>
<action>If `project_id` is NOT provided, read `workspace_project_id` from module.yaml. This is the ARIA Workspace project that acts as a container for documents not yet associated with a specific epic.</action>
<action>If `workspace_project_id` is also empty, warn the user: "No project ID provided and no ARIA Workspace configured. Run /aria-setup to set up the workspace project." Then attempt to create the document anyway — it will fail if Linear requires a project.</action>
</step>

<step n="2" goal="Check if document already exists">
<action>Call `list_documents` with `query: "{title}"` to search for an existing document with a matching title</action>
<action>If a matching document is found (exact title match), record its `id` and proceed to step 4 (update)</action>
<action>If no match found, proceed to step 3 (create)</action>
</step>

<step n="3" goal="Create new document">
<action>Call `create_document` with:</action>

```
title: "{title}"
content: "{body_content}"
project: "{resolved_project_id}"
icon: "{icon}"                 # omit if not provided
```

<action>Record the returned document `id` and `url`</action>
<action>Proceed to step 5</action>
</step>

<step n="4" goal="Update existing document">
<action>Call `update_document` with:</action>

```
id: "{existing_document_id}"
title: "{title}"
content: "{body_content}"
```

<action>If a `project_id` was explicitly provided and differs from the document's current project, also set `project: "{project_id}"` to reassign the document to the correct project.</action>
<action>Record the document `id`</action>
</step>

<step n="5" goal="Update key map (if key_map_id provided)">
<action>If `key_map_id` is provided:</action>
<action>Read `{key_map_file}` from module.yaml</action>
<action>Update the key map file under `documents.{key_map_id}` with:</action>

```yaml
documents:
  {key_map_id}:
    id: "{document_id}"
    title: "{title}"
    url: "{document_url}"
    project_id: "{resolved_project_id}"
```

<action>Update `last_updated` timestamp</action>
</step>

</workflow>

---

## Document Reassignment

When epic projects are created later (e.g., during Create Epics & Stories), documents that were initially stored in the ARIA Workspace can be reassigned:

```
update_document:
  id: "{document_id}"
  project: "{epic_project_id}"
```

This moves the document from the workspace container into the appropriate epic project, where it appears in the project's Resources tab.

The `write-to-linear-doc` task handles this automatically in step 4: if called with an explicit `project_id` on an existing document, it updates the project association.

---

## Key Differences from Confluence

- **No space resolution** — Linear documents are project-scoped, not space-scoped. The ARIA Workspace project replaces the concept of a Confluence space.
- **No parent page hierarchy** — Documents are flat within a project. Use naming conventions for organization.
- **No labels on documents** — Linear documents do not support labels. Use `key_map_id` and title prefixes for discoverability.
- **Project required** — Unlike Confluence pages which can exist in any space, Linear documents must belong to a project or issue. The ARIA Workspace project solves this.
- **Documents are movable** — `update_document` with a new `project` ID reassigns the document. This enables the create-in-workspace → move-to-epic flow.

---

## Return Value

Returns `{ document_id: "{id}", url: "{url}", project_id: "{project_id}" }` for use by the calling workflow.
