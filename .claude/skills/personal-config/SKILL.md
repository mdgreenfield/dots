---
name: personal-config
description: Manage and improve personal terminal configuration stored in ~/dots. Use when asked to update shell aliases, vim config, tmux settings, git config, SSH config, Brewfile packages, agent instructions, or anything related to dotfiles. Handles editing configs, applying them to the live environment, and committing changes to the ~/dots git repo.
compatibility: Designed for Claude Code on macOS. Requires git, zsh, vim, tmux, brew.
allowed-tools: Bash Read Write Edit Glob Grep
---

# Personal Config Management

Dotfiles live in `~/dots` (a git repo synced to GitHub). Changes must be:
1. Edited in `~/dots`
2. Applied to `~` (use the apply script)
3. Committed and optionally pushed

## Deployment Model

Config files are **copies**, not symlinks. `~/dots/` is the source of truth.

> ⚠️ If you edit a config directly in `~` (e.g. `~/.zshrc`), those changes will be **lost** the next time `install` or `apply` runs. Always edit in `~/dots/` first, then apply.

**Exceptions (symlinks — changes take effect immediately, no copy needed):**
- `~/.claude/skills` → `~/dots/.claude/skills`
- `~/AGENTS.md` → `~/dots/AGENTS.md`

## Quick Start

```bash
# 1. Edit a config in ~/dots
# 2. Apply all configs at once:
~/dots/.claude/skills/personal-config/scripts/apply

# 3. Commit
cd ~/dots && git add -p && git commit -m "config: <what changed>" && git push
```

## Current State

```
Uncommitted changes in ~/dots:
!`cd ~/dots && git status --short 2>/dev/null || echo "(clean)"`

Recent commits:
!`cd ~/dots && git log --oneline -5 2>/dev/null`
```

## Config Files

| File | Purpose | Notes |
|------|---------|-------|
| `.zshrc` | Shell: aliases, plugins, env, functions | Sourced by apply |
| `.vimrc` | Vim: plugins (Vundle), keybindings | |
| `.tmux.conf` | Tmux: prefix=Ctrl+a, vi-mode, kube status | |
| `.gitconfig` | Git: aliases, colors, rerere | ⚠️ excluded from apply (no `[user]` block — would wipe identity) |
| `.alacritty.toml` | Alacritty terminal: Tango colors, black bg, green fg | |
| `.gitignore` | Global gitignore | |
| `.my.cnf` | MySQL client: charset, engine, prompt | |
| `.ssh/config` | SSH: keychain, multiplexing, keepalive | apply sets chmod 600 |
| `brew/Brewfile` | Homebrew packages | `brew bundle --file=~/dots/brew/Brewfile` |
| `AGENTS.md` | Agent instructions (GitHub, PR style) | Symlinked; edit in dots, takes effect immediately |

## Symlinks

| Symlink | Points to | Notes |
|---------|-----------|-------|
| `~/.claude/skills` | `~/dots/.claude/skills` | Skills take effect immediately |
| `~/AGENTS.md` | `~/dots/AGENTS.md` | Agent instructions for all tools |
| `~/.claude/CLAUDE.md` loads | `~/dots/AGENTS.md` | Via `@~/dots/AGENTS.md` include |

## Key Config Details

### Shell (`.zshrc`)
- Framework: oh-my-zsh, theme: `robbyrussell`
- Plugins: `fzf git zsh-autosuggestions zsh-syntax-highlighting`
- Aliases: `sp` (source ~/.zshrc), `vi` (vim), `ll` (ls -al)
- Auto-attaches to tmux session `default` on login
- `jwt-dump()` function for decoding JWTs

### Vim (`.vimrc`)
- Plugin manager: Vundle (`~/.vim/bundle/Vundle.vim`)
- Notable plugins: NERDTree, vim-fugitive, vim-go, ALE, FZF, vim-airline
- Indent: 2 spaces (Ruby/YAML), 4 spaces (default), tabs (Go)
- Color scheme: `desert256v2`
- To install new plugins: add to `.vimrc`, run `vim +PluginInstall +qall`

### Tmux (`.tmux.conf`)
- Prefix: `Ctrl+a` (not `Ctrl+b`)
- Plugin manager: TPM (`~/.tmux/plugins/tpm`)
- Plugins: tmux-resurrect, tmux-colors-solarized, kube-tmux
- Status bar shows current Kubernetes context

### Git (`.gitconfig`)
- Key aliases: `lol` (log graph), `co` (checkout), `st` (status), `cr`/`cl` (branch cleanup)
- rerere enabled, color ui auto

### Agent Instructions (`AGENTS.md`)
- Always use `gh` CLI for GitHub interactions
- PR/commit style: Jira prefix, imperative mood, 50-char subject, 72-char body wrap
- Loaded by Claude Code globally via `~/.claude/CLAUDE.md`
- Portable to Cursor, Codex, and other AGENTS.md-compatible tools

## Common Tasks

### Add a shell alias
Edit `~/dots/.zshrc`, then:
```bash
~/dots/.claude/skills/personal-config/scripts/apply
```

### Add a shell function
Edit `~/dots/.zshrc`, add after the existing `jwt-dump()` function, then run apply.

### Add a Vim plugin
Edit `~/dots/.vimrc`, add `Plugin 'author/repo'` in the Vundle block, then:
```bash
cp ~/dots/.vimrc ~/.vimrc && vim +PluginInstall +qall
```

### Add a Homebrew package
```bash
echo 'brew "<package>"' >> ~/dots/brew/Brewfile
brew install <package>
```

### Update agent instructions
Edit `~/dots/AGENTS.md` — changes are live immediately via the symlink.

### Full setup on a new machine
```bash
# 1. Clone and run install
git clone <repo> ~/dots && cd ~/dots && bash install
brew bundle --file=~/dots/brew/Brewfile

# 2. Set up symlinks
ln -sf ~/dots/.claude/skills ~/.claude/skills
ln -sf ~/dots/AGENTS.md ~/AGENTS.md
echo '@~/dots/AGENTS.md' > ~/.claude/CLAUDE.md
```

## Committing Changes

```bash
cd ~/dots
git diff                           # review changes
git add <file>                     # stage specific files
git commit -m "config: <summary>"  # commit
git push                           # push to GitHub
```

Commit message convention: `config: <what changed>` (e.g. `config: add k alias for kubectl`)
