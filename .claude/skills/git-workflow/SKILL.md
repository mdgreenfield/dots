---
name: git-workflow
description: Branch naming, commit hygiene, commit message format, and PR format for this user's repos
allowed-tools: All tools
user-invocable: true
---

# Git Workflow

## Branches

Always name branches using the format `mdgreenfield/<name_of_feature_or_jira_ticket_number>`.

Examples:
- `mdgreenfield/JIRA-1234`
- `mdgreenfield/add-rate-limit-metrics`

## Commit Hygiene

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

## Commit Messages

- Separate subject from body with a blank line
- Limit the subject line to 50 characters; capitalize it; no trailing period
- Use the imperative mood in the subject line
- Wrap the body at 72 characters
- Explain what and why, not how
- Keep tone concise and professional, no emojis; prefer American English
- Never attribute a change to a reviewer (e.g. "address X's feedback",
  "per code review"). Write as if the improvement was independently
  discovered — describe what changed and why it's better.

## Pull Requests

When creating or editing a PR, use this format:

**Title:** `<Jira project key>: <short summary>` (50 characters or less)
- Example: `JIRA-1234: add rate limit metrics to ingestion path`
- The Jira ticket number is usually in the branch name. If none, use `IDCORE-NR`.

**Body:** Explain the problem being solved and why this approach was
taken. Cover side effects and non-obvious consequences. Bullet points
are fine. Wrap at 72 characters.

- Never mention test or lint status — GitHub status checks handle that.
- Never attribute changes to a reviewer.
- After any substantive change to the branch (new commits, squashes,
  rebases), verify the PR description is still accurate and update it
  with `gh pr edit` if needed. Never leave a description that
  contradicts or omits what the branch actually does.
