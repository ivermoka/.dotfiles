autoload -Uz compinit; compinit  # Added to avoid fzf-tab errors. Look at https://github.com/Aloxaf/fzf-tab/issues/529

if [[ ! "$PATH" == */.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}$HOME/.fzf/bin"
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

