# Agent Instructions

## Repository Locations

Most work repositories live under `~/dd`. Exceptions:
- `~/dots` — personal dotfiles (ad-hoc, not a work repo)
- Repos cloned for upstream contribution (typically in `~/` or a
  separate directory, not `~/dd`)

When searching for a repo or navigating to one by name, default to
looking under `~/dd` first.

## GitHub

When interacting with GitHub (github.com), ALWAYS use `gh` on the command line.

If `gh` returns a 401 error, authenticate with:

```bash
export GITHUB_TOKEN=$(ddtool auth github token)
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

## Git Branches

Always name branches using the format `mdgreenfield/<name_of_feature_or_jira_ticket_number>`.

Examples:
- `mdgreenfield/JIRA-1234`
- `mdgreenfield/add-rate-limit-metrics`

## Git Commit Messages / GitHub Pull Requests

Commit messages and pull request descriptions should be clear and
concise and not just restate what the code does. The subject line
should summarize the change in plain language so a reviewer can
understand it at a glance without reading the diff.

When creating or editing a pull request description, always follow this template:

**Title**
- Format: `<Jira project key>: <short summary>` (less than 50 characters)
- Example: `JIRA-1234: add rate limit metrics to ingestion path`

**Body:**

More detailed explanatory text, *if necessary*. Wrap it to about 72
characters or so. In some contexts, the first line is treated as the
subject of the commit and the rest of the text as the body. The
blank line separating the summary from the body is critical (unless
you omit the body entirely); various tools like `log`, `shortlog`
and `rebase` can get confused if you run the two together.

Explain the problem that this commit is solving. Focus on why you
are making this change as opposed to how (the code explains that).
Are there side effects or other unintuitive consequences of this
change? Here's the place to explain them.

Further paragraphs come after blank lines.

 - Bullet points are okay, too

 - Typically a hyphen or asterisk is used for the bullet, preceded
   by a single space, with blank lines in between, but conventions
   vary here

- Keep tone concise and professional, no emojis.
- The JIRA ticket number can usually be found in the git branch `mdgreenfield/JIRA-1234`.
- If no JIRA ticket number can be determined, default to `PPLAT-NR`.
- Prefer American English.
- If I say "write a PR message" or "open a PR for this branch", use this format.
- Separate subject from body with a blank line
- Limit the subject line to 50 characters
- Capitalize the subject line
- Do not end the subject line with a period
- Use the imperative mood in the subject line
- Wrap the body at 72 characters
- Use the body to explain what and why vs. how
