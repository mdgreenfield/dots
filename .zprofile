# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"

# brew shellenv's zsh output also exports FPATH. Un-export it: an inherited
# FPATH pollutes the tmux server env and permanently invalidates compinit's
# zcompdump cache in nested shells (full completion rescan on every startup).
typeset +x FPATH

source /Users/matt.greenfield/.privilegesalias

# dogbrew shell-hooks: if you don't want this to be called, comment it out and dogbrew will honour that on subsequent updates.  See also the more dangerous `dogbrew self setup --disable-shell-hooks`.
[ -f "/opt/dogbrew/share/etc/dogbrew/init.zsh" ] && . "/opt/dogbrew/share/etc/dogbrew/init.zsh"
