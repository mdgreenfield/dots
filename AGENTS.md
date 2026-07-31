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

Always use the `Edit` or `Write` tools to modify files. Never use Python
scripts, sed, or awk for file editing.


## Code Style

Write code that is concise and easy for a reviewer to follow. Code
should speak for itself — do not litter it with comments explaining
what the code does. Reserve comments for:

- Complex logic that isn't immediately obvious
- Caveats, gotchas, or non-obvious constraints
- Conditions or side effects that callers need to be aware of


## Research and Analysis

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



## Writing Style

When drafting any content on the user's behalf — Jira tickets, PR
descriptions, code comments, Slack messages, or any other authored text —
follow these conventions:

- **Tone:** polite and respectful, concise and direct, written as an
  engineer would write it (precise and clear, no filler or fluff)
- **Punctuation:** no dashes, em dashes, or semicolons; avoid colons
  except when introducing an enumerated list
- **Spelling:** "datacenter" (one word), not "data center"
