# Link PR to Issue — Reusable Task

**Purpose:** Attach a GitHub Pull Request URL to a Linear issue using Linear's native link support. Links are append-only -- existing links are never removed.

---

## Parameters

| Parameter | Required | Description |
|---|---|---|
| `issue_id` | Yes | Linear issue ID or identifier (e.g., `TEAM-42`) |
| `pr_url` | Yes | Full GitHub PR URL (e.g., `https://github.com/owner/repo/pull/1`) |
| `pr_title` | No | Title for the link (defaults to "Pull Request") |

---

## Execution

<workflow>

<step n="1" goal="Attach PR link to the issue">
<action>Call `save_issue` with:</action>

```
id: "{issue_id}"
links: [{"url": "{pr_url}", "title": "{pr_title or 'Pull Request'}"}]
```

<action>Verify the update succeeded by checking the response</action>
</step>

</workflow>

---

## Notes

- Links in Linear are **append-only** -- calling `save_issue` with `links` adds to existing links, it does not replace them.
- This replaces the Jira pattern of embedding URLs in issue descriptions or using Remote Issue Links.
- Linear also has a native GitHub integration that auto-links PRs when branch names include the issue identifier (e.g., `TEAM-42`). This task is for explicit linking when the automatic detection does not apply.
- The `links` parameter accepts an array, so multiple PRs can be attached in a single call if needed.

---

## Return Value

Returns success/failure status. No new IDs are generated.
