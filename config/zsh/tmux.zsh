if command -v tmux >/dev/null && [ -z "$TMUX" ]; then
  tmux attach || tmux new
fi
