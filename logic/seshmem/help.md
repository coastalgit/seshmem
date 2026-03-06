---
description: Show how to use seshmem — the session memory system for Claude Code context continuity across conversations.
---

## What is seshmem?

**seshmem** (session memory) is a checkpoint system that preserves conversation context across Claude Code sessions. It solves the problem of Claude losing all context when a conversation ends — each checkpoint captures what was done, what's in progress, and what to do next, so the next session can pick up seamlessly.

**Version:** 1.1.0 | Created by BF

Checkpoints are stored as dated markdown files in `.claude/seshmem/` within each project.

---

## Commands

### `/seshmem:save` — Save a checkpoint

Captures the current session state as a timestamped checkpoint file.

**Usage:**

```
/seshmem:save
/seshmem:save focus on the parser work
/seshmem:save exclude references to the old API
```

**What happens:**

1. You're asked for optional session feedback (what worked, what didn't)
2. A background agent writes the checkpoint while you keep working
3. You're asked to confirm a "Prompt for Next Chat" — a ready-to-execute instruction for next time
4. The checkpoint and session index (`seshes.md`) are committed to git

**What's captured:**

- Session summary (what was discussed/decided/built)
- Current state (branch, phase, what's working)
- Build artifacts manifest (compact map of codebase structure)
- Open questions (categorized by urgency)
- Next steps (numbered action list)
- Key files created/modified
- Decisions made (with status)
- Warnings for next session (traps to avoid)
- Prompt for next chat (specific pickup instruction)

**The optional argument** modifies emphasis — e.g. `focus on X` or `exclude Y`.

---

### `/seshmem:load` — Load checkpoint(s) and resume

Reads checkpoint(s), checks git state, and presents a summary with the saved prompt.

**Usage:**

```
/seshmem:load              — load most recent checkpoint
/seshmem:load 3            — load last 3 (shows progression arc)
/seshmem:load 2026-03-06-0430   — load a specific checkpoint
```

**What happens:**

1. Reads the checkpoint file(s) and session index
2. Reads root `CLAUDE.md` for project context
3. Checks git branch, recent commits, uncommitted changes
4. Presents a concise summary: what happened, current state, warnings
5. Displays the **Prompt for Next Chat** and waits for your go-ahead

**Important:** The prompt is never auto-executed. You confirm, modify, or ignore it.

---

### `/seshmem:list` — List all checkpoints

Shows the session index table if it exists, or lists available checkpoint files with date range.

**Usage:**

```
/seshmem:list
```

**Output:** Either the `seshes.md` index table, or a summary like:

```
No session index found. 10 checkpoint files available:
  Earliest: 2026-02-27-1859.md
  Latest:   2026-03-06-0430.md
```

---

## File Structure

```
.claude/seshmem/
  seshes.md                  — Session index (one-line summary per session)
  2026-02-27-1859.md         — Checkpoint files (YYYY-MM-DD-HHMM.md)
  2026-02-27-2145.md
  2026-03-06-0430.md
  ...
  notes/                     — Project documentation (optional)
```

---

## Typical Workflow

### Starting a session

```
/seshmem:load
```

Read the summary, review warnings, then confirm or modify the prompt to begin working.

### During a session

Work normally. seshmem doesn't interfere with your workflow.

### Ending a session

```
/seshmem:save
```

Give feedback if you want, confirm the prompt for next time, done.

### Checking history

```
/seshmem:list
/seshmem:load 3        — see last 3 sessions for context
```

---

## Tips

- **Save often if switching context** — cheap insurance against lost work
- **Be specific in feedback** — "the parser kept failing on binary chars" is more useful than "it was buggy"
- **Edit the prompt for next chat** — a good prompt saves 5-10 minutes of orientation next session
- **Use the argument on save** to focus the checkpoint on what matters (e.g. `/seshmem:save focus on ingestion engine decisions`)
- **Warnings are the most valuable part** — they prevent repeating mistakes across sessions
- **Load multiple checkpoints** (`/seshmem:load 3`) when you need to understand how a decision evolved over time
