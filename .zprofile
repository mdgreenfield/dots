# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"

# brew shellenv's zsh output also exports FPATH. Un-export it: an inherited
# FPATH pollutes the tmux server env and permanently invalidates compinit's
# zcompdump cache in nested shells (full completion rescan on every startup).
typeset +x FPATH

source /Users/matt.greenfield/.privilegesalias

eval "$(/opt/dogbrew/bin/dogbrew init zsh)"
