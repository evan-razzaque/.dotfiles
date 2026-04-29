not_vim_pager="tmux capture-pane -p | tail -n1 |\
    grep -v '^-- More --'"
is_vim="ps -p '#{@tmux-nav-vim}' &>/dev/null && ${not_vim_pager}"

bind-key 'C-h' if-shell "$is_vim" 'send-keys C-a C-h' 'select-pane -L'
bind-key 'C-j' if-shell "$is_vim" 'send-keys C-a C-j' 'select-pane -D'
bind-key 'C-k' if-shell "$is_vim" 'send-keys C-a C-k' 'select-pane -U'
bind-key 'C-l' if-shell "$is_vim" 'send-keys C-a C-l' 'select-pane -R'

bind-key -T copy-mode-vi 'C-h' select-pane -L
bind-key -T copy-mode-vi 'C-j' select-pane -D
bind-key -T copy-mode-vi 'C-k' select-pane -U
bind-key -T copy-mode-vi 'C-l' select-pane -R
