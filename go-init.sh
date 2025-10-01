#!/usr/bin/env bash
set -euo pipefail

GO_VERSION="1.23.2" 
GO_TARBALL="go${GO_VERSION}.linux-amd64.tar.gz"
DOWNLOAD_URL="https://go.dev/dl/${GO_TARBALL}"

INSTALL_DIR="/usr/local"
GOROOT="${INSTALL_DIR}/go"

if command -v go >/dev/null 2>&1; then
    echo "✅ Go is already installed: $(go version)"
    exit 0
fi

echo "⬇️  Downloading Go ${GO_VERSION}..."
curl -LO "${DOWNLOAD_URL}"

echo "🧹 Removing any old Go installation..."
sudo rm -rf "${GOROOT}"

echo "📦 Installing to ${INSTALL_DIR}..."
sudo tar -C "${INSTALL_DIR}" -xzf "${GO_TARBALL}"

rm "${GO_TARBALL}"

echo "✅ Go installed: $(${GOROOT}/bin/go version)"

# ensure PATH is set
if ! grep -q "/usr/local/go/bin" "$HOME/.bashrc"; then
  {
    echo ''
    echo '# Go setup'
    echo 'export PATH="/usr/local/go/bin:$PATH"'
    echo 'export GOPATH="$HOME/go"'
    echo 'export PATH="$PATH:$GOPATH/bin"'
  } >> "$HOME/.bashrc"
  echo "🔧 Added Go paths to ~/.bashrc"
fi

echo "👉 Run: source ~/.bashrc"

