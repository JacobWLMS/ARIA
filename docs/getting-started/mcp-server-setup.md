# MCP Setup

ARIA communicates with your project management platform through MCP servers. Choose the setup for your platform below.

## Plane

Plane uses the built-in Plane MCP server in Claude Code, providing access to 93 tools for managing work items, epics, cycles, pages, and more.

Add the Plane MCP server to your Claude Code settings. Create or edit `.claude/settings.json` in your project root:

```json
{
  "mcpServers": {
    "plane": {
      "command": "npx",
      "args": ["-y", "@anthropic/plane-mcp-server"],
      "env": {
        "PLANE_API_KEY": "plane_api_..."
      }
    }
  }
}
```

## Linear

Linear uses the Linear MCP server, providing access to 19 tools for managing issues, projects, cycles, documents, and more.

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

=== "Plane"
    1. Go to your Plane instance Settings > API Tokens
    2. Click **Create Token**
    3. Give it a descriptive name (e.g., "ARIA Claude Code")
    4. Copy the token and paste it into your settings

=== "Linear"
    1. Go to [Linear Settings > API](https://linear.app/settings/api)
    2. Click **Create Key**
    3. Give it a descriptive name (e.g., "ARIA Claude Code")
    4. Copy the key and paste it into your settings

## Verification

After configuring the server, restart Claude Code and run:

```
/aria-setup
```

ARIA will detect your platform, auto-discover your team/project, and configure itself.
