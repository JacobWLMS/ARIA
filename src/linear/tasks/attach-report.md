# Attach Report — Reusable Task

**Purpose:** Attach test reports, coverage reports, or other file artifacts to a Linear issue as binary attachments. Uses base64-encoded content via the `create_attachment` MCP tool.

---

## Parameters

| Parameter | Required | Description |
|---|---|---|
| `issue_id` | Yes | Linear issue ID or identifier (e.g., `TEAM-42`) |
| `file_path` | Yes | Local file path to the report file |
| `filename` | Yes | Name for the attachment (e.g., `coverage-report.html`) |
| `content_type` | Yes | MIME type (e.g., `text/html`, `application/json`, `text/plain`) |
| `title` | No | Human-readable title for the attachment |

---

## Execution

<workflow>

<step n="1" goal="Read and encode the file">
<action>Read the file at `{file_path}`</action>
<action>Base64-encode the file contents</action>
<action>If the file does not exist or cannot be read, report error and stop</action>
</step>

<step n="2" goal="Create the attachment on the issue">
<action>Call `create_attachment` with:</action>

```
issue: "{issue_id}"
base64Content: "{base64_encoded_content}"
filename: "{filename}"
contentType: "{content_type}"
title: "{title}"                 # omit if not provided
```

<action>Record the returned attachment ID</action>
</step>

</workflow>

---

## Common Content Types

| File Type | Content Type |
|---|---|
| HTML report | `text/html` |
| JSON report | `application/json` |
| Plain text | `text/plain` |
| CSV | `text/csv` |
| PNG screenshot | `image/png` |
| JPEG screenshot | `image/jpeg` |
| PDF | `application/pdf` |

---

## Return Value

Returns the attachment ID for reference. The attachment is visible on the issue in the Linear UI.
