# Step Menu — Shared Include

When a workflow step offers optional side-activities, use this standard menu:

## Pattern

```
Select an option:
[C] Continue to {next_step_description}
[D] Deep Dive — invoke advanced elicitation for deeper analysis
[P] Party Mode — discuss this topic with multiple agent perspectives
```

## Behavior by Autonomy Level

| Autonomy | Default | Menu Shown? |
|---|---|---|
| interactive | Wait for selection | Yes — show full menu |
| balanced | Auto-select [C] Continue | No — only show if user explicitly asks for options |
| yolo | Auto-select [C] Continue | Never shown |

## When to Include This Menu

Only include this menu at **natural pause points** between workflow phases — not at every step. Typical locations:
- After initial requirements gathering (before analysis)
- After analysis (before output generation)
- After output (before handoff)

Do NOT include this menu:
- At every step (causes menu fatigue)
- During implementation steps (breaks flow)
- When the next step is obvious and required
