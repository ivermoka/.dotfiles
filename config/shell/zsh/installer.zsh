PKGS=("npm" "golang" "python3" "python3.14-venv" "git" "tmux" "neovim" "fzf" "podman" "maven" "openjdk-17-jdk" "openjdk-17-jre" "ripgrep")

sudo apt update

# TODO: Add compatibility to arch

for pkg in "${PKGS[@]}"; do
    dpkg -s "$pkg" >/dev/null 2>&1 || sudo apt install -y "$pkg"
done
