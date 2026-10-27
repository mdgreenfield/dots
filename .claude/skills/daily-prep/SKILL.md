---
name: daily-prep
description: Morning/evening readiness brief — calendar (flagging non-recurring meetings), Jira (new comments from others on my issues), Slack (identity-core team/incidents), and Gmail triage (surface important, archive the routine). Safe to re-run; archives only once per message.
allowed-tools: All tools
user-invocable: true
---

# Daily Prep

End-to-end readiness brief. You are the orchestrator: gather raw data with cheap subagents, then triage/synthesize yourself. Run the collector first (calendar, Slack, Jira — read-only), email triage second (it mutates Gmail, only when `--archive` given).

## Invocation

- `daily prep` / `daily-prep` — brief only, no email mutation.
- `daily-prep --archive` — also archive triaged noise. Archive runs AFTER the collector (a GMail label update can't race a channel read; Jira/Slack can't see mail labels — ordering is purely about presenting a final, settled inbox state in the brief).
- Morning run (before ~noon local): brief covers today + tomorrow. Evening run: today + tomorrow + this week's horizon.
- Re-running is safe. Only the `--archive` step mutates anything, and its dedupe marker makes archiving idempotent per message.

## Phase 1 — Gather (subagent, read-only)

Spawn `daily-prep-gatherer` (cheap GLM 5.3 — see Model note). **Sanity-check your own epoch anchor** — verify `date +%s` locally via bash if possible; if the epoch you pass disagrees with live Slack timestamps, the gatherer will self-correct from live data (and note it):

```
task(context: <skill-file://daily-prep context block below>, tasks: [{
  name: "DailyPrepGather", agent: "daily-prep-gatherer",
  task: "Collect today's raw daily-prep data. Local date: <YYYY-MM-DD>. Local time: <HH:MM> (<TZ>, UTC offset <+/-HH:MM>). Now epoch seconds: <N>. Return: gather.md (markdown with sections Calendar / Jira / Slack), plus JSON code block on the LAST line: {\"calendar\": [...], \"jira_updated_issues\": [...], \"jira_other_comments\": [...], \"slack\": [...]}.",
  solutionSpace: "data collection, all queries and sources specified; no design choices"
}])
```

The collector instructions are in its agent file; you only pass the date/time anchor. Tool docs to consult if a call shape surprises you: `xd://mcp__google_calendar_list_events`, `xd://mcp__atlassian_searchjiraissuesusingjql`, `xd://mcp__slack_read_channel`.

### Collector spec (for your reference; normative text lives in the agent file)

**Calendar** (`google_calendar_list_events`, `time_min` = local midnight, `time_max` = +36h) — auto-filter (do NOT list, do NOT archive/skip these, they are not meetings):
- `responseStatus: "declined"` on the user's own attendance.
- Personal placeholder blocks: `Home`, `Lunch`, `Bus`, `Commute`, `Focus`, `Gym`, `Family`, `Personal`, `BUSY - Daycare*`.
- If an event's `recurringEventId` ends in `_R<digits>...`, it's a recurrence instance; if not (e.g. Nook, Philip/Matt, Paul/Matt), it's a standalone occurrence — **flag these as non-recurring (NEW to your radar)**. Recurring 1:1s ("X / Matt") do not get flagged as new.

**Jira** (`searchJiraIssuesUsingJql`, cloudId `datadoghq.atlassian.net`, fields `["summary","status","updated","comment"]`, `maxResults: 25`):
1. `assignee = currentUser() AND updated >= -2d ORDER BY updated DESC` — issues I own.
2. `reporter = currentUser() AND resolution = Unresolved ORDER BY updated DESC` — my open reports.
3. Fetch comments on all result issues. **NEVER use JQL `commented()` or `comment.created` — they silently return empty/wrong on this instance.** Filter client-side: comments newer than the cutoff whose `author` is not `matt.greenfield` and whose accountId is not `5c1811b070df011836b05698`. Fall back to `updated` if a comment has no timestamp.

**Slack** (`slack_read_channel`, pages of 100 with `oldest` bound; use `slack_search_public` for incident search):
| Channel | ID |
|---|---|
| #identity-core-team | `C0BB2NJNM6U` |
| #identity-core | `C0BA23JDJBD` |
- Page from `oldest` (local midnight) to now. Dedupe threads by `ts`. Open threads with >3 messages via `slack_read_thread` — thread replies are NOT in the channel page.

**Output** — `gather.md` sections `## Calendar`, `## Jira`, `## Slack`, each with a trailing JSON block. For calendar include `id|summary|start|attendees|recurring?|declined?` per event; for Jira include `key|summary|updated` plus any non-me comments; for Slack include `channel|ts|user|text[:120]` plus thread-notice lines.

## Phase 2 — Email triage (subagent, mutates mail only with `--archive`)

Spawn `daily-prep-triage` (cheap GLM 5.3 — see Model note) **only if `--archive`**; otherwise read-only pass yourself, or skip if the user only wants the brief. Pass cutoff epoch = local midnight (morning) or now minus 18h (evening).

**Classifier in `scripts/triage` is deterministic and fast** — always run it FIRST, then apply subagent judgment on top (adds anything it missed; removes nothing without its own reason). The classifier never mutates mail; the subagent does (and only when `--archive`).

### Auto-archive rules (static classifier in `scripts/triage`)

**SAFE (archive unconditionally):**
- Jira notifications (from `*.atlassian.net` / Label_8128105015673056202)
- GitHub notifications (from `notifications@github.com` / label `gh-*`)
- Conductor/Conductor-workflow notifications
- Opsgenie/PagerDuty weekly or digest reports (NOT single-incident pages — those go to "review")
- Datadog product marketing / webinar / newsletter / customer-stories (datadoghq.com marketing senders)
- Datadog Synthetics monitor status "is no longer monitored" / resolved-and-recovered notices

