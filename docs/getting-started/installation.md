# Installation

ARIA installs into your project directory as a set of YAML configurations, workflow instructions, and slash commands. The installer requires a bash-compatible shell.

## Install Methods

=== "macOS / Linux"

    **Pipe to shell (quickest):**

    ```bash
    bash <(curl -fsSL https://raw.githubusercontent.com/JacobWLMS/ARIA/main/install.sh) /path/to/your/project
    ```

    **Or clone and install:**

    ```bash
    git clone https://github.com/JacobWLMS/ARIA.git
    cd ARIA
    ./install.sh /path/to/your/project
    ```

=== "Windows (WSL)"

    Run these commands inside your WSL terminal (Ubuntu, Debian, etc.):

    **Pipe to shell:**

    ```bash
    bash <(curl -fsSL https://raw.githubusercontent.com/JacobWLMS/ARIA/main/install.sh) /path/to/your/project
    ```

    **Or clone and install:**

    ```bash
    git clone https://github.com/JacobWLMS/ARIA.git
    cd ARIA
    ./install.sh /path/to/your/project
    ```

    Your project path should be a WSL path (e.g., `/home/user/projects/myapp`), not a Windows path.

=== "Windows (Git Bash)"

    If you're not using WSL, install via [Git for Windows](https://gitforwindows.org) which includes Git Bash:

    ```bash
    git clone https://github.com/JacobWLMS/ARIA.git
    cd ARIA
    bash install.sh /path/to/your/project
    ```

    The pipe-to-shell method may not work in all Git Bash configurations. Clone-and-install is recommended.

    !!! note
        PowerShell and CMD are not supported for installation. Once installed, ARIA runs entirely through Claude Code which works on any terminal.

## What Gets Installed

| Directory | Contents |
|---|---|
| `_aria/core/` | Agent definitions, workflows, tasks, orchestrator, configuration |
| `_aria/platform/` | Platform-specific task implementations (Plane or Linear) |
| `_aria/shared/` | Templates, checklists, data files (brainstorming techniques, complexity matrices) |
| `.claude/commands/` | 38 slash command files (`aria-*.md`) |
| `CLAUDE.md` | Project instructions with command reference and critical rules |

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

This removes the `_aria/` directory, `aria-*` slash commands, and the ARIA section from CLAUDE.md. It asks for confirmation before proceeding.

## Legacy Migration

If you have a previous BMAD installation (`_bmad/` directory), the installer automatically:

1. Migrates config files from `_bmad/linear/` to `_aria/core/`
2. Removes the legacy `_bmad/` directory
3. Cleans up old `bmad-*` slash commands
