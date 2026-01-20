#!/bin/bash


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
  echo "  close   → close specific port, using 'kill -9(lsof ...)'"
  echo "  bashrc / brc  → vim ~/.bashrc"
  echo "  proc    → processes helper command"
}

function proc() {
	echo "Prosesses:"
	echo "	ps aux - show processes"
	echo "	sudo netstat -tuln - active internet connections. TCP, UDP, listening sockets, numerical adresses"
	echo "	sudo lsof -i -P -n - active processes. Network files (TCP/UDP etc), port numbers, no hostnames"
	echo "  sudo lsof -nP -iTCP:<port> -sTCP:LISTEN - for ports"
}

function close() {
	local port="$1"

	if [[ -z "$port" ]]; then 
		echo "Missing port arg"
		return 1
	fi

	local pids
	pids=$(lsof -t -i :"$port")

	if [[ -z "$pids" ]]; then
	    	echo "No process running on port $port"
	    	return 0
	fi
	kill -9 $pids
}

# Language specific

function kt() {
	kotlinc $1 -include-runtime -d app.jar && java -jar app.jar
}
