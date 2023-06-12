#!/bin/bash
IFS=$'\n' # internal field separator

if [[ -n $(pgrep tmux) ]]; then
	no_of_terminals=($(tmux list-sessions | wc -l))
	output=($(tmux list-sessions))
	output_names=($(tmux list-sessions -F\#S))
	index=1
	echo "Choose the terminal to attach: "
	for session in "${output[@]}"; do
		echo "[$index]: $session"
		((index++))
	done
	echo
fi

echo "Create a new session by entering a name instead:"
read -r input
if [[ $input == "" ]]; then
	tmux new-session
elif [[ $input =~ ^[0-9]+$ ]] && [[ $input -le $no_of_terminals ]]; then
	terminal_name="${output_names[input - 1]}"
	tmux attach -t "$terminal_name"
else
	tmux new-session -s "$input"
fi
