# ARIA — Agent Install Instructions

These instructions are designed to be read and executed by an AI coding assistant (Claude Code, Cursor, Cline, Windsurf, or similar). When a user asks you to install ARIA, read and follow these steps.

## Prerequisites

Before starting, verify you can:
- Run bash commands
- Read and write files
- Ask the user questions

If any of these are unavailable, direct the user to the manual install: `git clone https://github.com/JacobWLMS/ARIA.git && cd ARIA && bash install.sh /path/to/project`

## Step 1: Detect Project Root

Find the project root directory. Look for `.git/` in the current working directory or its parents. If found, use the directory containing `.git/` as the project root. If no `.git/` is found, ask the user:

> Which directory should ARIA be installed into? (provide an absolute path)

Store this as `PROJECT_ROOT`.

## Step 2: Clone ARIA Repository

Run:
```bash
git clone --depth 1 https://github.com/JacobWLMS/ARIA.git /tmp/aria-install
```

If `/tmp/aria-install` already exists from a previous attempt, remove it first:
```bash
rm -rf /tmp/aria-install
git clone --depth 1 https://github.com/JacobWLMS/ARIA.git /tmp/aria-install
```

Verify the clone succeeded by checking that both of these directories exist:
- `/tmp/aria-install/src/core/`
- `/tmp/aria-install/src/platforms/`

If either is missing, stop and tell the user the clone failed.

## Step 3: Select Platform

Ask the user:

> Which project management platform do you use?
> 1. **Plane** (recommended) — open-source, full feature support
> 2. **Linear** — streamlined issue tracking

Store their choice as `PLATFORM` (either `plane` or `linear`).

## Step 4: Create Directory Structure

Run:
```bash
mkdir -p "$PROJECT_ROOT/_aria/core"
mkdir -p "$PROJECT_ROOT/_aria/platform"
mkdir -p "$PROJECT_ROOT/_aria/shared"
```

## Step 5: Install Core Files

If `$PROJECT_ROOT/_aria/core/module.yaml` already exists, back it up before copying so user config is preserved:
```bash
if [ -f "$PROJECT_ROOT/_aria/core/module.yaml" ]; then
  cp "$PROJECT_ROOT/_aria/core/module.yaml" "$PROJECT_ROOT/_aria/core/module.yaml.bak"
fi
```

Copy core, shared, and platform files:
```bash
cp -r /tmp/aria-install/src/core/* "$PROJECT_ROOT/_aria/core/"
cp -r /tmp/aria-install/src/shared/* "$PROJECT_ROOT/_aria/shared/"
cp -r /tmp/aria-install/src/platforms/$PLATFORM/* "$PROJECT_ROOT/_aria/platform/"
echo "$PLATFORM" > "$PROJECT_ROOT/_aria/.platform"
```

If a backup was created, restore it to preserve user config:
```bash
if [ -f "$PROJECT_ROOT/_aria/core/module.yaml.bak" ]; then
  mv "$PROJECT_ROOT/_aria/core/module.yaml.bak" "$PROJECT_ROOT/_aria/core/module.yaml"
fi
```

## Step 6: Install VERSION

Copy the version file so ARIA can report its installed version:
```bash
cp /tmp/aria-install/VERSION "$PROJECT_ROOT/_aria/core/VERSION" 2>/dev/null || true
```

## Step 7: Detect AI Tool and Install Config

Detect which AI coding tool is running by checking for config directories at `PROJECT_ROOT`:

| Check | Tool |
|---|---|
| `$PROJECT_ROOT/.claude/` directory exists, or you know you are Claude Code | Claude Code |
| `$PROJECT_ROOT/.cursor/` directory exists | Cursor |
| `$PROJECT_ROOT/.windsurf/` directory exists | Windsurf |
| `$PROJECT_ROOT/.clinerules` file or `$PROJECT_ROOT/.clinerules/` directory exists | Cline / Roo Code |

If you cannot detect the tool, ask the user:

> Which AI coding tool are you using?
> 1. Claude Code
> 2. Cursor
> 3. Windsurf
> 4. Cline / Roo Code
> 5. Other

Then follow the matching section below.

### Claude Code

Install slash commands:
```bash
mkdir -p "$PROJECT_ROOT/.claude/commands"
cp /tmp/aria-install/.claude/commands/*.md "$PROJECT_ROOT/.claude/commands/"
```

Then handle `CLAUDE.md`. There are three cases:

**Case A — No existing CLAUDE.md:** Copy it directly.
```bash
cp /tmp/aria-install/CLAUDE.md "$PROJECT_ROOT/CLAUDE.md"
```

**Case B — Existing CLAUDE.md with an `# ARIA` section:** Replace the ARIA section (from the `# ARIA` heading to the end of the file or the next top-level heading) with the new content.
```bash
if [ -f "$PROJECT_ROOT/CLAUDE.md" ]; then
  if grep -q "# ARIA" "$PROJECT_ROOT/CLAUDE.md"; then
    ARIA_LINE=$(grep -n "# ARIA" "$PROJECT_ROOT/CLAUDE.md" | head -1 | cut -d: -f1)
    head -n $((ARIA_LINE - 1)) "$PROJECT_ROOT/CLAUDE.md" > "$PROJECT_ROOT/CLAUDE.md.tmp"
    echo "" >> "$PROJECT_ROOT/CLAUDE.md.tmp"
    cat /tmp/aria-install/CLAUDE.md >> "$PROJECT_ROOT/CLAUDE.md.tmp"
    mv "$PROJECT_ROOT/CLAUDE.md.tmp" "$PROJECT_ROOT/CLAUDE.md"
  else
    echo "" >> "$PROJECT_ROOT/CLAUDE.md"
    cat /tmp/aria-install/CLAUDE.md >> "$PROJECT_ROOT/CLAUDE.md"
  fi
fi
```

