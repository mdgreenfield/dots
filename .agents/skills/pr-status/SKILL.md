---
name: pr-status
description: Format for status updates on in-flight work; PR table with review state and blockers
allowed-tools: All tools
user-invocable: true
---

# Status Updates

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
