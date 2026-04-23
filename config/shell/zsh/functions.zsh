help() {
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
  echo "  close   → close specific port, using 'kill -9(lsof ...)'"
  echo "  bashrc / brc  → vim ~/.bashrc"
  echo "  proc    → processes helper command"
}

proc() {
	echo "Prosesses:"
	echo "	ps aux - show processes"
	echo "	sudo netstat -tuln - active internet connections. TCP, UDP, listening sockets, numerical adresses"
	echo "	sudo lsof -i -P -n - active processes. Network files (TCP/UDP etc), port numbers, no hostnames"
	echo "  sudo lsof -nP -iTCP:<port> -sTCP:LISTEN - for ports"
}

close() {

  local port="$1"

  kill -9 $(lsof -t -i :"$port")
}

# Language specific

kt() {
	kotlinc $1 -include-runtime -d app.jar && java -jar app.jar
}

cdpp() {
  dir=$(find ~/projects -maxdepth 1 -mindepth 1 -type d | fzf --preview 'ls -la {}')
  [ -n "$dir" ] && cd "$dir" && nvim .
}

