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

# Awesome
ln -s ~/projects/.dotfiles/config/awesome ~/.config/awesome
ln -s ~/projects/.dotfiles/config/rofi ~/.config/rofi

# GTK dark mode (GTK 3/4); libadwaita uses the desktop color-scheme preference.
mkdir -p ~/.config/gtk-3.0 ~/.config/gtk-4.0
ln -sf ~/projects/.dotfiles/config/gtk-3.0/settings.ini ~/.config/gtk-3.0/settings.ini
ln -sf ~/projects/.dotfiles/config/gtk-4.0/settings.ini ~/.config/gtk-4.0/settings.ini
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-red-dark'
