# IMK BASHRC CONFIG


################################
# Exports
################################

export PATH="$PATH:$HOME/go/bin"
export JAVA_HOME="/usr/lib/jvm/java-21-openjdk-amd64"
export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export NVM_DIR="$HOME/.config/nvm"


export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pnpm
export PNPM_HOME="/home/iverk/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end


###############################################
# Aliases
###############################################

alias gc="git commit"
alias gca="git commit -a"
alias gsa="git stash -a"
alias gsA="git stash apply"
alias gd="git diff"
alias lg="lazygit"
alias gp="git push"
alias gP="git pull"
alias gf="git fetch"
alias gs="git status"
alias gb="git branch -a"

alias cdp="cd ~/projects/"
alias cdpd="cd ~/projects/driftsdata-service"


alias bashrc="nvim ~/.bashrc"
alias brc="bashrc"
alias src="source ~/.bashrc"

alias tmx="nvim ~/.tmux.conf"
alias srct="tmux source-file ~/.tmux.conf"

alias v="nvim"
alias v.="nvim ."


#########################################
# Nvim and tmux setup ++
#########################################

echo -e "\033[1;32m👋 Welcome, $(whoami)! Slay the day 💻\033[0m"


NVIM_APPIMAGE="$HOME/nvim-linux-x86_64.appimage"

if ! command -v nvim &>/dev/null; then
    echo "[bashrc] Neovim not found — setting up AppImage..."
    
    if [ -f "$NVIM_APPIMAGE" ]; then
        sudo chmod +x "$NVIM_APPIMAGE"
        alias nvim="$NVIM_APPIMAGE"
    else
        echo "[bashrc] Neovim AppImage not found at $NVIM_APPIMAGE"
    fi
fi

if ! tmux has-session 2>/dev/null; then
    tmux new-session -d
fi
tmux source-file ~/.tmux.conf


#####################################
# Helper functions 
#####################################

function help() {
  echo "📦 Developer Command List:"
  echo "  gc      → git commit"
  echo "  gca     → git commit -a"
  echo "  gsa     → git stash -a"
  echo "  gsA     → git stash apply"
  echo "  gd      → git diff"
  echo "  lg      → lazygit"
  echo "  gp      → git push"
  echo "  gP      → git pull"
  echo "  gf      → git fetch"
  echo "  gs      → git status"
  echo "  gb      → git branch -a"
  echo "  cdp     → cd ~/projects/"
  echo "  cdpd    → cd ~/projects/driftsdata-service"
  echo "  bashrc / brc  → vim ~/.bashrc"
  echo "  gnb     → git checkout -b <branch-name>"
}


function gnb() {
  if [ -z "$1" ]; then
    echo "❌ Usage: gnb <branch-name>"
  else
    git checkout -b "$1"
  fi
}
