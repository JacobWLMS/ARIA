#!/usr/bin/env bash
set -euo pipefail

# ARIA Installer
# Installs the ARIA module into a target project directory
# Supports multiple platforms: Linear, Plane
# Supports multiple AI tools: Claude Code, Cursor, Windsurf, Cline
# Safe for re-installs: preserves module.yaml and data/.key-map.yaml config
#
# Usage:
#   ./install.sh [/path/to/project] [--tool <tool>]
#   curl -fsSL .../install.sh | bash                     (install to current dir)
#   curl -fsSL .../install.sh | bash -s -- /path         (install to specific dir)
#   curl -fsSL .../install.sh | bash -s -- --tool cursor (install for Cursor)
#
# Tools: claude-code (default), cursor, windsurf, cline, all

# ─────────────────────────────────────────────────────
# Shell compatibility check
# ─────────────────────────────────────────────────────
if [ -z "${BASH_VERSION:-}" ]; then
  echo ""
  echo "  Error: ARIA requires a bash-compatible shell."
  echo ""
  echo "  You appear to be running this in a different shell."
  echo "  Try one of:"
  echo "    bash install.sh /path/to/project"
  echo "    ./install.sh /path/to/project  (if bash is your default shell)"
  echo ""
  echo "  On Windows, use WSL or Git Bash (https://gitforwindows.org)."
  echo "  PowerShell and CMD are not supported."
  echo ""
  exit 1
fi

REPO_URL="https://github.com/JacobWLMS/ARIA.git"
CLEANUP_TEMP=""
AI_TOOL="claude-code"

# ─────────────────────────────────────────────────────
# Parse arguments
# ─────────────────────────────────────────────────────
POSITIONAL_ARGS=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --tool)
      AI_TOOL="${2:-claude-code}"
      shift 2
      ;;
    --tool=*)
      AI_TOOL="${1#*=}"
      shift
      ;;
    *)
      POSITIONAL_ARGS+=("$1")
      shift
      ;;
  esac
