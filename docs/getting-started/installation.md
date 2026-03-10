# Installation

ARIA installs into your project directory as a set of YAML configurations, workflow instructions, and slash commands.

## AI Agent Install (Recommended)

Paste this into Claude Code, Cursor, Cline, Windsurf, or any AI coding tool:

> Read the instructions at https://raw.githubusercontent.com/JacobWLMS/ARIA/main/agent-install.md and follow them to install ARIA into this project.

The AI will clone ARIA, ask you a few setup questions (platform, team name), detect your tool, and configure everything automatically.

## Shell Install

=== "macOS / Linux"

    **Install to current directory:**

    ```bash
    curl -fsSL https://raw.githubusercontent.com/JacobWLMS/ARIA/main/install.sh | bash
    ```

    **Install to a specific directory:**

    ```bash
    curl -fsSL https://raw.githubusercontent.com/JacobWLMS/ARIA/main/install.sh | bash -s -- /path/to/project
    ```

    **Or clone and install:**

    ```bash
    git clone https://github.com/JacobWLMS/ARIA.git
    cd ARIA
    ./install.sh /path/to/project
    ```

=== "fish"

    fish does not support `bash <(...)` process substitution. Use the pipe syntax:

    ```bash
    curl -fsSL https://raw.githubusercontent.com/JacobWLMS/ARIA/main/install.sh | bash
    ```

    **With a specific directory:**

    ```bash
    curl -fsSL https://raw.githubusercontent.com/JacobWLMS/ARIA/main/install.sh | bash -s -- /path/to/project
    ```

=== "Windows (WSL)"

    Run inside your WSL terminal (Ubuntu, Debian, etc.):

    ```bash
    curl -fsSL https://raw.githubusercontent.com/JacobWLMS/ARIA/main/install.sh | bash
    ```

    Your project path should be a WSL path (e.g., `/home/user/projects/myapp`), not a Windows path.

=== "Windows (Git Bash)"

    Clone-and-install is recommended for Git Bash:

    ```bash
    git clone https://github.com/JacobWLMS/ARIA.git
    cd ARIA
    bash install.sh /path/to/project
    ```

    !!! note
        PowerShell and CMD are not supported for installation. Once installed, ARIA runs entirely through your AI coding tool.

The installer renders a fancy welcome screen, prompts for your platform, and shows progress:

```
   █████╗ ██████╗ ██╗ █████╗
  ██╔══██╗██╔══██╗██║██╔══██╗
  ███████║██████╔╝██║███████║
  ██╔══██║██╔══██╗██║██╔══██║
  ██║  ██║██║  ██║██║██║  ██║
  ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═╝

  Agentic Reasoning & Implementation Architecture  v2.0.0

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ✓  Created directories
  ✓  Installed shared content → _aria/shared/
  ✓  Installed core module → _aria/core/
  ✓  Installed Plane platform → _aria/platform/
  ✓  Wrote version file (v2.0.0)
  ✓  Updated CLAUDE.md
  ✓  Installed 38 slash commands → .claude/commands/
  ✓  Checked .gitignore

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ✦ Installation complete!  v2.0.0

  ♪ "The conductor has taken the podium."
    Happy building! ✦
```

## AI Tool Selection

The installer defaults to Claude Code. Use `--tool` to install for a different AI coding tool:

```bash
./install.sh --tool cursor           # Cursor (.cursor/rules/aria.mdc)
./install.sh --tool windsurf         # Windsurf (.windsurf/rules/aria.md)
./install.sh --tool cline            # Cline / Roo Code (.clinerules/aria.md)
./install.sh --tool all              # Install config for all tools
```

| Tool | Config Location | How to Trigger Workflows |
|---|---|---|
| **Claude Code** | `.claude/commands/` + `CLAUDE.md` | Type `/aria-` and autocomplete |
| **Cursor** | `.cursor/rules/aria.mdc` | "Run the brainstorm workflow" |
| **Windsurf** | `.windsurf/rules/aria.md` | "Run the brainstorm workflow" |
| **Cline / Roo Code** | `.clinerules/aria.md` | "Run the brainstorm workflow" |

## What Gets Installed

| Directory | Contents |
|---|---|
| `_aria/core/` | Agent definitions, workflows, tasks, orchestrator, configuration |
| `_aria/platform/` | Platform-specific task implementations (Plane or Linear) |
| `_aria/shared/` | Templates, checklists, data files (brainstorming techniques, complexity matrices) |
| Tool config | `.claude/commands/`, `.cursor/rules/`, `.windsurf/rules/`, or `.clinerules/` (depends on `--tool`) |

## Re-Installing

The installer is safe for re-runs. It detects existing installations and:

- **Preserves** your `module.yaml` and `.key-map.yaml` configuration
- **Updates** all workflow instructions, templates, and slash commands
- **Cleans up** old commands from previous versions

## Uninstalling

To remove ARIA from a project:

```bash
./uninstall.sh /path/to/your/project
```

This removes the `_aria/` directory, tool-specific config files, and the ARIA section from CLAUDE.md. It asks for confirmation before proceeding.

## Legacy Migration

If you have a previous BMAD installation (`_bmad/` directory), the installer automatically:

1. Migrates config files from `_bmad/linear/` to `_aria/core/`
2. Removes the legacy `_bmad/` directory
3. Cleans up old `bmad-*` slash commands
