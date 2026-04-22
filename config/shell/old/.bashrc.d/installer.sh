#!/bin/bash


#########################################
# Nvim and tmux setup ++
#########################################


NVIM_APPIMAGE="$HOME/nvim-linux-x86_64.appimage"

if ! command -v nvim &>/dev/null; then
    if [ -f "$NVIM_APPIMAGE" ]; then
        sudo chmod +x "$NVIM_APPIMAGE"
        alias nvim="$NVIM_APPIMAGE"
    else
        echo "[bashrc] Neovim AppImage not found at $NVIM_APPIMAGE"
    fi
fi

if [ -n "$TMUX" ]; then
  echo "Already inside tmux, not starting another session."
else
  if ! tmux; then
    echo "Entering Tmux failed :("
  fi
fi

# Init go
~/projects/.dotfiles/scripts/go-init.sh