**REVIEW (keep in inbox, summarize in brief):**
- Jira comments/mentions directed at the user (`@Matt Greenfield`, `assigned to you`)
- GitHub review requests, direct mentions, PR comments, security advisories
- PagerDuty/Opsgenie incident pages (single, non-digest)
- Anything from a human (personal-mail domain, or datadoghq.com non-bot addresses)
- Bills, travel confirmations, benefits/ESPP deadline reminders

**NOISE-DENYLIST (NEVER archive these):** anything starred (label STARRED), anything with user labels in {Benefits, compensation, espp, ipo, travel, Datadog Case, workday, Helpdesk, postmortem, Infra Leads}, or anything from `matt.greenfield@datadoghq.com` (own mail).

### Archive mechanics (subagent, `--archive` only)

For each message classified SAFE that is also INBOX:
- `gmail_modify_message_labels` with `remove_labels: ["INBOX"]`, `confirmed: true` (false only for the preview pass)
- If the message is unread, also `remove_labels: ["UNREAD"]` so it reads as "handled"
- Record: sender, subject, snippet, message id, and the reason category
- Output an archive log: `Archived N messages (list)` — surfaced verbatim in the brief.

Never archive anything not classified SAFE. Unclassified → REVIEW (inbox). When in doubt, leave in inbox.

### Dedupe: never archive the same message twice

Before archiving, the subagent checks the marker file `~/.local/share/daily-prep/archived-log.jsonl` (created by `scripts/triage` on first archive): if a `message_id` already appears, skip and do NOT count it in the archive log again. Append newly-archived ids to the same file (the subagent runs it after archiving with `--record <id>` per id).

## Phase 3 — Brief

You (the orchestrator) write the final brief directly in chat. Structure:

```markdown
# Daily Prep — <Day>, <Mon DD> <HH:MM>

## Meetings (calendar)
- 9:30a  Matt / Ben 1:1 (recurring) — [zoom link]
- 11:00a **Nook (NEW — not recurring)** — identity-core mtg with Scott
- ⚠️ 2 events flagged as NEW (not from a recurring series): <names>

## Jira — comments from others on my issues (last 24h)
- IDCORE-3348 (Needs Triage): comment from <name>: "<one-line gist>" → <link>
- (or) No new comments from others in the last 24h.

## Slack
### #identity-core-team
- <most important 3-5, others as one-line summaries>
### #identity-core (support channel)
- <only items needing team action>

## Email
- Reviewed N inbox messages. Archived K (see log). R flagged for review:
  - <sender>: <subject> — <one-line why>

## Watch list
- <us2.fed.dog cert TTL, vault CVE timeline, etc. — carry-forward from recent sessions/notes if present>
```

## Data sources quick reference

| Source | Tool | Notes |
|---|---|---|
| Calendar | `google_calendar_list_events` | `time_min` = local midnight, `time_max` = +36h; `recurringEventId` null = standalone/new |
| Jira | `searchJiraIssuesUsingJql` | cloudId `datadoghq.atlassian.net`; NEVER `commented()` / `comment.created` (silently empty); fetch comments, filter client-side |
| Slack | `slack_read_channel` | pages of 100, `oldest` bound; threads via `slack_read_thread`; incident search via `slack_search_public` with `after:` bound |
| Gmail | `search_messages` / `get_message` | `label_ids: ["INBOX"]` only; `get_message` format `metadata` for header-only passes, `full` when the body matters |
| Gmail archive | `modify_message_labels` | `remove_labels: ["INBOX"]`, `confirmed: true`; unread → also drop `UNREAD` |

## Hard rules

- NEVER silently skip a category. Missing data (auth error, empty result) is reported as "(none)" or "(error: <reason>)", never dropped from the brief.
- NEVER archive outside `--archive` mode.
- NEVER use Jira JQL `commented()` or `comment.created` (silently wrong on datadoghq.atlassian.net) — fetch comments and filter client-side.
- NEVER flag a declined calendar event as a meeting to attend; list under "Not attending (declined)" if worth noticing (e.g. a recurring meeting you declined this instance).
- Never trust the orchestrator-computed epoch anchor blindly: the gatherer cross-checks it against live Slack timestamps and recomputes cutoffs if they disagree (this bit us once — a bad anchor produced Dec-26 cutoffs).
- NEVER archive mail that is starred, in a protected label, or from the user themself.
- Subagent outputs that contradict the collector spec (e.g. missing JSON tail, missing channel) are re-run with a pointer at the missing piece before you synthesize.
- All times shown in the brief are the user's local timezone (America/Denver).
- Cost guardrail: collector and triage agents are GLM 5.3 (Baseten) — never let them silently run on the session default (Opus). If the agent file is missing/unavailable, run the collection yourself with the same spec rather than substituting an expensive model.

## Model note

Model is enforced in `~/.omp/agent/agents/daily-prep-gatherer.md` and `~/.omp/agent/agents/daily-prep-triage.md` (`model:` + `thinking-level:` frontmatter, same mechanism as `the-nerds`). Dispatch by agent name via `task`; never override `model` on the task call (per-item `model` is seance-only). If a requested model is unavailable, fail loudly and fall back to the platform default.

## Related files

- Agent definitions: `~/.omp/agent/agents/daily-prep-gatherer.md`, `~/.omp/agent/agents/daily-prep-triage.md`
- Triage classifier: `scripts/triage` in this skill directory
- Archive dedupe log: `~/.local/share/daily-prep/archived-log.jsonl`
- Recurring Slack channel IDs and incident-search recipe: `~/notes/sessions/session_2026-10-26_slack-channel-digests_identity-core-team.md`
