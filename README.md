# seshmem

**Session Memory for Claude Code** — a checkpoint system that preserves conversation context across sessions.

Created by BF, March 2026.

## Note

seshmem was created prior to various evolutionary changes in Claude Code's memory and context capabilities. It remains useful when used in conjunction with tools such as the superpowers episodic-memory plugin, providing structured checkpoint detail that complements broader conversational recall.

## The Problem

Claude Code loses all context when a conversation ends. For complex projects with dozens of design decisions, file paths, and in-progress work, re-establishing context manually wastes significant time and risks losing nuance.

## The Solution

seshmem provides structured checkpoint files that capture everything a fresh session needs to continue seamlessly: what was done, what's in progress, decisions made, warnings to heed, and a ready-to-execute prompt for the next session.

## Commands

| Command | Description |
|---------|-------------|
| `/seshmem:save [note]` | Save a checkpoint (non-blocking, with optional feedback) |
| `/seshmem:load [N\|filename]` | Load checkpoint(s) and resume work |
| `/seshmem:list` | List all checkpoints |
| `/seshmem:help` | Usage instructions and version info |

## Installation

Copy the skill files to your Claude Code commands directory:

```bash
# From this repo
./deploy.sh
```

Or manually:

```bash
cp -r logic/seshmem/ ~/.claude/commands/seshmem/
```

Then create `.claude/seshmem/` in any project you want to use it with.

## Usage

```
# Start of session — load last checkpoint
/seshmem:load

# End of session — save checkpoint
/seshmem:save

# Check history
/seshmem:list

# Load last 3 sessions for context
/seshmem:load 3
```

## What's Captured in a Checkpoint

- Session summary (what was discussed/decided/built)
- Current state (branch, phase, what's working)
- Build artifacts manifest
- Open questions (categorized by urgency)
- Next steps (numbered action list)
- Key files created/modified
- Decisions made (with status)
- Session feedback (user's raw comments)
- Warnings for next session (traps to avoid)
- Prompt for next chat (specific pickup instruction)

## Project Structure

```
seshmem/
  logic/
    seshmem/          — Skill files (deployed to ~/.claude/commands/seshmem/)
      save.md
      load.md
      list.md
      help.md
    CLAUDE.md         — Project instructions for this directory
  releases/           — Versioned snapshots of each release
  deploy.sh           — Deploy skill files to ~/.claude/commands/
  README.md           — This file
  CHANGELOG.md        — Release history
```

## Known Limitations

- **No cross-project memory** — each project has its own seshmem directory
- **Context cost** — loading 3+ large checkpoints can consume significant tokens
- **No automatic cleanup** — old checkpoints accumulate without pruning
- **Claude Code only** — depends on slash commands, not usable outside CLI

## License

Personal project by BF
