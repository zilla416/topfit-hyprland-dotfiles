#
# ~/.bashrc
#
pokemon-colorscripts -r

alias code='flatpak run com.visualstudio.code >/dev/null 2>&1 & disown; exit'

eval "$(oh-my-posh --init --shell bash --config ~/1_shell.omp.json)"
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# Created by `pipx` on 2025-05-06 21:22:53
export PATH="$PATH:/home/jaiden/.local/bin"

export PATH=$PATH:/home/jaiden/.spicetify
