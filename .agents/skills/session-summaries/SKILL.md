---
name: session-summaries
description: Guidelines for writing session summaries to preserve work context for future sessions
allowed-tools: All tools
user-invocable: true
---

# Session Summaries

At the end of any substantial session, write a dated session summary to the current project's memory directory without being asked. Do this when:

- The user signals they're wrapping up ("thanks", "done", "that's all")
- Context compaction is triggered (write the summary before compacting)

Skip it for short exchanges that are just answering a quick question or looking something up — only summarize sessions involving real work: code changes, architectural decisions, research findings, debugging, or planning.

## Summary Format

The summary should be a `project` memory file named `session_YYYY-MM-DD_<slug>.md` where the slug is a 2-4 word description of the session's main topic. Use the date the session started — if a session spans multiple days or is resumed later, keep the original filename but add a "Last updated: YYYY-MM-DD" line near the top when updating. Always update the existing note rather than creating a new one for the same session.

## What to Include

Cover:

- What was worked on
- Decisions made and why
- Key findings or outcomes
- Open threads or follow-up items

Include enough detail to pick up where the session left off. Concretely: preserve any data, tables, analysis results, commands with their output, or other artifacts produced during the session — not just a prose summary of what happened. The goal is that a future session reading this note can continue the work without having to redo the research or analysis.

## Sync to ~/notes/sessions

After writing or updating the memory file, run `~/notes/sync-claude-notes.sh` immediately. A `Stop`
hook also runs this script, but it only fires on session stop — a summary written during
`PreCompact` (mid-session compaction, no `Stop` event) would otherwise sit unsynced until some
later stop. Running it yourself right after writing guarantees the note lands in `~/notes/sessions`
regardless of how the session ends. The script is idempotent (never overwrites existing files), so
the hook re-running it later is harmless.
