#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

eval "$(starship init bash)"

# Show system info on terminal startup with animated ASCII
if [[ -t 0 && -t 1 ]]; then
   ~/.config/fastfetch/animated-ascii.sh 0.05
fi

export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# Load Angular CLI autocompletion.
source <(ng completion script)
