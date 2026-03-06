---
description: Load session memory checkpoint(s) from .claude/seshmem/ and resume work. Loads latest by default, a number for last N, or a specific filename.
---

## Load Procedure

### 1. Determine which checkpoint(s) to load

- **If `$ARGUMENTS` is empty**: load the most recent checkpoint only.
- **If `$ARGUMENTS` is a number (e.g. `3`)**: load the last N checkpoints in chronological order (oldest first). This gives multi-session context for understanding progression.
- **If `$ARGUMENTS` is a filename**: treat it as a specific checkpoint (with or without `.md` extension) and read `.claude/seshmem/<filename>.md`.

To find checkpoints, list `.claude/seshmem/*.md` sorted by name (YYYY-MM-DD-HHMM.md format). Exclude `seshes.md` from the list — that's the index file.

If the target file(s) do not exist, list all available checkpoints and stop — do not proceed until the user clarifies.

### 2. Read the session index

Read `.claude/seshmem/seshes.md` if it exists. This gives a quick overview of all sessions without loading full checkpoints.

### 3. Read root CLAUDE.md

Read `CLAUDE.md` at the project root for full project context.

### 4. Check git state

Run `git branch`, `git log --oneline -5`, and `git status` to understand current branch, recent commits, and any uncommitted work.

### 5. Summarize to the user

Present a concise summary:
- If loading 1 checkpoint: last session date, what was accomplished, current state, next steps
- If loading N checkpoints: brief arc across sessions (what progressed, what changed direction), then current state and next steps from the most recent
- Current branch and any uncommitted changes
- Open questions / blockers
- **Warnings from previous session** (if any) — display these prominently

### 6. Present the Prompt for Next Chat

**This is mandatory.** Check the most recent loaded checkpoint for a `## Prompt for Next Chat` section.

- If one exists, display it clearly to the user:

  ```
  **Prompt from last session:**
  > Read `src/lib/parsers/` and `src/lib/ingestion.ts`. Then wire up CDR persistence...

  Do you want to continue with this, or do something else?
  ```

- **Do NOT execute the prompt.** Wait for the user to confirm, modify, or ignore it.
- If loading multiple checkpoints, ONLY present the prompt from the most recent one.
- If no prompt exists in the checkpoint, fall back to suggesting the "Next Steps" section as options.

### 7. Wait for user direction

After presenting the summary and prompt, wait. The user will either:
- Confirm the prompt ("yes", "go", "do it") — then execute it
- Modify it ("do that but skip the tests") — execute the modified version
- Ignore it and give a different instruction — follow their instruction
- Ask questions about the checkpoint — answer them

**Do NOT start doing work until the user explicitly says what to do.**

## Rules
- Do NOT auto-execute the prompt for next chat — ALWAYS present it and wait
- If there are uncommitted changes, flag them before anything else
- If the most recent checkpoint references files that should exist but don't, flag that too
- Keep the summary brief — the user was there last time, they just need a refresh
- When loading multiple checkpoints, don't dump all of them — synthesize the arc into a coherent narrative
- Display warnings from the most recent checkpoint prominently — these are traps the last session identified
