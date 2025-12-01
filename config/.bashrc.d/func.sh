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
  echo "  bashrc / brc  → vim ~/.bashrc"
  echo "  gnb     → git checkout -b <branch-name>"
}

function processes() {
	echo "Prosesses:"
	echo "	ps aux - show processes"
	echo "	sudo netstat -tuln - active internet connections. TCP, UDP, listening sockets, numerical adresses"
	echo "	sudo lsof -i -P -n - active processes. Network files (TCP/UDP etc), port numbers, no hostnames"
	echo "  sudo lsof -nP -iTCP:<port> -sTCP:LISTEN - for ports"
}


function gnb() {
  if [ -z "$1" ]; then
    echo "❌ Usage: gnb <branch-name>"
  else
    git checkout -b "$1"
  fi
}

