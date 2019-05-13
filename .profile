source ~/git-completion.bash
source ~/git-prompt.sh

export EDITOR=vim
export GIT_TEMPLATE_DIR=~/dots/.git_template
export HISTIGNORE="$HISTIGNORE:history*"
export HISTSIZE=20000
export HISTFILESIZE=20000
export HISTCONTROL=ignoredups
shopt -s histappend

PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '

alias git=hub
alias g='git'
alias vi='vim'

# Autocomplete for 'g' as well
complete -o default -o nospace -F _git g

alias sp="source ~/.profile"
alias ll="ls -al"

function fast_grep() { find . -type f | parallel -k -j150% -n 1000 -m grep -H -n "${1}" {}; }

# This stuff will give you a fancy-dancy prompt that includes the
# svn/git trunk/tags/branches part of the URL in it so you will always know
# where you are working in Subversion or Git.
PROMPT_NO_COLOR="\[\033[0m\]"
PROMPT_BLACK="\[\033[1;30m\]"
PROMPT_BOLD_RED="\[\033[1;31m\]"
PROMPT_BOLD_GREEN="\[\033[1;32m\]"
PROMPT_BOLD_YELLOW="\[\033[1;33m\]"
PROMPT_BOLD_CYAN="\[\033[1;34m\]"
PROMPT_BOLD_MAGENTA="\[\033[1;35m\]"
PROMPT_BOLD_GREY="\[\033[1;36m\]"
PROMPT_BOLD_WHITE="\[\033[1;37m\]"
PROMPT_RED="\[\033[0;31m\]"
PROMPT_GREEN="\[\033[0;32m\]"
PROMPT_YELLOW="\[\033[0;33m\]"
PROMPT_CYAN="\[\033[0;34m\]"
PROMPT_MAGENTA="\[\033[0;35m\]"
PROMPT_TEAL="\[\033[0;36m\]"
PROMPT_WHITE="\[\033[0;37m\]"

# Default SVN and Git colors
SVN_TRUNK_COLOR_DEFAULT=$PROMPT_YELLOW
SVN_BRANCH_COLOR_DEFAULT=$PROMPT_GREEN
GIT_MASTER_COLOR_DEFAULT=$PROMPT_YELLOW
GIT_BRANCH_COLOR_DEFAULT=$PROMPT_GREEN

# Set SVN and Git colors if not already set
# To set you own SVN_TRUNK_COLOR, define SVN_TRUNK_COLOR before sourcing pose.bash
SVN_TRUNK_COLOR=${SVN_TRUNK_COLOR:-$SVN_TRUNK_COLOR_DEFAULT}
SVN_BRANCH_COLOR=${SVN_BRANCH_COLOR:-$SVN_BRANCH_COLOR_DEFAULT}
GIT_MASTER_COLOR=${GIT_MASTER_COLOR:-$GIT_MASTER_COLOR_DEFAULT}
GIT_BRANCH_COLOR=${GIT_BRANCH_COLOR:-$GIT_BRANCH_COLOR_DEFAULT}

function command_exists() {
    command -v "$1" &> /dev/null
}

function spwd() {
    stat .svn > /dev/null 2>&1
    if [ "$?" == "0" ]; then
        SURL=`svn info | grep URL | head -1 | perl -pe 's/URL: (.*)/\1/'`
        if [ `echo ${SURL} | grep -E "branches|tags"` ]; then
            SVER=`echo ${SURL} | perl -pe 's{.*/(branches|tags)/(.*)}{\1/\2}' | cut -d/ -f1-2`
            SPTH=`echo ${SURL} | perl -pe 's{.*svnroot/(.*)/(branches|tags)/.*}{/\1}'`
            SPWD="${SPTH}/${SVER}"
            SCL=$SVN_BRANCH_COLOR
        else
            SPWD=`echo ${SURL} | perl -pe 's{.*svnroot/(.*)/trunk(.*)}{/\1/trunk}'`
            SCL=$SVN_TRUNK_COLOR
        fi
        export PS1="${PROMPT_YELLOW}\u:\w ${SCL}[SVN: $SPWD]\n${PROMPT_YELLOW}$ ${PROMPT_NO_COLOR}"

    # Requires git-completion.bash to do anything useful.
    elif command_exists __git_ps1; then
        GITBRANCH=`__git_ps1 "%s"`
        if [[ "${GITBRANCH}" != "" ]]; then
            if [[ "${GITBRANCH}" == "master" ]]; then
                export PS1="\u:\w ${GIT_MASTER_COLOR}[git: $GITBRANCH]${PROMPT_NO_COLOR} $ "
            else
                export PS1="\u:\w ${GIT_BRANCH_COLOR}[git: $GITBRANCH]${PROMPT_NO_COLOR} $ "
            fi
        else
            export PS1=$DEFAULT_PS1
        fi
    else
        export PS1=$DEFAULT_PS1
    fi
}

if [ -z "${DEFAULT_PS1}" ]; then
    export DEFAULT_PS1="\u:\w $ "
fi

if [ -z $NO_SVN_PROMPT ]; then
    export PROMPT_COMMAND=spwd
fi

if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi
