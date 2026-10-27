D="$HOME/projects/.dotfiles"
for f in "$D"/config/*; do
  t=~/.config/$(basename "$f")
  [ -L "$t" ] && rm "$t"
  [ -d "$f" ] && find "$t" -maxdepth 1 -type l -lname "$D/*" -delete 2>/dev/null
done
for f in "$D"/home/.[!.]*; do rm -f ~/"$(basename "$f")"; done
rm -f ~/.bashrc
rm -rf ~/.bashrc.d