done
if [[ ${#POSITIONAL_ARGS[@]} -gt 0 ]]; then
  set -- "${POSITIONAL_ARGS[@]}"
fi

# Validate tool choice
case "$AI_TOOL" in
  claude-code|cursor|windsurf|cline|all) ;;
  *)
    echo "  Error: Unknown tool '$AI_TOOL'. Valid options: claude-code, cursor, windsurf, cline, all"
    exit 1
    ;;
esac

# ─────────────────────────────────────────────────────
# Colors & Symbols
# ─────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
ITALIC='\033[3m'
RESET='\033[0m'

# Purple → cyan gradient for logo (256-color)
GRAD1='\033[38;5;135m'
GRAD2='\033[38;5;141m'
GRAD3='\033[38;5;147m'
GRAD4='\033[38;5;153m'
GRAD5='\033[38;5;159m'
GRAD6='\033[38;5;123m'

CHECK="${GREEN}✓${RESET}"
CROSS="${RED}✗${RESET}"
ARROW="${CYAN}▸${RESET}"
DIAMOND="${CYAN}◆${RESET}"
SPARKLE="✦"
RULE="${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"

# Animation delay — only for interactive terminals
ANIM_DELAY=0
if [ -t 1 ] && sleep 0.01 2>/dev/null; then
  ANIM_DELAY=0.035
fi

# ─────────────────────────────────────────────────────
# Logo
# ─────────────────────────────────────────────────────
print_logo() {
  local logo_lines=()

  # Try figlet with ANSI Shadow font
  if command -v figlet &>/dev/null; then
    local font_found=false
    for font_dir in "$HOME/.local/share/figlet" /usr/share/figlet/fonts /usr/local/share/figlet/fonts /usr/share/figlet; do
      if [ -f "$font_dir/ANSI Shadow.flf" ]; then
        while IFS= read -r line; do
          logo_lines+=("$line")
        done < <(figlet -d "$font_dir" -f "ANSI Shadow" "ARIA")
        font_found=true
        break
      fi
    done
    if [ "$font_found" = false ]; then
      while IFS= read -r line; do
        logo_lines+=("$line")
      done < <(figlet -f "ANSI Shadow" "ARIA" 2>/dev/null || true)
    fi
  fi

  # Fallback to embedded art
  if [ ${#logo_lines[@]} -eq 0 ]; then
    logo_lines=(
      ' █████╗ ██████╗ ██╗ █████╗ '
      '██╔══██╗██╔══██╗██║██╔══██╗'
      '███████║██████╔╝██║███████║'
      '██╔══██║██╔══██╗██║██╔══██║'
      '██║  ██║██║  ██║██║██║  ██║'
      '╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═╝'
    )
  fi

  # Strip trailing blank lines
  while [ ${#logo_lines[@]} -gt 0 ] && [[ "${logo_lines[-1]}" =~ ^[[:space:]]*$ ]]; do
    unset 'logo_lines[-1]'
  done

  # Print with gradient color cascade
  local grads=("$GRAD1" "$GRAD2" "$GRAD3" "$GRAD4" "$GRAD5" "$GRAD6")
  local num_lines=${#logo_lines[@]}

  for i in "${!logo_lines[@]}"; do
    local grad_idx=$(( i * ${#grads[@]} / num_lines ))
    if [ "$grad_idx" -ge ${#grads[@]} ]; then
      grad_idx=$(( ${#grads[@]} - 1 ))
    fi
    echo -e "  ${grads[$grad_idx]}${logo_lines[$i]}${RESET}"
    if [ "$ANIM_DELAY" != "0" ]; then
      sleep "$ANIM_DELAY"
    fi
  done
}

# ─────────────────────────────────────────────────────
# Step helpers
# ─────────────────────────────────────────────────────
step_ok() {
  echo -e "  ${CHECK}  $1"
}

step_warn() {
  echo -e "  ${YELLOW}!${RESET}  $1"
}

step_info() {
  echo -e "       ${DIM}$1${RESET}"
}

# ─────────────────────────────────────────────────────
# Source detection
# ─────────────────────────────────────────────────────
if [ -n "${BASH_SOURCE[0]:-}" ] && [ -f "${BASH_SOURCE[0]}" ]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
else
  # Piped from curl — need git to clone
  if ! command -v git &>/dev/null; then
    echo -e "\n  ${CROSS} git is required for pipe-to-shell install."
    echo -e "  Install git and try again, or clone the repo manually.\n"
    exit 1
  fi
  SCRIPT_DIR="$(mktemp -d)"
  CLEANUP_TEMP="$SCRIPT_DIR"
  echo ""
  echo -e "  ${DIM}Cloning ARIA...${RESET}"
  git clone --depth 1 --quiet "$REPO_URL" "$SCRIPT_DIR"
fi

# Read version
if [ -f "$SCRIPT_DIR/VERSION" ]; then
  ARIA_VERSION="$(tr -d '[:space:]' < "$SCRIPT_DIR/VERSION")"
else
  ARIA_VERSION="dev"
fi

TARGET_DIR="${1:-.}"
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

# Self-install: running from inside the ARIA repo with no target arg
if [ -z "${1:-}" ] && [ "$TARGET_DIR" = "$SCRIPT_DIR" ]; then
  TARGET_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
fi

# Cleanup temp dir on exit
if [ -n "$CLEANUP_TEMP" ]; then
  trap 'rm -rf "$CLEANUP_TEMP"' EXIT
fi

# ─────────────────────────────────────────────────────
# Welcome screen
# ─────────────────────────────────────────────────────
echo ""
print_logo
echo ""
echo -e "  ${DIM}${ITALIC}Agentic Reasoning & Implementation Architecture${RESET}  ${DIM}v${ARIA_VERSION}${RESET}"
echo ""
echo -e "  ${RULE}"
echo ""

# Self-install notice
if [ -z "${1:-}" ] && [ -n "${BASH_SOURCE[0]:-}" ] && [ -f "${BASH_SOURCE[0]}" ]; then
  ORIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  if [ "$ORIG_DIR" = "$(cd "$SCRIPT_DIR" && pwd)" ] && [ "$TARGET_DIR" != "$SCRIPT_DIR" ]; then
    echo -e "  ${YELLOW}◆${RESET} ${YELLOW}Running from ARIA repo — installing to parent directory${RESET}"
    echo ""
  fi
fi

TOOL_LABEL="$AI_TOOL"
case "$AI_TOOL" in
  claude-code) TOOL_LABEL="Claude Code" ;;
  cursor) TOOL_LABEL="Cursor" ;;
  windsurf) TOOL_LABEL="Windsurf" ;;
  cline) TOOL_LABEL="Cline" ;;
  all) TOOL_LABEL="All tools" ;;
esac

echo -e "  ${DIM}Source${RESET}   $SCRIPT_DIR"
echo -e "  ${DIM}Target${RESET}   ${BOLD}$TARGET_DIR${RESET}"
echo -e "  ${DIM}Tool${RESET}     $TOOL_LABEL"
echo ""

# ─────────────────────────────────────────────────────
# Validate source
# ─────────────────────────────────────────────────────
if [ ! -d "$SCRIPT_DIR/src/core" ]; then
  echo -e "  ${CROSS} src/core/ not found in $SCRIPT_DIR"
  echo "  Make sure you're running this from the ARIA repository root."
  exit 1
fi
if [ ! -d "$SCRIPT_DIR/src/platforms" ]; then
  echo -e "  ${CROSS} src/platforms/ not found in $SCRIPT_DIR"
  echo "  Make sure you're running this from the ARIA repository root."
  exit 1
fi

# ─────────────────────────────────────────────────────
# Platform selection
# ─────────────────────────────────────────────────────
EXISTING_PLATFORM=""
if [ -f "$TARGET_DIR/_aria/.platform" ]; then
  EXISTING_PLATFORM="$(tr -d '[:space:]' < "$TARGET_DIR/_aria/.platform")"
fi

echo -e "  ${BOLD}Select your platform:${RESET}"
echo ""
if [ -n "$EXISTING_PLATFORM" ]; then
  echo -e "  ${DIM}  Previously installed: $EXISTING_PLATFORM${RESET}"
  echo ""
fi
echo -e "    ${CYAN}1${RESET}  Plane  ${DIM}(recommended)${RESET}"
echo -e "    ${CYAN}2${RESET}  Linear"
echo ""
if [ -t 0 ]; then
  read -p "  Choice (1-2): " -n 1 -r PLATFORM_CHOICE
else
  read -p "  Choice (1-2): " -n 1 -r PLATFORM_CHOICE < /dev/tty
fi
echo ""
echo ""

case "$PLATFORM_CHOICE" in
  1) PLATFORM="plane";  PLATFORM_LABEL="Plane" ;;
  2) PLATFORM="linear"; PLATFORM_LABEL="Linear" ;;
  *)
    echo -e "  ${CROSS} Invalid choice. Please run the installer again and select 1 or 2."
    exit 1
    ;;
esac

if [ ! -d "$SCRIPT_DIR/src/platforms/$PLATFORM" ]; then
  echo -e "  ${CROSS} src/platforms/$PLATFORM/ not found in $SCRIPT_DIR"
  exit 1
fi

echo -e "  ${RULE}"
echo ""
echo -e "  Installing ARIA for ${BOLD}${PLATFORM_LABEL}${RESET}..."
echo ""

# ─────────────────────────────────────────────────────
# Detect re-install / legacy migration
# ─────────────────────────────────────────────────────
IS_REINSTALL=false
CORE_DIR="$TARGET_DIR/_aria/core"
PLATFORM_DIR="$TARGET_DIR/_aria/platform"
SHARED_DIR="$TARGET_DIR/_aria/shared"
LEGACY_LINEAR_DIR="$TARGET_DIR/_aria/linear"
LEGACY_BMAD_DIR="$TARGET_DIR/_bmad/linear"

if [ -d "$CORE_DIR" ]; then
  IS_REINSTALL=true
  step_warn "Existing ARIA installation detected — config will be preserved"
elif [ -d "$LEGACY_LINEAR_DIR" ]; then
  IS_REINSTALL=true
  step_warn "Legacy v1.x installation detected — migrating"
  mkdir -p "$CORE_DIR" "$CORE_DIR/data"
  for CONFIG_FILE in module.yaml; do
    if [ -f "$LEGACY_LINEAR_DIR/$CONFIG_FILE" ]; then
      cp "$LEGACY_LINEAR_DIR/$CONFIG_FILE" "$CORE_DIR/$CONFIG_FILE"
      step_info "Migrated _aria/linear/$CONFIG_FILE → _aria/core/$CONFIG_FILE"
    fi
  done
  if [ -f "$LEGACY_LINEAR_DIR/.linear-key-map.yaml" ]; then
    cp "$LEGACY_LINEAR_DIR/.linear-key-map.yaml" "$CORE_DIR/data/.key-map.yaml"
    step_info "Migrated .linear-key-map.yaml → _aria/core/data/.key-map.yaml"
  fi
  rm -rf "$LEGACY_LINEAR_DIR"
  step_info "Removed legacy _aria/linear/"
elif [ -d "$LEGACY_BMAD_DIR" ]; then
  IS_REINSTALL=true
  step_warn "Legacy BMAD installation detected — migrating to ARIA"
  mkdir -p "$CORE_DIR" "$CORE_DIR/data"
  for CONFIG_FILE in module.yaml; do
    if [ -f "$LEGACY_BMAD_DIR/$CONFIG_FILE" ]; then
      cp "$LEGACY_BMAD_DIR/$CONFIG_FILE" "$CORE_DIR/$CONFIG_FILE"
      step_info "Migrated _bmad/linear/$CONFIG_FILE → _aria/core/$CONFIG_FILE"
    fi
  done
  if [ -f "$LEGACY_BMAD_DIR/.linear-key-map.yaml" ]; then
    cp "$LEGACY_BMAD_DIR/.linear-key-map.yaml" "$CORE_DIR/data/.key-map.yaml"
    step_info "Migrated .linear-key-map.yaml → _aria/core/data/.key-map.yaml"
  fi
  rm -rf "$TARGET_DIR/_bmad"
  step_info "Removed legacy _bmad/"
  rm -f "$TARGET_DIR/.claude/commands/bmad-"*.md
  step_info "Removed legacy bmad-* slash commands"
fi

if [ "$IS_REINSTALL" = true ]; then
  echo ""
fi

# ─────────────────────────────────────────────────────
# Backup config files before overwrite
# ─────────────────────────────────────────────────────
if [ "$IS_REINSTALL" = true ] && [ -d "$CORE_DIR" ]; then
  for CONFIG_FILE in module.yaml data/.key-map.yaml; do
    if [ -f "$CORE_DIR/$CONFIG_FILE" ]; then
      cp "$CORE_DIR/$CONFIG_FILE" "$CORE_DIR/$CONFIG_FILE.bak"
    fi
  done
fi

# Clean up lingering legacy dir
if [ -d "$LEGACY_LINEAR_DIR" ]; then
  rm -rf "$LEGACY_LINEAR_DIR"
fi

# ─────────────────────────────────────────────────────
# Installation steps
# ─────────────────────────────────────────────────────

# 1. Create directories
mkdir -p "$CORE_DIR" "$PLATFORM_DIR" "$SHARED_DIR"
step_ok "Created directories"

# 2. Shared content
cp -r "$SCRIPT_DIR/src/shared/"* "$SHARED_DIR/"
step_ok "Installed shared content ${DIM}→ _aria/shared/${RESET}"

# 3. Core module
cp -r "$SCRIPT_DIR/src/core/"* "$CORE_DIR/"
step_ok "Installed core module ${DIM}→ _aria/core/${RESET}"

# 4. Platform
rm -rf "$PLATFORM_DIR/"*
cp -r "$SCRIPT_DIR/src/platforms/$PLATFORM/"* "$PLATFORM_DIR/"
echo "$PLATFORM" > "$TARGET_DIR/_aria/.platform"
step_ok "Installed ${BOLD}$PLATFORM_LABEL${RESET} platform ${DIM}→ _aria/platform/${RESET}"

# 5. Version file
if [ -f "$SCRIPT_DIR/VERSION" ]; then
  cp "$SCRIPT_DIR/VERSION" "$CORE_DIR/VERSION"
fi
step_ok "Wrote version file ${DIM}(v${ARIA_VERSION})${RESET}"

# 6. Restore config files
if [ "$IS_REINSTALL" = true ] && [ -d "$CORE_DIR" ]; then
  RESTORED=false
  for CONFIG_FILE in module.yaml data/.key-map.yaml; do
    if [ -f "$CORE_DIR/$CONFIG_FILE.bak" ]; then
      mv "$CORE_DIR/$CONFIG_FILE.bak" "$CORE_DIR/$CONFIG_FILE"
      RESTORED=true
    fi
  done
  if [ "$RESTORED" = true ]; then
    step_ok "Restored config files ${DIM}(module.yaml, .key-map.yaml)${RESET}"
  fi
fi

# ─────────────────────────────────────────────────────
# AI Tool Config Installation
# ─────────────────────────────────────────────────────
COMMAND_COUNT=0

install_claude_code() {
  # CLAUDE.md
  local ARIA_MARKER="# ARIA"
  if [ -f "$TARGET_DIR/CLAUDE.md" ]; then
    if grep -q "$ARIA_MARKER" "$TARGET_DIR/CLAUDE.md"; then
      ARIA_LINE=$(grep -n "$ARIA_MARKER" "$TARGET_DIR/CLAUDE.md" | head -1 | cut -d: -f1)
      head -n $((ARIA_LINE - 1)) "$TARGET_DIR/CLAUDE.md" > "$TARGET_DIR/CLAUDE.md.tmp"
      echo "" >> "$TARGET_DIR/CLAUDE.md.tmp"
      cat "$SCRIPT_DIR/CLAUDE.md" >> "$TARGET_DIR/CLAUDE.md.tmp"
      mv "$TARGET_DIR/CLAUDE.md.tmp" "$TARGET_DIR/CLAUDE.md"
      step_ok "Updated CLAUDE.md ${DIM}(replaced ARIA section)${RESET}"
    else
      echo "" >> "$TARGET_DIR/CLAUDE.md"
      cat "$SCRIPT_DIR/CLAUDE.md" >> "$TARGET_DIR/CLAUDE.md"
      step_ok "Updated CLAUDE.md ${DIM}(appended ARIA section)${RESET}"
    fi
  else
    cp "$SCRIPT_DIR/CLAUDE.md" "$TARGET_DIR/CLAUDE.md"
    step_ok "Created CLAUDE.md"
  fi

  # Slash commands
  mkdir -p "$TARGET_DIR/.claude/commands"
  for OLD_CMD in aria-attack aria-edges aria-edit-prose aria-edit-struct aria-prd-edit aria-prd-check aria-doc-check aria-explain aria-context aria-review aria-status; do
    rm -f "$TARGET_DIR/.claude/commands/$OLD_CMD.md"
  done
  if [ "$SCRIPT_DIR" != "$TARGET_DIR" ]; then
    cp "$SCRIPT_DIR/.claude/commands/"*.md "$TARGET_DIR/.claude/commands/"
  fi
  COMMAND_COUNT=$(ls -1 "$TARGET_DIR/.claude/commands/aria-"*.md 2>/dev/null | wc -l)
  step_ok "Installed ${BOLD}${COMMAND_COUNT}${RESET} slash commands ${DIM}→ .claude/commands/${RESET}"
}

install_cursor() {
  mkdir -p "$TARGET_DIR/.cursor/rules"
  if [ -f "$SCRIPT_DIR/src/tools/cursor/aria.mdc" ]; then
    cp "$SCRIPT_DIR/src/tools/cursor/aria.mdc" "$TARGET_DIR/.cursor/rules/aria.mdc"
    step_ok "Installed Cursor rules ${DIM}→ .cursor/rules/aria.mdc${RESET}"
  else
    step_warn "Cursor config not found in source"
  fi
}

install_windsurf() {
  mkdir -p "$TARGET_DIR/.windsurf/rules"
  if [ -f "$SCRIPT_DIR/src/tools/windsurf/aria.md" ]; then
    cp "$SCRIPT_DIR/src/tools/windsurf/aria.md" "$TARGET_DIR/.windsurf/rules/aria.md"
    step_ok "Installed Windsurf rules ${DIM}→ .windsurf/rules/aria.md${RESET}"
  else
    step_warn "Windsurf config not found in source"
  fi
}

install_cline() {
  mkdir -p "$TARGET_DIR/.clinerules"
  if [ -f "$SCRIPT_DIR/src/tools/cline/aria.md" ]; then
    cp "$SCRIPT_DIR/src/tools/cline/aria.md" "$TARGET_DIR/.clinerules/aria.md"
    step_ok "Installed Cline rules ${DIM}→ .clinerules/aria.md${RESET}"
  else
    step_warn "Cline config not found in source"
  fi
}

case "$AI_TOOL" in
  claude-code) install_claude_code ;;
  cursor)      install_cursor ;;
  windsurf)    install_windsurf ;;
  cline)       install_cline ;;
  all)
    install_claude_code
    install_cursor
    install_windsurf
    install_cline
    ;;
esac

# ─────────────────────────────────────────────────────
# .gitignore
# ─────────────────────────────────────────────────────
if [ -f "$TARGET_DIR/.gitignore" ]; then
  GITIGNORE_UPDATED=false
  for PATTERN in "_aria/core/module.yaml" "_aria/core/data/.key-map.yaml"; do
    if ! grep -q "$PATTERN" "$TARGET_DIR/.gitignore" 2>/dev/null; then
      echo "$PATTERN" >> "$TARGET_DIR/.gitignore"
      GITIGNORE_UPDATED=true
    fi
  done
  if [ "$GITIGNORE_UPDATED" = true ]; then
    step_ok "Updated .gitignore"
  else
    step_ok "Checked .gitignore ${DIM}(already configured)${RESET}"
  fi
else
  step_ok "Checked .gitignore ${DIM}(no .gitignore found)${RESET}"
fi

# ─────────────────────────────────────────────────────
# Completion
# ─────────────────────────────────────────────────────
echo ""
echo -e "  ${RULE}"

# Brief dramatic pause for interactive terminals
if [ "$ANIM_DELAY" != "0" ]; then
  sleep 0.15
fi

echo ""
echo -e "  ${GREEN}${BOLD}${SPARKLE} Installation complete!${RESET}  ${DIM}v${ARIA_VERSION}${RESET}"
echo ""

# Summary
echo -e "  ${DIM}Installed:${RESET}"
echo -e "    ${DIAMOND} Core module          ${DIM}_aria/core/${RESET}"
echo -e "    ${DIAMOND} $PLATFORM_LABEL platform       ${DIM}_aria/platform/${RESET}"
echo -e "    ${DIAMOND} Shared content       ${DIM}_aria/shared/${RESET}"
case "$AI_TOOL" in
  claude-code)
    echo -e "    ${DIAMOND} CLAUDE.md            ${DIM}ARIA context${RESET}"
    echo -e "    ${DIAMOND} Slash commands       ${DIM}${COMMAND_COUNT} commands${RESET}"
    ;;
  cursor)  echo -e "    ${DIAMOND} Cursor rules         ${DIM}.cursor/rules/aria.mdc${RESET}" ;;
  windsurf) echo -e "    ${DIAMOND} Windsurf rules       ${DIM}.windsurf/rules/aria.md${RESET}" ;;
  cline)   echo -e "    ${DIAMOND} Cline rules          ${DIM}.clinerules/aria.md${RESET}" ;;
  all)
    echo -e "    ${DIAMOND} CLAUDE.md            ${DIM}ARIA context + ${COMMAND_COUNT} commands${RESET}"
    echo -e "    ${DIAMOND} Cursor rules         ${DIM}.cursor/rules/aria.mdc${RESET}"
    echo -e "    ${DIAMOND} Windsurf rules       ${DIM}.windsurf/rules/aria.md${RESET}"
    echo -e "    ${DIAMOND} Cline rules          ${DIM}.clinerules/aria.md${RESET}"
    ;;
