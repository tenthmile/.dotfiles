#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

export HISTCONTROL=ignorespace   # zsh equivalent: setopt histignorespace

alias ec="emacs -Q -nw -f full-calc"
alias e="emacsclient -c -n --alternate-editor=\"\""
alias newestFile="find -type f -exec stat \{\} --printf=\"%y\\n\" \\; | sort -n -r | head -n 1"

if [ -f /bin/archey3 ]; then
    archey3
fi

bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'
