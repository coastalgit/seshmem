---
description: List all session memory checkpoints. Shows index if available, otherwise just lists files with date range.
---

## Procedure

### 1. Check for session index

If `.claude/seshmem/seshes.md` exists, read it and display the table to the user. Done.

### 2. If no index exists

Do NOT try to rebuild or generate the index automatically.

Instead, list all `.md` files in `.claude/seshmem/` (excluding `seshes.md`), and display:

```
No session index found. 10 checkpoint files available:
  Earliest: 2026-02-27-1859.md
  Latest:   2026-03-06-0430.md

Want me to extract a summary from a specific date? Give me a filename or date.
```

Let the user decide if they want to look at specific checkpoints. Do NOT read them all to build a summary — that wastes context.

### 3. Offer options

After displaying whatever is available, remind the user:
- `/seshmem:load` — load the most recent checkpoint
- `/seshmem:load 3` — load the last 3 checkpoints
- `/seshmem:load <filename>` — load a specific checkpoint
