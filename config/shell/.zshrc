for file in ~/.config/zsh/*.zsh; do
  source "$file"
done

eval "$(starship init zsh)"

# opencode
export PATH=/home/iverk/.opencode/bin:$PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
