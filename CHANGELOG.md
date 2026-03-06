# Changelog

## v1.0.0 — 2025-10-10

Initial release for everyday use.

## v1.1.0 — 2026-03-06

Initial release from standalone repository.

- **save**: Non-blocking background checkpoint save with feedback collection
- **load**: Load checkpoint(s), check git state, present resume prompt with warnings
- **list**: Show session index or list available checkpoint files
- **help**: Usage instructions with version and author info
- Deploy script for copying skills to `~/.claude/commands/seshmem/`
- Versioned release snapshots in `releases/`
- Project documentation (README, CLAUDE.md, CHANGELOG)

### History

seshmem was originally created 2026-03-03 during the TMv2 (Telemanager) project and has been used across multiple projects including TMv2 and BF Claw. This release extracts it into its own repository with proper versioning and deployment.
