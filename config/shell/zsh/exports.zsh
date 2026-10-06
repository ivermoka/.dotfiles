# go
export PATH="$PATH:/usr/local/go/bin"
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# java - follows whatever `javav` (update-alternatives) currently points java at
if command -v java >/dev/null 2>&1; then
    export JAVA_HOME="$(dirname "$(dirname "$(readlink -f "$(command -v java)")")")"
fi

# common tools
export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# nvim
export PATH="/opt/nvim/bin:$PATH"

# kotlinc
export PATH="$HOME/local/kotlinc/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# snap
export PATH="/snap/bin:$PATH"

# opencode
export PATH="$HOME/.opencode/bin:$PATH"

export PATH="$HOME/.cargo/bin:$PATH"

#Rofi
export PATH=$HOME/.config/rofi/scripts:$PATH
