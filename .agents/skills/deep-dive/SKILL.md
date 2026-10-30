---
name: deep-dive
description: Protocol for deep dives and multi-source research when asked to analyze a topic thoroughly
allowed-tools: All tools
user-invocable: true
---

# Deep Dives and Multi-Source Analysis

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
