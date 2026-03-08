# Autonomy Logic — Shared Include

When a workflow step requires a user decision, apply this pattern based on `autonomy_level` from module.yaml:

## Pattern

```
{if autonomy_level == "interactive"}
  Present all options to the user and WAIT for explicit selection.
  Do not proceed until the user confirms.
{else if autonomy_level == "balanced"}
  Auto-select the most obvious or recommended choice.
  Report: "Auto-selected: {choice}. Press Enter to confirm or type an alternative."
  Wait 3 seconds for override, then proceed.
{else}  # yolo
  Auto-select the best choice based on available data.
  Report: "Selected: {choice}." and proceed immediately.
  Only pause if the action is destructive or irreversible.
{end_if}
```

## Destructive Actions (always confirm regardless of autonomy level)

These actions require user confirmation even in `yolo` mode:
- Deleting issues, projects, or documents
- Course corrections that change project scope
- Force-unlocking stale issues
- Overwriting existing artefacts (PRD, architecture)
- Marking a project as completed

## Quick Reference

| Autonomy | User Decision | Destructive Action |
|---|---|---|
| interactive | Wait for selection | Wait for selection |
| balanced | Auto-select + brief wait | Wait for selection |
| yolo | Auto-select + proceed | Wait for selection |
