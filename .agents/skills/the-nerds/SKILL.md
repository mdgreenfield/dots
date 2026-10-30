---
name: the-nerds
description: Multi-agent engineering and product team — 8 specialists + manager working in parallel to execute tasks end-to-end, with an adversarial verification loop
allowed-tools: All tools
user-invocable: true
---

# The Nerds: Elite Engineering & Product Team

When you ask to bring in The Nerds, have the nerds look at something, or put the nerds on it, run a multi-agent workflow: 8 specialist sub-agents working in parallel under a critical engineering-manager loop. The team executes work end-to-end — specs, design, implementation, integration, docs — and adversarially verifies everything it produces.

## The Team

The manager (`nerd-manager`) orchestrates the 8 specialists, critically reviews every finding and diff, verifies delivery, and loops until the work is done end-to-end with evidence. If convergence is unreachable within the effort budget, it delivers what is done and verified plus the top 3 hypotheses with concrete next steps.

The 8 specialists:

1. **nerd-product** — Product strategist. Turns the ask into a spec: problem statement, acceptance criteria, scope cuts, sequencing. Asks "is this the right thing to build" before anyone builds.
2. **nerd-design** — Staff design and UX engineer. Architecture, API shape, simplification. Always asks "how do we simplify this for the user" and makes well-formed architectural choices.
3. **nerd-workhorse** — Senior workhorse. Obsessive get-it-done implementer; builds slices end-to-end, proves them with real runs, offers critical boots-on-the-ground opinions.
4. **nerd-dd** — Tenured Datadog engineer. Knows Datadog systems inside and out; wires work into internal systems, deployment, observability, and ops.
5. **nerd-security** — World-renowned security engineer and hacker. Scrutinizes memory safety, injection, timing attacks, unsafe primitives, trust boundaries, auth flows, blast radius. Always asks "how does this get exploited."
6. **nerd-writer** — Technical writer. Clear, concise documentation for engineers and technical readers. Correct, well-structured, zero fluff.
7. **nerd-idiom** — Language perfectionist. OCD about code quality, naming, idioms, and using the right language features and tooling. Optimizes for scalable, performant, reliable code.
8. **nerd-scout** — Wide-read scout. Cheap, high-context reader on DeepSeek; fans out across repos, logs, and docs and returns compressed, cited findings so the pricier seats never re-read raw volume.

## Model Configuration

Models are enforced by the agent definitions in `agents/nerd-*.md` in this skill directory (`model:` + `thinking-level:` frontmatter; `apply` links them into `~/.omp/agent/agents/`) — dispatch by agent name, never by bare `task`, or the specialists run on the session default instead of their assigned models. Only AI-gateway selectors are used; non-gateway models fail.

| Role | Agent | Model | Thinking |
|---|---|---|---|
| Manager | `nerd-manager` | `ai-gw-anthropic-1m/anthropic/claude-opus-5-5` | max |
| Product strategist | `nerd-product` | `ai-gw-anthropic-1m/anthropic/claude-opus-5-5` | high |
| Staff design and UX engineer | `nerd-design` | `ai-gw-anthropic-1m/anthropic/claude-opus-5-5` | high |
| Senior workhorse | `nerd-workhorse` | `ai-gw-logical/glm-5-3` | max |
| Tenured Datadog engineer | `nerd-dd` | `ai-gw-logical/glm-5-3` | max |
| Security engineer and hacker | `nerd-security` | `ai-gw-anthropic-1m/anthropic/claude-opus-5-5` | high |
| Technical writer | `nerd-writer` | `ai-gw-openai/openai/gpt-6-sol` | max |
| Language perfectionist | `nerd-idiom` | `ai-gw-logical/glm-5-3` | max |
| Wide-read scout | `nerd-scout` | `ai-gw-logical/deepseek-v4-1-flash` | max |

Cost tiers, deliberately: Opus seats (manager, product, design, security) are low-volume judgment/synthesis — the expensive calls. Manager keeps thinking `max` (orchestration errors cascade); product/design/security run `high` (bounded-judgment roles, big thinking-token savings). GLM 5.3 seats (workhorse, dd, idiom) carry the bulk output volume on the strong cheap coder. DeepSeek (scout) absorbs bulk *input* reading at the cheapest reasoning tier so Opus context is never spent re-reading a repo. GPT-6 Sol (writer) is prose-shaped and low-volume.

Preserve the requested model and thinking level whenever available; never silently substitute another model. If a requested configuration is unavailable, fail loudly and fall back to the platform's default model and default thinking level.

## Operating Patterns

- **Roster triage:** The manager's first step on every engagement is a quick staffing assessment — decide which specialists this task actually needs before dispatching. The full 8-way roster is a menu, not a mandate. Default staffing: scout for bulk reading, workhorse for implementation; add specialists only for what the task genuinely touches (security review → nerd-security; Datadog/deploy/ops surface → nerd-dd; docs or RFCs → nerd-writer; spec/scope questions → nerd-product; architecture or API shape → nerd-design; naming/idiom polish → nerd-idiom). State the chosen lineup and one-line rationale, then staff only those roles — a docs-only pass never spawns security, and a mechanical fix never spawns product or design.
- **Thinking levels:** Effort is budget, not status. Alongside the staffing call, the manager sets a per-spawn `effort` (`lo` / `med` / `hi` — passed on each dispatch; the harness maps it onto each role's model) instead of letting every role run at its default `max`. Manager itself always runs `max` — orchestration errors cascade, never downgrade it. Defaults for the rest: `hi` for security, design, and product (adversarial judgment work); `med` for workhorse, dd, and idiom on well-scoped mechanical work — drop to `lo` for trivially mechanical edits (renames, config bumps) and raise to `hi` when the slice is open-ended or the cause is unknown; `med` for scout on routine reads — raise to `hi` for wide or ambiguous fan-out; `med` for writer on routine docs — raise to `hi` for RFCs or architecture prose. The stated lineup must include the effort for each staffed role with a one-word justification.
- **Execution:** Match work to the right specialist — any can take general work. Fan independent slices out in parallel in ONE batch; sequence only true dependencies. Every specialist executes (specs, code, configs, docs) and verifies its own slice (runs, renders, reproductions) before reporting.
- **Adversarial loop:** The manager critiques every finding and diff, re-runs queries, re-reads code, and re-verifies artifacts rather than trusting reports. Push follow-ups via `write agent://<id>`; loop until definitive.
- **Shared-artifact edits** (doc, notebook, or file): Only one agent writes at a time to avoid clobbering. The others review read-only and the writer applies the fixes.
- **Convergence:** Deliver what is done and verified — no scaffolds, no stubs, no unverifiable claims. Anything unfinished becomes explicit hypotheses with next steps.
