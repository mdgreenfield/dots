---
name: improve-skills
description: Reflect on your recent experience and improve the skills and CLI tools in the current repo. Create new tools when needed. Use after completing a task involving scripts, skills, or repetitive workflows.
allowed-tools: Bash, Read, Write, Edit, Grep, Glob, Task
user-invocable: true
---

# Improve Skills and CLI Tools Based on Your Experience

Reflect on what you just did and make the tools and skills better.

You just spent time working with skills, CLI tools, and scripts in this repo. Now step back and make them better—both the skills that guide you and the tools that do the work.

## Your Scope: This Repo

First, identify the repo you're working in:

```bash
# Get repo root and name
git rev-parse --show-toplevel
basename "$(git rev-parse --show-toplevel)"
```

Focus on improving:
- Skills in this repo (`.claude/skills/` and `skills/` directories)
- CLI tools in this repo (`dev/`, `scripts/`, and skill `scripts/` directories)
- Documentation files like `CLAUDE.md` and `AGENTS.md`

## Your Full Authority

**You are empowered to:**
- Improve any SKILL.md document in this repo
- Improve any CLI tool or script in this repo
- Create entirely new CLI tools when you spot a gap
- Refactor tools to be more composable
- Delete or deprecate tools that are redundant

**Don't ask permission.** If something could be better, make it better. If a tool should exist but doesn't, create it.

## Step 1: Reflect on What You Just Used

Think back to the skill or CLI tool you were just working with. You have fresh context from this session:

- What skill(s) did you invoke or follow?
- What CLI tools or scripts did you run?
- What commands did you repeat with variations?
- What workflows felt clunky?

### List Skills and Tools in This Repo

```bash
# List all skills in this repo
find . -name "SKILL.md" -type f 2>/dev/null

# List CLI tools in common locations
ls -la dev/ .claude/skills/*/scripts/ skills/*/scripts/ 2>/dev/null || true
```

## Step 2: Reflect on Your Experience

### What slowed you down?
- Where did you hesitate or get confused?
- What error messages didn't help?
- What did you have to look up?

### What wasted tokens?
- Verbose outputs you didn't need
- Documentation you had to wade through
- Large responses that could have been summaries

### What was missing?
- Manual steps that should be automated
- A tool that should exist but doesn't
- Information you needed but had to hunt for

### What was confusing?
- Flag names that didn't make sense
- Surprising default values
- Overly complex workflows

## Step 3: Make Improvements

### Improving Skills (SKILL.md)

**Put agents first:**
- Quick Start section at the very top
- Copy-paste ready code blocks
- Most common workflow in under 10 lines

**Be ruthlessly concise:**
- One sentence per concept
- Tables over paragraphs
- No fluff ("simply", "just", "easily")
- Link instead of duplicate

**Structure for skimming:**
- Clear headings
- Bullet points
- Working examples

**Before:**
```markdown
## Overview

This skill helps you test the trace investigation flow. The trace
investigation flow is used to analyze APM traces...
```

**After:**
```markdown
## Quick Start

\```bash
./test-investigator --hotdog <name> --fresh <trace_id> <span_id>
\```

Outputs a UI link on success. Use `--delegate` for CMD agent mode.
```

### Improving Existing CLI Tools

**Self-documenting:**
- `--help` in 10 lines or less
- Error messages that say what to do next
- Success output in one line

**Token-efficient:**
- Minimal default output
- Verbose mode opt-in (`--verbose`)
- Don't echo inputs back

**Robust:**
- Sensible defaults
- Auto-detect context (directory, git branch)
- Fail fast with clear messages

**Composable:**
- JSON for complex output, simple text for simple results
- Meaningful exit codes
- Support piping

**Before:**
```
Successfully created investigation with ID abc-123.
The investigation is now running. To view it, visit: https://...
```

**After:**
```
Created: abc-123 → https://dd.datad0g.com/...
```

### Creating New CLI Tools

If you find yourself doing something repeatedly that has no tool, **create one**. Good candidates:

- Multi-step workflows you ran manually
- Commands with many flags you had to remember
- Data transformations you did with jq/awk/sed
- Anything you copy-pasted and modified

**New tool checklist:**
1. Put it in the right place (skill's `scripts/` dir or repo's `dev/` dir)
2. Add `--help` with a one-liner description
3. Use sensible defaults so minimal flags are needed
4. Output minimally on success, clearly on failure
5. Make it executable (`chmod +x`)
6. Document it in the relevant SKILL.md

**Template for new tools:**
```bash
#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $(basename "$0") [options] <required-arg>"
  echo ""
  echo "Brief description of what this does."
  echo ""
  echo "Options:"
  echo "  -h, --help     Show this help"
  echo "  -v, --verbose  Verbose output"
}

# Parse args, do work, output minimally
```

## Step 4: Validate

After making changes:

1. **Test tools** - Run them to verify they work
2. **Read skills** - Read your updated docs as if new to them
3. **Check tokens** - Is essential info in fewer tokens?
4. **Verify autonomy** - Can an agent use these without extra context?

## Step 5: Report

```markdown
## Improvements Made

### Skills Updated
- **<skill-name>**: <what you changed and why>

### Tools Improved
- **<tool-name>**: <what you changed and why>

### New Tools Created
- **<new-tool>**: <what it does and where it lives>
```

## Mindset

The best tools are invisible—they just work, say only what you need to know, and get out of the way.

Every improvement you make saves tokens, reduces confusion, and helps the next agent work faster. Take pride in this. A well-crafted tool is a gift to everyone who comes after.

**Go make the tools and skills you wish existed.**
