source ~/git-completion.bash
source ~/git-prompt.sh

PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '

alias g='git'

# Autocomplete for 'g' as well
complete -o default -o nospace -F _git g

alias sp="source ~/.profile"