**Case C — Existing CLAUDE.md without an `# ARIA` section:** Append the ARIA content.
```bash
if [ -f "$PROJECT_ROOT/CLAUDE.md" ] && ! grep -q "# ARIA" "$PROJECT_ROOT/CLAUDE.md"; then
  echo "" >> "$PROJECT_ROOT/CLAUDE.md"
  cat /tmp/aria-install/CLAUDE.md >> "$PROJECT_ROOT/CLAUDE.md"
fi
```

Note: The bash block in Case B already handles both Case B and Case C via the if/else. You can run that single block to cover all three cases:
```bash
if [ -f "$PROJECT_ROOT/CLAUDE.md" ]; then
  if grep -q "# ARIA" "$PROJECT_ROOT/CLAUDE.md"; then
    ARIA_LINE=$(grep -n "# ARIA" "$PROJECT_ROOT/CLAUDE.md" | head -1 | cut -d: -f1)
    head -n $((ARIA_LINE - 1)) "$PROJECT_ROOT/CLAUDE.md" > "$PROJECT_ROOT/CLAUDE.md.tmp"
    echo "" >> "$PROJECT_ROOT/CLAUDE.md.tmp"
    cat /tmp/aria-install/CLAUDE.md >> "$PROJECT_ROOT/CLAUDE.md.tmp"
    mv "$PROJECT_ROOT/CLAUDE.md.tmp" "$PROJECT_ROOT/CLAUDE.md"
  else
    echo "" >> "$PROJECT_ROOT/CLAUDE.md"
    cat /tmp/aria-install/CLAUDE.md >> "$PROJECT_ROOT/CLAUDE.md"
  fi
else
  cp /tmp/aria-install/CLAUDE.md "$PROJECT_ROOT/CLAUDE.md"
fi
```

### Cursor

```bash
mkdir -p "$PROJECT_ROOT/.cursor/rules"
cp /tmp/aria-install/src/tools/cursor/aria.mdc "$PROJECT_ROOT/.cursor/rules/aria.mdc"
```

### Windsurf

```bash
mkdir -p "$PROJECT_ROOT/.windsurf/rules"
cp /tmp/aria-install/src/tools/windsurf/aria.md "$PROJECT_ROOT/.windsurf/rules/aria.md"
```

### Cline / Roo Code

```bash
mkdir -p "$PROJECT_ROOT/.clinerules"
cp /tmp/aria-install/src/tools/cline/aria.md "$PROJECT_ROOT/.clinerules/aria.md"
```

### Other / Unknown

Tell the user:

> ARIA core files have been installed to `_aria/`. To use ARIA, read `_aria/core/agents/` for agent personas and `_aria/core/workflows/` for workflow instructions. See the CLAUDE.md in the ARIA repository for the full project instruction reference.

## Step 8: Basic Configuration

Ask the user these questions and update the corresponding fields in `$PROJECT_ROOT/_aria/core/module.yaml`:

1. **Project name**: "What is your project name?" — Use the directory name of `PROJECT_ROOT` as the default. Update the `project_name` field.
2. **Team name**: "What is your {Plane workspace / Linear team} name?" — Phrase the question using the platform name from Step 3. Update the `team_name` or equivalent field.
3. **Skill level**: "What is your development experience level? (beginner / intermediate / expert)" — Default to `intermediate` if the user skips. Update the `skill_level` field.

Read the module.yaml file, make the edits in-place, and write it back.

## Step 9: Cleanup

Remove the temporary clone:
```bash
rm -rf /tmp/aria-install
```

## Step 10: Report Success

Tell the user:

> **ARIA installed successfully!**
>
> - Platform: {PLATFORM}
> - Project: {PROJECT_NAME}
> - Config: `_aria/core/module.yaml`
>
> **Next steps:**
> 1. Configure your {Plane/Linear} MCP server in your AI tool's settings
> 2. Run the setup workflow to auto-discover teams and states
>    - Claude Code: `/aria-setup`
>    - Other tools: "Run the ARIA setup workflow"
> 3. Run the help workflow for guidance
>    - Claude Code: `/aria-help`
>    - Other tools: "Run the ARIA help workflow"

Replace `{PLATFORM}`, `{PROJECT_NAME}`, and `{Plane/Linear}` with the actual values from the installation.

## Troubleshooting

If any step fails, report the error and suggest the relevant fix:

- **"git not found"**: Install git first, then try again.
- **"Permission denied"**: Check directory permissions or try a different install path.
- **"Clone failed"**: Check network connectivity and that `https://github.com/JacobWLMS/ARIA.git` is accessible.
- **"MCP server not configured"**: The platform MCP server must be set up separately in your AI tool's settings. See https://jacobwlms.github.io/ARIA/getting-started/mcp-server-setup/
- **"module.yaml not found after install"**: The ARIA repository structure may have changed. Check `/tmp/aria-install/src/core/` for the current layout.
