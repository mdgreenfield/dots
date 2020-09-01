plugins=(fzf git zsh-autosuggestions)

HIST_STAMPS="%m-%d-%Y %T"

fpath=(~/.zsh $fpath)

# https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
source ~/git-prompt.sh
setopt PROMPT_SUBST ; PS1='[%n@%m %c$(__git_ps1 " (%s)")]\$ '

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
