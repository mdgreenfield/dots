#!/usr/bin/env bash
# sync-claude-notes.sh - copy Claude session summaries into ~/ai-notes/code-session-notes.
#
# Session summaries are written to a project's Claude memory directory, which is
# per-project and not backed up. This mirrors them into the notes tree so they
# live alongside everything else.
#
# Safe to run repeatedly, including from a hook: a note is copied when it is new,
# refreshed when the source changed and the copy was left untouched, and left
# alone the moment it has been edited by hand. Nothing is ever deleted.
set -euo pipefail

PROJECTS="${CLAUDE_PROJECTS_DIR:-$HOME/.claude/projects}"
DEST="${CLAUDE_NOTES_DIR:-$HOME/ai-notes/code-session-notes}"
STATE="$DEST/.sync-state"

sha() { shasum -a 256 "$1" | cut -d' ' -f1; }

[ -d "$PROJECTS" ] || { echo "no Claude projects directory at $PROJECTS" >&2; exit 0; }
mkdir -p "$STATE"

shopt -s nullglob
new=0 updated=0 skipped=0

for src in "$PROJECTS"/*/memory/session_*.md; do
  name="$(basename "$src")"
  dst="$DEST/$name"
  rec="$STATE/$name.sha"
  src_sha="$(sha "$src")"

  # New note: copy it and remember what was written.
  if [ ! -e "$dst" ]; then
    cp "$src" "$dst"
    printf '%s\n' "$src_sha" >"$rec"
    echo "synced:  $name"
    new=$((new + 1))
    continue
  fi

  dst_sha="$(sha "$dst")"

  # Already identical. Record the hash so a copy made before this script existed
  # is adopted rather than treated as hand-written forever.
  if [ "$dst_sha" = "$src_sha" ]; then
    printf '%s\n' "$src_sha" >"$rec"
    continue
  fi

  # Source moved on. Refresh only if the copy is exactly what was last synced,
  # so local edits are never clobbered. Summaries do get updated in place
  # (the skill's "Last updated:" line), which is why this is not copy-once.
  if [ -f "$rec" ] && [ "$dst_sha" = "$(cat "$rec")" ]; then
    cp "$src" "$dst"
    printf '%s\n' "$src_sha" >"$rec"
    echo "updated: $name"
    updated=$((updated + 1))
  else
    echo "skipped: $name (locally modified; not overwriting)" >&2
    skipped=$((skipped + 1))
  fi
done

if [ $((new + updated + skipped)) -eq 0 ]; then
  echo "session notes already up to date"
else
  echo "$new new, $updated updated, $skipped skipped -> $DEST"
fi
