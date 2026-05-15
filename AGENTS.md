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

## Go Style

Always prefer functions from the Go standard library over implementing
equivalent functionality ourselves. Before writing custom logic, check
whether the stdlib already provides it.

## Go Modules (Datadog Internal)

`go.ddbuild.io` modules are served from Datadog internal infrastructure and
require VPN to download. If `go get` or `go mod download` times out, check VPN
connectivity first.

Workaround when offline: add a temporary `replace` directive in `go.mod`
pointing to a locally-cached version in `~/go/pkg/mod`. **Revert before
committing.**

## Testing

Tests are a priority for any fix or new functionality. Write tests
first where possible (TDD). If adding tests requires test-only hooks
or seams in production code, first try to refactor the code to make
it naturally testable. Only skip tests in rare cases where no
reasonable refactor can avoid test-only hooks.

All applicable tests must be run and pass before committing. Check
for a Makefile and run all relevant targets (e.g. `make test`). If a
linter is available, run it too (e.g. `make lint`) and resolve any
issues before committing. Make targets can be run in parallel.

This applies to every commit without exception — including trivial
changes like `go mod tidy`, dependency updates, or import reordering.
Skipping fmt/lint/test for "minor" changes is not acceptable.

In Go tests, prefer `t.Context()` over `context.Background()`. Note
that removing `context.Background()` calls does not necessarily make
the `context` import unused — method signatures may still reference
`context.Context`.

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

## Git Workflow

### Branches

Always name branches using the format `mdgreenfield/<name_of_feature_or_jira_ticket_number>`.

Examples:
- `mdgreenfield/JIRA-1234`
- `mdgreenfield/add-rate-limit-metrics`

### Commit Hygiene

Before pushing or opening a PR, review the commit history and tidy it up:

- **Squash iterative commits** — fix-ups, typo corrections, "address
  review feedback", and other small iterations on the same logical change
  should be squashed into the commit they belong to. The goal is a history
  that reads as if the work was done right the first time.
- **Keep logical units separate** — distinct concerns (e.g. a refactor
  and a bug fix, or two independent features) should remain as separate
  commits. Don't over-squash.
- **Reorder when it improves readability** — if commits are out of logical
  order, reorder them so the history tells a coherent story.

Always `push --force-with-lease` after rewriting history.

**Splitting a commit:** `git add -p` requires a TTY and does not work in
this environment. To split a commit:

1. `git reset --soft <base>` — collapse commits back to working tree, staged
2. `git restore --staged <file>` — unstage the file to split
3. Edit the file to contain only the first commit's changes
4. `git add <file>` + `git commit`
5. Edit the file to add the second commit's changes
6. `git add <file>` + `git commit`
7. `git push --force-with-lease`

### Commit Messages

- Separate subject from body with a blank line
- Limit the subject line to 50 characters; capitalize it; no trailing period
- Use the imperative mood in the subject line
- Wrap the body at 72 characters
- Explain what and why, not how
- Keep tone concise and professional, no emojis; prefer American English
- Never attribute a change to a reviewer (e.g. "address X's feedback",
  "per code review"). Write as if the improvement was independently
  discovered — describe what changed and why it's better.

### Pull Requests

When creating or editing a PR, use this format:

**Title:** `<Jira project key>: <short summary>` (50 characters or less)
- Example: `JIRA-1234: add rate limit metrics to ingestion path`
- The Jira ticket number is usually in the branch name. If none, use `PPLAT-NR`.

**Body:** Explain the problem being solved and why this approach was
taken. Cover side effects and non-obvious consequences. Bullet points
are fine. Wrap at 72 characters.

- Never mention test or lint status — GitHub status checks handle that.
- Never attribute changes to a reviewer.
- After any substantive change to the branch (new commits, squashes,
  rebases), verify the PR description is still accurate and update it
  with `gh pr edit` if needed. Never leave a description that
  contradicts or omits what the branch actually does.
