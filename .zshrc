export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
HIST_STAMPS="%m-%d-%Y %T"
plugins=(fzf git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

alias sp='source ~/.zshrc'
alias vi='vim'
alias ll='ls -al'

export EDITOR=vim

if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
  tmux attach -t default || tmux new -s default
fi

function jwt-dump() {
  jq -R 'split(".") | .[0],.[1] | @base64d | fromjson' <<< $(echo "$1")
}
