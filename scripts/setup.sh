# Clone repos
git clone git@github.com:ivermoka/.dotfiles.git ~/projects/.dotfiles
git clone --depth=1 https://github.com/mattmc3/antidote.git ~/.antidote

# Zsh
ln -sf ~/projects/.dotfiles/config/shell/.zshrc ~/.zshrc
ln -sf ~/projects/.dotfiles/config/shell/.zsh_plugins.txt ~/.zsh_plugins.txt
ln -sfn ~/projects/.dotfiles/config/shell/zsh ~/.config/zsh

# Starship <Zsh>
ln -sf ~/projects/.dotfiles/config/shell/starship.toml ~/.config/starship.toml

# Tmux
ln -sf ~/projects/.dotfiles/config/tmux/.tmux.conf ~/.tmux.conf

# Git
ln -sf ~/projects/.dotfiles/config/git/.gitconfig ~/.gitconfig
