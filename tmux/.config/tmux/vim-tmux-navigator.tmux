%hidden is_vim="ps -p '#{@tmux-nav-vim}' &>/dev/null"

%hidden vim_nav_notify="\
    ps -p #{@tmux-nav-vim} -o uid:1= | grep #{uid} || exit 0;\
    (\
        flock -e 3;\
        echo #{@tmux-nav-vim-direction} >&3;\
        kill -USR1 #{@tmux-nav-vim} &>/dev/null;\
    ) 3> /tmp/tmux-nav-vim-#{uid}-#{@tmux-nav-vim}\
"

%hidden __bind="C-h"
bind-key -r $__bind if-shell "$is_vim" {
    set -p @tmux-nav-vim-direction Left
    run-shell "$vim_nav_notify"
    send-keys C-a $__bind
} { select-pane -L }

%hidden __bind="C-l"
bind-key -r $__bind if-shell "$is_vim" {
    set -p @tmux-nav-vim-direction Right
    run-shell "$vim_nav_notify"
    send-keys C-a $__bind
} { select-pane -R }

%hidden __bind="C-j"
bind-key -r $__bind if-shell "$is_vim" {
    set -p @tmux-nav-vim-direction Down
    run-shell "$vim_nav_notify"
    send-keys C-a $__bind
} { select-pane -D }

%hidden __bind="C-k"
bind-key -r $__bind if-shell "$is_vim" {
    set -p @tmux-nav-vim-direction Up
    run-shell "$vim_nav_notify"
    send-keys C-a $__bind
} { select-pane -U }

set-environment -hgu __bind
set-environment -hgu is_vim
set-environment -hgu vim_nav_notify

bind-key -T copy-mode-vi 'C-h' select-pane -L
bind-key -T copy-mode-vi 'C-j' select-pane -D
bind-key -T copy-mode-vi 'C-k' select-pane -U
bind-key -T copy-mode-vi 'C-l' select-pane -R
