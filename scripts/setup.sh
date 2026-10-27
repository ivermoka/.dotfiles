#!/usr/bin/env bash
# Repo layout mirrors the install targets:
#   config/*  -> ~/.config/*
#   home/.*   -> ~/.*
#   etc/*     -> /etc/*  (not linked automatically)
DOTFILES="$HOME/projects/.dotfiles"

# Clone repos
[ -d "$DOTFILES" ] || git clone git@github.com:ivermoka/.dotfiles.git "$DOTFILES"
[ -d ~/.antidote ] || git clone --depth=1 https://github.com/mattmc3/antidote.git ~/.antidote
[ -d "$DOTFILES/config/alacritty/themes" ] || git clone --depth=1 https://github.com/alacritty/alacritty-theme "$DOTFILES/config/alacritty/themes"

# Link src to dst. If dst is already a real directory (e.g. ~/.config/gtk-3.0
# holds app-generated files), link its children instead of replacing it.
link() {
  local src=$1 dst=$2
  if [ -d "$src" ] && [ -d "$dst" ] && [ ! -L "$dst" ]; then
    local f
    for f in "$src"/*; do link "$f" "$dst/$(basename "$f")"; done
  else
    ln -sfn "$src" "$dst"
  fi
}

mkdir -p ~/.config
for f in "$DOTFILES"/config/*; do link "$f" ~/.config/"$(basename "$f")"; done
for f in "$DOTFILES"/home/.[!.]*; do link "$f" ~/"$(basename "$f")"; done

# GTK dark mode (GTK 3/4); libadwaita uses the desktop color-scheme preference.
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-red-dark'
