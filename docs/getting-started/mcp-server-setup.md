# Linear MCP Setup

ARIA communicates with Linear through the Linear MCP server. This gives Claude Code access to 19 Linear tools for managing issues, projects, cycles, documents, and more.

## Configuration

Add the Linear MCP server to your Claude Code settings. Create or edit `.claude/settings.json` in your project root:

```json
{
  "mcpServers": {
    "linear": {
      "command": "npx",
      "args": ["-y", "@anthropic/linear-mcp-server"],
      "env": {
        "LINEAR_API_KEY": "lin_api_..."
      }
    }
  }
}
```

!!! warning "API Key Security"
    Never commit your API key to version control. Consider using environment variables or a `.env` file that is listed in `.gitignore`.

## Getting Your API Key

1. Go to [Linear Settings > API](https://linear.app/settings/api)
2. Click **Create Key**
3. Give it a descriptive name (e.g., "ARIA Claude Code")
4. Copy the key and paste it into your settings

## Available Tools

The Linear MCP server provides these tools that ARIA uses:

| Tool | Purpose |
|---|---|
| `list_teams` | Discover team name and ID |
| `save_issue` / `list_issues` / `get_issue` | Create, update, and query stories |
| `save_project` / `list_projects` / `get_project` | Manage epics |
| `list_cycles` | Query sprint cycles |
| `save_milestone` / `list_milestones` | Track releases |
| `create_document` / `list_documents` / `get_document` | Create and read Linear documents |
| `save_comment` / `list_comments` | Post and read issue comments |
| `list_issue_statuses` | Discover workflow states |
| `list_issue_labels` / `create_issue_label` | Manage labels |
| `list_users` / `get_user` | User lookup |
| `create_attachment` / `get_attachment` | File attachments |

## Verification

After configuring the server, restart Claude Code and run:

```
/aria-setup
```

If the MCP server is connected correctly, ARIA will auto-discover your Linear team and configure itself.
