# Agent Instructions

## Safety: No Destructive Actions Without Explicit Approval

**CRITICAL — applies in all modes including `--dangerously-skip-permissions`:**

Never take any write, update, or delete action against any environment,
dataset, or service without the user's explicit approval first. This is
a hard stop, not a default that context can override.

Specifically, you must NEVER (without explicit per-action approval):

- Make any mutating request to RMS or any Datadog internal API — via
  `ddtool`, `curl`, MCP tools, or any other mechanism. Read-only
  (`GET`/`describe`/`list`) requests are fine.
- Create, update, patch, delete, or restart any Kubernetes resource
  (deployments, pods, configmaps, secrets, CRDs, etc.) in any cluster.
- Trigger, promote, pause, cancel, or roll back any deployment or
  release pipeline (Conductor, GitLab CI, GitHub Actions, etc.).
- Drop, truncate, or modify any database, index, or persistent store.
- Send messages, post comments, or take actions visible to others
  (Slack, GitHub issues/PRs, Jira, etc.) beyond what the user has
  already explicitly requested in the current turn.

When in doubt, stop and ask. The cost of one confirmation is always
lower than the cost of an unintended change to a live system.

## Repository Locations

Most work repositories live under `~/dd`. Exceptions:
- `~/dots` — personal dotfiles (ad-hoc, not a work repo)
- Repos cloned for upstream contribution (typically in `~/` or a
  separate directory, not `~/dd`)

When searching for a repo or navigating to one by name, default to
looking under `~/dd` first.

- `~/knowledge-base` — LLM-maintained wiki of work context (its own
  AGENTS.md governs ingest/query/lint there; never modify `raw/`;
  never push or copy its contents to any remote or external service)

## GitHub

When interacting with GitHub (github.com), ALWAYS use `gh` on the command line.

If `gh` returns a 401 error, re-authenticate with:

```bash
gh auth login
```

For branch naming, commit hygiene, commit message format, and PR
format, use the `git-workflow` skill.

## Shell Heredocs

In single-quoted heredocs (`<<'EOF'`), the shell treats all content literally.
Do NOT escape backticks or `$` — write them as-is:

```bash
gh pr edit 123 --body "$(cat <<'EOF'
Use `SomeFunc` to call `OtherFunc` with `$variable`.
EOF
)"
```

This applies to commit messages and any other text passed via heredoc.

## File Editing

Always use the agent's file editing tools (`Edit`/`Write`, lowercase
`edit`/`write` in some agents). Never use Python scripts, sed, or awk
for file editing.


## Code Style

Write code that is concise and easy for a reviewer to follow. Code
should speak for itself — do not litter it with comments explaining
what the code does. Reserve comments for:

- Complex logic that isn't immediately obvious
- Caveats, gotchas, or non-obvious constraints
- Conditions or side effects that callers need to be aware of


## Research and Analysis

Always search the Datadog Confluence wiki before attempting to search the
web. If more context or information is needed to do a task well, ask
additional questions until the task can be done effectively and with high
quality.

When asked to do a deep dive or analysis on a topic:

- Dispatch multiple subagents in parallel to fetch content from external
  sources rather than querying them sequentially. Use one subagent per
  source or workstream so fetches overlap.
- Before drawing conclusions, verify you have a complete picture. Cross-check
  findings across sources, identify gaps, and follow up on anything ambiguous
  or contradictory before reporting back.
- Do not summarize prematurely. Incomplete research that misses key context
  is worse than taking more time to be thorough.
- Once research is complete, ask any clarifying questions before forming
  conclusions. Do not jump to recommendations if there are open questions
  that would materially affect the answer.

## Helper Scripts

Always use Go when writing temporary or helper scripts. Any repeated
testing, API calls, or CLI invocations should be turned into a repeatable
Go program. Do not use Python for this. (The `edit`/`write` file tools and
shell builtins are unaffected; this rule is about program scripts.)

## Git Safety Rails

- Never commit directly to main or master, and never push directly to
  main or master.
- Create new branches from the latest changes on the remote default
  branch (usually `main`), unless directed otherwise.
- Set new branches to track their origin counterpart:
  `git push origin <branch>:<branch>`.
- Rebase onto the latest changes on main before pushing new commits.
- Each agent doing concurrent work should use an isolated worktree of the
  local repo clone to avoid conflicts between agents.

## Status Updates

When asked for status on in-flight work, lead with a table of open PRs
from the current work, one row per PR: dependent PRs first in the order
they must merge, independent ones after. Columns:

`| PR | What | Review | Blocker / next step |`

Keep it narrow:

- PR: markdown link with repo name, e.g. [piper#120](url)
- Review: draft or ready, plus unresolved thread count, e.g. `draft, 2 unresolved`
- Blocker / next step: who acts next and what they do, including failing
  or pending CI when that is what blocks; "ready to merge" when nothing
  is left

Query live PR state (`gh`) before building the table; never report from
memory. After the table: anything the user needs to do that isn't a PR
row, then what background agents are doing, a line each.

## Living Repo Docs

Create a `CLAUDE.md` in any repository we work together on, if there isn't
one already. Add and update directory-specific `CLAUDE.md` files with
relevant context as part of completing a task, focusing on high-level and
strategic goals and key constraints, so future work can learn from the
past. `CLAUDE.md` is the right place for rules that must always apply; do
not move its content into memories.

## Debugging

Always try Datadog MCPs for org2 or ddstaging to get logs and operational
telemetry before using tools like `kubectl`. A good way to illustrate
problems is by creating a Datadog notebook with widgets or logs that show
the issue and sharing the hyperlink.



## Writing Style

When drafting any content on the user's behalf — Jira tickets, PR
descriptions, code comments, Slack messages, or any other authored text —
follow these conventions:

- **Tone:** polite and respectful, concise and direct, written as an
  engineer would write it (precise and clear, no filler or fluff)
- **Punctuation:** no dashes, em dashes, or semicolons; avoid colons
  except when introducing an enumerated list
- **Spelling:** "datacenter" (one word), not "data center"
