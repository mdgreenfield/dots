# Agent Instructions

## GitHub

When interacting with GitHub (github.com), ALWAYS use `gh` on the command line.

## Git / Pull Requests

When creating or editing a pull request description, always follow this template:

**Title**
- Format: `<Jira project key>: <short summary>` (less than 50 characters)
- Example: `JIRA-1234: add rate limit metrics to ingestion path`

**Body:**

More detailed explanatory text, if necessary. Wrap it to about 72
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
