# Stop fastfetch from running multiple times in a tmux session, as well as intergrated terminals (eg. vscode)
# Also allows for fastfetch to be turned off by setting FASTFETCH=0 and/or FASTFETCH_DISABLE=0
if command -v fastfetch > /dev/null && \
	[ "$FASTFETCH" != 0 ] && \
	[ "$FASTFETCH_DISABLE" != 0 ]
then
	if [[ -n "$TMUX" ]] && command -v tmux > /dev/null; then
		TMUX_WINDOW_COUNT=$(tmux list-windows 2> /dev/null | wc -l)
		TMUX_PANE_COUNT=$(tmux list-panes 2> /dev/null | wc -l)
	fi

	if [[ -z "$TERMINAL_EMULATOR" ]] && [[ -z "$TERM_PROGRAM" \
		|| "$TMUX_WINDOW_COUNT" == "1" && "$TMUX_PANE_COUNT" == "1" ]]; then
		fastfetch
	fi
fi

unset FASTFETCH TMUX_PANE_COUNT TMUX_WINDOW_COUNT
