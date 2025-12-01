# IMK BASHRC CONFIG

# Source all scripts in ~/.bashrc.d/
if [ -d "$HOME/.bashrc.d" ]; then
    for script in "$HOME/.bashrc.d/"*; do
        if [ -f "$script" ] && [ -r "$script" ]; then
            source "$script"
        fi
    done
fi


echo -e "\033[1;32m👋 Welcome, $(whoami)! Slay the day 💻\033[0m"
