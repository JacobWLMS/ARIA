# Prerequisites

Before installing ARIA, ensure you have:

## Required

- **[Claude Code](https://claude.ai/claude-code)** -- ARIA runs as slash commands inside Claude Code
- **[Linear](https://linear.app) workspace** -- you need a Linear account with at least one team
- **Linear API key** -- generate one at [Linear Settings > API](https://linear.app/settings/api)
- **Node.js 18+** -- required to run the Linear MCP server via npx

## Recommended

- **Git** -- for optional Git/GitHub integration features
- **[GitHub CLI](https://cli.github.com) (`gh`)** -- for PR creation and review automation

## Linear Permissions

Your Linear API key needs access to:

- Read and write Issues, Projects, Cycles, Milestones, and Documents
- Read team and user information
- Manage labels and comments

A personal API key with default permissions covers all of these.
