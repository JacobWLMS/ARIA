# Autonomy Configuration

ARIA's autonomy level controls how much agents ask for user confirmation before acting.

## Levels

| Level | Derived From | Behavior |
|---|---|---|
| `interactive` | `user_skill_level: beginner` | Always asks for confirmation before proceeding |
| `balanced` | `user_skill_level: intermediate` | Auto-proceeds when the next step is obvious; asks on ambiguous actions |
| `yolo` | `user_skill_level: expert` | Fully autonomous -- agents proceed without asking |

## How It's Set

Autonomy is derived from `user_skill_level` in module.yaml, which is set during `/aria-setup`:

- **beginner** → `interactive` -- recommended for new users or unfamiliar projects
- **intermediate** → `balanced` -- recommended for most users
- **expert** → `yolo` -- recommended for experienced users who trust the workflow

You can override `autonomy_level` directly in module.yaml if you want a different mapping.

## What Each Level Controls

### Step Menus

At natural pause points, agents may present an A/P/C menu:

- **[A] Advanced** -- configure step details or explore options
- **[P] Party** -- discuss the step in multi-agent mode
- **[C] Continue** -- proceed with defaults

| Autonomy | Menu Behavior |
|---|---|
| interactive | Always shown; waits for user input |
| balanced | Shown at key decision points; auto-selects Continue for routine steps |
| yolo | Never shown; always auto-continues |

### Technique Selection

In brainstorming and research workflows:

| Autonomy | Behavior |
|---|---|
| interactive | User selects techniques manually |
| balanced | AI recommends techniques; auto-proceeds |
| yolo | AI selects and auto-proceeds |

### Scope Confirmation

In PRD, architecture, and planning workflows:

| Autonomy | Behavior |
|---|---|
| interactive | Confirms scope, constraints, and goals with user |
| balanced | Infers scope from context; confirms only when ambiguous |
| yolo | Infers everything from context; proceeds directly |

## Safety Overrides

Regardless of autonomy level, these actions **always** require user confirmation:

- **Course corrections** -- mid-implementation changes that affect scope or direction
- **Destructive operations** -- deleting issues, removing labels, resetting state
- **Git operations** -- force pushes, branch deletions, merging to main

These safety overrides cannot be bypassed by any autonomy setting.
