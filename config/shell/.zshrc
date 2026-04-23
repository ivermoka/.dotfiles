for file in ~/.config/zsh/*.zsh; do
  source "$file"
done

eval "$(starship init zsh)"
