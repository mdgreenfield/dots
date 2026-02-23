---
name: personal-config
description: Manage and improve personal terminal configuration stored in ~/dots. Use when asked to update shell aliases, vim config, tmux settings, git config, SSH config, Brewfile packages, or anything related to dotfiles. Handles editing configs, applying them to the live environment, and committing changes to the ~/dots git repo.
compatibility: Designed for Claude Code on macOS. Requires git, zsh, vim, tmux, brew.
allowed-tools: Bash Read Write Edit Glob Grep
---

# Personal Config Management

Dotfiles live in `~/dots` (a git repo synced to GitHub). Changes must be:
1. Edited in `~/dots`
2. Applied to `~` (copied or sourced)
3. Committed and optionally pushed

## Deployment Model

Config files are **copies**, not symlinks. `~/dots/` is the source of truth.

> ⚠️ If you edit a config directly in `~` (e.g. `~/.zshrc`), those changes will be **lost** the next time `install` runs. Always edit in `~/dots/` first, then apply.

**Exception:** `~/.claude/skills` is a symlink → `~/dots/.claude/skills`. Changes to skills take effect immediately without any copy step.

## Quick Start

```bash
# Edit a config
edit ~/dots/.zshrc          # shell aliases, functions, env vars
edit ~/dots/.vimrc          # vim plugins, keybindings, settings
edit ~/dots/.tmux.conf      # tmux prefix, keybindings, plugins
edit ~/dots/.gitconfig      # git aliases, color, behavior
edit ~/dots/.alacritty.toml # terminal colors, font, window

# Apply a config
cp ~/dots/.zshrc ~/.zshrc && source ~/.zshrc     # zsh (instant)
cp ~/dots/.vimrc ~/.vimrc                         # vim (next launch)
cp ~/dots/.tmux.conf ~/.tmux.conf                 # tmux: prefix+I to reload

# Commit changes
cd ~/dots && git add -p && git commit -m "config: <what changed>"
git push
```

## Current State

```
Uncommitted changes in ~/dots:
!`cd ~/dots && git status --short 2>/dev/null || echo "(clean)"`

Recent commits:
!`cd ~/dots && git log --oneline -5 2>/dev/null`
```

## Config Files

| File | Purpose | Apply command |
|------|---------|---------------|
| `.zshrc` | Shell: aliases, plugins, env, functions | `cp ~/dots/.zshrc ~/.zshrc && source ~/.zshrc` |
| `.vimrc` | Vim: plugins (Vundle), keybindings | `cp ~/dots/.vimrc ~/.vimrc` |
| `.tmux.conf` | Tmux: prefix=Ctrl+a, vi-mode, kube status | `cp ~/dots/.tmux.conf ~/.tmux.conf` |
| `.gitconfig` | Git: aliases, colors, rerere | `cp ~/dots/.gitconfig ~/.gitconfig` |
| `.alacritty.toml` | Alacritty terminal: colors (Tango), black bg, green fg | `cp ~/dots/.alacritty.toml ~/.alacritty.toml` |
| `.gitignore` | Global gitignore | `cp ~/dots/.gitignore ~/.gitignore` |
| `.my.cnf` | MySQL client: charset, engine, prompt | `cp ~/dots/.my.cnf ~/.my.cnf` |
| `brew/Brewfile` | Homebrew packages | `brew bundle --file=~/dots/brew/Brewfile` |
| `.ssh/config` | SSH: keychain, multiplexing, keepalive | `cp ~/dots/.ssh/config ~/.ssh/config && chmod 600 ~/.ssh/config` |

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

## Common Tasks

### Add a shell alias
```bash
# Add to the aliases section in .zshrc
echo "\nalias <name>='<command>'" >> ~/dots/.zshrc
# Then apply:
cp ~/dots/.zshrc ~/.zshrc && source ~/.zshrc
```

### Add a shell function
Edit `~/dots/.zshrc` and add the function after the existing `jwt-dump()` function.

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

### Full reinstall on a new machine
```bash
cd ~/dots && bash install
brew bundle --file=~/dots/brew/Brewfile
```

## Symlinks

| Symlink | Points to | Notes |
|---------|-----------|-------|
| `~/.claude/skills` | `~/dots/.claude/skills` | Skills take effect immediately; no copy needed |

All other config files (`~/.zshrc`, `~/.vimrc`, etc.) are **copies** deployed by `~/dots/install`.

## Committing Changes

```bash
cd ~/dots
git diff                          # review changes
git add <file>                    # stage specific files
git commit -m "config: <summary>" # commit
git push                          # push to GitHub
```

Commit message convention: `config: <what changed>` (e.g. `config: add k alias for kubectl`)
