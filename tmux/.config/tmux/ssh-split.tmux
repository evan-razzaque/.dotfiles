# New window in current working directory
bind-key c if-shell -b "${tmux_path}/scripts/ssh-split new-window" ""\
	'new-window -c "#{pane_current_path}"'

# Split pane
bind-key j if-shell -b "${tmux_path}/scripts/ssh-split split-window" "" \
	'split-window -c "#{pane_current_path}"'

bind-key k if-shell -b "${tmux_path}/scripts/ssh-split split-window -b" "" \
	'split-window -c "#{pane_current_path}" -b'

bind-key l if-shell -b "${tmux_path}/scripts/ssh-split split-window -h" "" \
	'split-window -c "#{pane_current_path}" -h'

bind-key h if-shell -b "${tmux_path}/scripts/ssh-split split-window -hb" "" \
	'split-window -c "#{pane_current_path}" -hb'

# Change pane working directory to session path
bind-key C-r if-shell "${tmux_path}/scripts/ssh-split respawn" "" \
	'respawn-pane -c "#{session_path}" -k'
