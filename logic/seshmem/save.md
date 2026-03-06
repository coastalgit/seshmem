---
description: Save a session memory checkpoint to .claude/seshmem/ for context continuity across sessions. Optional note argument guides what to emphasise or exclude.
---

## Execution Flow

This command runs as a **non-blocking background save**. The flow is:

1. **Immediately ask the user:** "Do you want to leave feedback for this session? (Y/N)"
2. **Launch the checkpoint agent** in the background (via Task tool with `run_in_background` or Agent) to gather git state, write the checkpoint file, and update the index.
3. **While the agent is running:**
   - If user said **N**: tell them "Backing up session... I'll let you know when it's done." The user can continue talking — respond normally to whatever they say.
   - If user said **Y**: collect their feedback comments. They may send multiple messages. Keep collecting until they indicate they're done (e.g. "that's it", "done", moves on to another topic). Store all feedback comments in memory.
4. **When the background agent completes:**
   - If the user provided feedback, **append** a `## Session Feedback` section and a `## Warnings for Next Session` section to the checkpoint file. Feedback is the user's raw comments. Warnings are actionable traps to avoid, distilled from feedback and from friction points observed during the session.
   - Also ask the user for the **Prompt for Next Chat** (see section below) — or draft one and ask them to confirm/edit.
   - Update `seshes.md` and commit.

**IMPORTANT:** The user can keep talking to you while the checkpoint is being written. Do NOT block the conversation. Any messages from the user during the save should be processed normally. Only the final append of feedback/warnings/prompt requires the checkpoint file to exist.

---

## Checkpoint Agent Instructions

The background agent should:

### 1. Get timestamp and create file
```bash
mkdir -p .claude/seshmem && date '+%Y-%m-%d-%H%M'
```
Use the output as the filename: `.claude/seshmem/YYYY-MM-DD-HHMM.md`

### 2. If `$ARGUMENTS` is non-empty
Treat it as a note that modifies how the checkpoint is written. For example:
- `exclude references to the old API` — omit details about the old API
- `focus on the rating engine work` — emphasise that area, be brief on everything else

### 3. Write checkpoint sections

#### 1. Session Summary
- What was discussed and decided this session
- List concrete actions taken (files created, commands run, tools installed, etc.)

#### 2. Current State
- Where we are in the brainstorm/design/build process
- Current git branch and commit state
- What's working, what's in progress

#### 3. Build Artifacts
A compact manifest of what exists in the codebase and what each part does. Saves the next session from having to Glob+Read everything to orient. Keep to ~15-20 lines max. Example:
```
src/lib/parsers/     — BUF/CST/CAS parsers (real, tested against 2025 records)
src/lib/interfaces/  — IDatabase, IStorage, IAI, IAuth abstractions
src/components/      — sidebar, data-assistant, file-upload
8 routes render, build passes clean
```
Only include what's relevant — not every file, just structure and state (working/stubbed/broken).

#### 4. Open Questions
- Unresolved decisions or items pending input
- Categorize as: Immediate (next session), This Week, Unresolved

#### 5. Next Steps
- Numbered list of what to do when resuming
- First step should always be "Read this checkpoint and root CLAUDE.md"

#### 6. Key Files Created/Modified This Session
- Table with File path and Action (Created/Modified/Deleted)

#### 7. Decisions Made
- Table with Decision and Status (Done/Confirmed/Planned/Open/Rejected)

### 4. Sections added AFTER agent completes (by the main conversation)

These are appended to the checkpoint file once the agent finishes and user feedback is collected:

#### 8. Session Feedback (if user provided any)
The user's raw comments about the session — what worked, what was frustrating, what the AI got wrong. Preserved verbatim.

#### 9. Warnings for Next Session
Actionable traps distilled from feedback AND from friction observed during the session. Phrased as "Do NOT..." or "Watch out for..." directives. Examples:
```
- Do NOT set up Firebase infra. We are using mock interfaces for now.
- BUF files have binary STX (0x02) before the 0! marker — strip first.
- User prefers compact output. Don't dump full file contents.
```

#### 10. Prompt for Next Chat
A ready-to-execute instruction for the next session. Should include:
- **Which files to read first** (saves the next AI from blind exploration)
- **What to build/do next** (specific, actionable task)
- **Any constraints** (things NOT to do)

Example:
```
Read `src/lib/parsers/` and `src/lib/ingestion.ts`. Then wire up CDR persistence —
parsed CDRs from the upload API should be saved via db.saveCDRs(). Do NOT set up
Firebase. Keep using mock services.
```

The AI should draft this prompt based on the session context, then present it to the user for confirmation or editing before writing it.

---

## Update Session Index

After writing the full checkpoint (including feedback/warnings/prompt), update (or create) `.claude/seshmem/seshes.md`. This is a running index — one line per session, most recent at the top. Format:

```markdown
# Session Index

| Date | Checkpoint | Summary |
|------|------------|---------|
| 2026-03-06 04:30 | 2026-03-06-0430.md | Design complete, sprint plan generated, email drafts for Cheryl |
```

The summary column is ONE sentence. If `seshes.md` already exists, prepend the new entry. Do not rewrite existing entries.

---

## Rules
- The checkpoint must contain enough context for a fresh Claude Code session to continue seamlessly
- Be specific — include file paths, branch names, commit hashes, tool names
- Don't summarize what's already in CLAUDE.md — focus on session-specific progress and state
- After writing the checkpoint and updating seshes.md, commit both to git on the current branch
- The save MUST be non-blocking — user can keep talking while it runs
- Feedback and warnings MUST be collected from the user, not invented
- The prompt for next chat MUST be confirmed by the user before being written
