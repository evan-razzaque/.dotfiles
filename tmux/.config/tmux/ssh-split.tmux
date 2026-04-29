# New window in current working directory
bind-key c run-shell -b "~/.config/tmux/scripts/ssh-split new-window"

# Split pane
bind-key j run-shell -b "~/.config/tmux/scripts/ssh-split split-window"
bind-key k run-shell -b "~/.config/tmux/scripts/ssh-split split-window -b"
bind-key l run-shell -b "~/.config/tmux/scripts/ssh-split split-window -h"
bind-key h run-shell -b "~/.config/tmux/scripts/ssh-split split-window -hb"

# Change pane working directory to session path
bind-key C-r run-shell "~/.config/tmux/scripts/ssh-split respawn"
