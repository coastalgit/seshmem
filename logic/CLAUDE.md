# seshmem — Session Memory for Claude Code

## What This Is

This is the **logic directory** for seshmem — a session checkpoint system for Claude Code that preserves conversation context across sessions. The `seshmem/` subdirectory contains the skill files (slash commands) that get deployed to `~/.claude/commands/seshmem/`.

## Architecture

### Skill Files (`seshmem/`)

| File | Command | Purpose |
|------|---------|---------|
| `save.md` | `/seshmem:save` | Non-blocking background checkpoint save with feedback collection |
| `load.md` | `/seshmem:load` | Load checkpoint(s), check git state, present resume prompt |
| `list.md` | `/seshmem:list` | Show session index or list available checkpoints |
| `help.md` | `/seshmem:help` | Usage instructions and version info |

### How It Works

- Checkpoints stored as markdown in `.claude/seshmem/` within each project
- Filename format: `YYYY-MM-DD-HHMM.md`
- Session index: `seshes.md` — one-line summary per session
- Save is non-blocking — user can keep talking while checkpoint writes
- Load presents a "Prompt for Next Chat" but never auto-executes it
- Warnings from previous sessions are first-class citizens, displayed prominently on load

### Storage Convention

Each project using seshmem has:
```
<project>/
  .claude/seshmem/
    seshes.md              — Session index
    YYYY-MM-DD-HHMM.md    — Checkpoint files
```

## Development

### Versioning

Version is defined in `seshmem/help.md` and displayed when users run `/seshmem:help`.

### Deploying

Run `deploy.sh` from the project root to:
1. Copy `logic/seshmem/` to `~/.claude/commands/seshmem/`
2. Create a versioned snapshot in `releases/` locally

### Key Design Decisions

- **Non-blocking save**: Background agent writes checkpoint while user continues talking
- **Human-in-the-loop**: Prompt for next chat is drafted by AI, confirmed by user
- **Minimal index**: `seshes.md` is one-line-per-session to avoid context bloat
- **Git-committed**: Checkpoints travel with the project code
- **Project-scoped**: No cross-project memory; each project has its own seshmem dir
