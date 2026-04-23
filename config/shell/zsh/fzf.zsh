if [[ ! "$PATH" == */home/iverk/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/iverk/.fzf/bin"
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

