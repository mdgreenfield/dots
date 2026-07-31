export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
HIST_STAMPS="%m-%d-%Y %T"
plugins=(fzf git zsh-autosuggestions zsh-syntax-highlighting history-substring-search)

source $ZSH/oh-my-zsh.sh

# history-substring-search: type a prefix, then Up/Down cycles only matching history
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[OA' history-substring-search-up
bindkey '^[OB' history-substring-search-down

HISTSIZE=100000
SAVEHIST=100000
setopt SHARE_HISTORY HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS HIST_VERIFY

alias sp='source ~/.zshrc'
alias vi='vim'
alias ll='ls -al'
alias k=kubectl
alias g=git

export EDITOR=vim
export PATH="$HOME/go/bin:$PATH"

# --- fzf options -------------------------------------------------------------
export FZF_DEFAULT_OPTS='--height 40% --reverse --border --bind ctrl-j:down,ctrl-k:up'
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:200 {}'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:wrap --bind ctrl-y:accept"

if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
  tmux attach -t default || tmux new -s default
fi

function jwt-dump() {
  jq -R 'split(".") | .[0],.[1] | @base64d | fromjson' <<< "$1"
}

function compare() {
  gh browse --branch "${1:-$(git rev-parse --abbrev-ref HEAD)}"
}

eval "$(starship init zsh)"

# Stamp the right edge of the executed prompt line with the current time
autoload -Uz add-zsh-hook
__timestamp_preexec() {
  local ts="[$(date '+%H:%M:%S')]"
  printf '\e7\e[1A\e[%dG\e[2m%s\e[0m\e8' $((COLUMNS - ${#ts} + 1)) "$ts"
}
add-zsh-hook preexec __timestamp_preexec
