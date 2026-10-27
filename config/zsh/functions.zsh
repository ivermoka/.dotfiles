help() {
  echo "Aliases:"
  alias | sed 's/^/  /'

  echo
  echo "Functions:"
  grep -hoE '^[a-zA-Z_][a-zA-Z0-9_]*\(\)' ~/.config/zsh/*.zsh 2>/dev/null \
    | sed 's/()//' | grep -vx help | sort -u | sed 's/^/  /'

  echo
  echo "Processes/ports:"
  echo "  ps aux                                   - show processes"
  echo "  sudo netstat -tuln                       - active connections (TCP/UDP, listening, numeric)"
  echo "  sudo lsof -i -P -n                        - active processes with network files, no hostname lookup"
  echo "  sudo lsof -nP -iTCP:<port> -sTCP:LISTEN   - find what's listening on <port>"
}

close() {
  local port="$1"

  kill -9 $(lsof -t -i :"$port")
}

# Language specific

kt() {
	kotlinc $1 -include-runtime -d app.jar && java -jar app.jar
}

# Helpers! 

cdpp() {
	local base="${1:-$HOME/projects}"
	local dir
	dir=$(find "$base" -maxdepth 1 -mindepth 1 -type d | fzf --preview 'ls -la {}') || return
  	cd "$dir"
}

conf() {
	(
		cd ~/projects/.dotfiles || exit
		v
		)
}

