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

# kotlin-lsp (JetBrains "Kotlin LSP")
# The GH-release build Mason installs (Kotlin/kotlin-lsp) is time-bombed and
# expires ~6 weeks after release; mason-registry has been slow to bump it
# (see https://github.com/Kotlin/kotlin-lsp/issues/271). The VS Code
# Marketplace build of the same server ("JetBrains.kotlin-server") is
# updated far more often and isn't expired. kotlin.nvim natively supports
# pointing at a manually-installed server via $KOTLIN_LSP_DIR, so we extract
# the marketplace .vsix's bundled server there instead of relying on Mason.
# To refresh: download the linux-x64 .vsix from the VS Code Marketplace API
# for JetBrains.kotlin-server, unzip it, and replace the contents of
# ~/.local/share/kotlin-lsp with extension/server/.
export KOTLIN_LSP_DIR="$HOME/.local/share/kotlin-lsp"

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