esac
if [ "$IS_REINSTALL" = true ]; then
  echo -e "    ${DIAMOND} Config preserved     ${DIM}module.yaml, .key-map.yaml${RESET}"
fi

echo ""
echo -e "  ${BOLD}Get started:${RESET}"
if [ "$PLATFORM" = "linear" ]; then
  echo -e "    ${ARROW} Configure the Linear MCP server in your AI tool"
elif [ "$PLATFORM" = "plane" ]; then
  echo -e "    ${ARROW} Configure the Plane MCP server in your AI tool"
fi
echo -e "    ${ARROW} Run ${BOLD}/aria-setup${RESET}  to auto-configure your workspace"
echo -e "    ${ARROW} Run ${BOLD}/aria-git${RESET}    to configure git integration"
echo -e "    ${ARROW} Run ${BOLD}/aria-doctor${RESET} to verify everything works"
echo -e "    ${ARROW} Run ${BOLD}/aria-help${RESET}   when you need guidance"

# Fun closing — random orchestral quote
QUOTES=(
  "The conductor has taken the podium."
  "All instruments are in tune."
  "The overture begins."
  "Every great composition starts with a single note."
  "The orchestra awaits your downbeat."
  "Your ensemble is assembled."
  "The stage is set."
)
QUOTE="${QUOTES[$((RANDOM % ${#QUOTES[@]}))]}"

echo ""
echo -e "  ${DIM}♪ \"${QUOTE}\"${RESET}"
echo -e "  ${DIM}  Happy building! ${SPARKLE}${RESET}"
echo ""
