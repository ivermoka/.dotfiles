# Only checks/installs packages once per day (stamp file), so opening a
# shell doesn't do a network-hitting `apt update` every time.
STAMP="$HOME/.cache/dotfiles-installer.stamp"
INTERVAL="${DOTFILES_INSTALLER_INTERVAL:-86400}" # seconds, 1 day

if [[ ! -f "$STAMP" ]] || (( $(date +%s) - $(stat -c %Y "$STAMP") > INTERVAL )); then
    PKGS=("npm" "golang" "python3" "python3.14-venv" "git" "tmux" "neovim" "fzf" "podman" "maven" "openjdk-17-jdk" "openjdk-17-jre" "ripgrep" "cargo" "lazygit")

    # TODO: Add compatibility to arch

    for pkg in "${PKGS[@]}"; do
        dpkg -s "$pkg" >/dev/null 2>&1 || sudo apt install -y "$pkg"
    done

    mkdir -p "$(dirname "$STAMP")"
    touch "$STAMP"
fi
