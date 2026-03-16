#
# ~/.bash_aliases
#

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ip='ip --color'

alias la='ls -A'
alias lr='ls -R'
alias ll='ls -Alh'

alias clipboard='xsel -b'
alias du='du --exclude /proc'
alias open='xdg-open'

alias compiledb='compiledb --command-style'

alias tmux-new='tmux new -s "#{server_sessions}"'
