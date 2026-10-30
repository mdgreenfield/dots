---
name: session-summaries
description: Write end-of-session summaries to ~/ai-notes/code-session-notes and ingest them into the ~/knowledge-base wiki (catalog, project page, index, log, lint, commit)
allowed-tools: All tools
user-invocable: true
---

# Session Summaries

At the end of any substantial session, write a dated session summary and ingest it into the knowledge base, without being asked. Do this when:

- The user signals they're wrapping up ("thanks", "done", "that's all")
- Context compaction is triggered (write the summary before compacting)

Skip it for short exchanges that are just answering a quick question or looking something up. Only summarize sessions involving real work: code changes, architectural decisions, research findings, debugging, or planning.

Two stages, always both: (1) write the raw note, (2) ingest it into the wiki. The raw note is the source of truth; the wiki is a compiled view of it.

## Stage 1: Write the raw note

Location: `~/ai-notes/code-session-notes/session_YYYY-MM-DD_<slug>.md`. This is the same directory regardless of project or agent (omp or Claude Code). `~/knowledge-base/raw` is a symlink to `~/ai-notes`, so the knowledge base sees the note immediately.

- `YYYY-MM-DD` is the date the session started. `<slug>` is 2 to 4 kebab-case words for the main topic.
- If the session spans several days or is resumed later, keep the original filename, update the note in place, and add or bump a `Last updated: YYYY-MM-DD` line under the title. Never create a second note for the same session. Check for an existing note first: `ls ~/ai-notes/code-session-notes | grep <project-or-topic>`.
- Frontmatter:

```markdown
---
name: session_2026-09-12_seasonal-plan-and-site
description: One line, under 160 chars, stating what the session accomplished
project: meal-plan
repo: /Users/mdgreenfield/meal-plan
---
```

`project` is the repo directory name in kebab-case, and is the slug of the wiki page `wiki/projects/<project>.md`. Reuse the exact slug of an existing project page (`ls ~/knowledge-base/wiki/projects/`) rather than inventing a variant. For sessions not tied to one repo, pick a short descriptive slug and omit `repo`.

### What to include

- What was worked on
- Decisions made and why
- Key findings or outcomes
- Open threads or follow-up items

Include enough detail to pick up where the session left off. Preserve any data, tables, analysis results, commands with their output, or other artifacts produced during the session, not just a prose summary. A future session reading this note must be able to continue without redoing the research.

Never put secrets, tokens, passwords, or account numbers in the note.

## Stage 2: Ingest into the knowledge base

Immediately after writing or updating the raw note, follow the code-session ingest in `~/knowledge-base/AGENTS.md` (read it if you have not this session; it is the authority if it disagrees with this summary). Work in `~/knowledge-base`:

1. **Catalog.** In `wiki/sources/code-sessions.md`, add one bullet, or replace the existing bullet for this note when it is an update:
   `- [[session_YYYY-MM-DD_<slug>]] (tech-systems) 1 to 3 sentence summary with the concrete facts and decisions. Mentions: ... Feeds: [[<project>]], ...`
   The bullet must link the raw note by its basename (no `.md`).
2. **Project page.** Update `wiki/projects/<project>.md`, creating it if new (frontmatter per AGENTS.md, `type: project`, link it to a topic page such as `[[software-projects]]`). Keep it a current-state page, not a log: current state, decisions and why, open threads, commands that matter, and a `## Sessions` list linking each raw note. Cite the raw note inline with `[[session_...]]`. A later session that reverses an earlier decision: keep the old claim marked superseded with date and source.
3. **Entities and concepts.** If the session produced durable knowledge worth its own page (a tool, a rule, a recurring pattern) and it has substance or a second referrer, add or update `wiki/entities/` or `wiki/concepts/` pages and link them from the project page.
4. **Overview.** Edit `wiki/overview.md` only if the big picture moved.
5. **Regenerate and log.**
   - `python3 scripts/kb.py index`
   - Append to `wiki/log.md`: `## [YYYY-MM-DD] ingest | <note title>` plus one line listing pages touched (`update` instead of `ingest` when revising an existing note).
6. **Lint.** `python3 scripts/kb.py lint`. Fix every problem it reports in files you touched. A report about unrelated pending raw notes is not yours to fix, but mention it.
7. **Commit.** `git add -A && git commit -m "ingest: <slug>"` in `~/knowledge-base`. The repo has no remote. Do not push.

Keep the wiki edit proportionate: a short session touches a bullet and a few lines of the project page. Wiki rules that matter most: cite the raw note on every non-obvious claim, date anything that can go stale, never copy sensitive values.

## Legacy Claude memory sync

Claude Code sessions historically wrote to `~/.claude/projects/*/memory/session_*.md`. `scripts/sync-claude-notes.sh` mirrors any such notes into `~/ai-notes/code-session-notes` (a `Stop` hook runs it). It is safe to run repeatedly: a note is copied when new, refreshed when the source changed and the copy is untouched, and skipped when the copy was edited by hand. It does not ingest into the wiki. If it reports `synced:` or `updated:` lines, run Stage 2 for those notes. Prefer writing straight to `~/ai-notes/code-session-notes` (Stage 1) so the memory directory is not involved.
