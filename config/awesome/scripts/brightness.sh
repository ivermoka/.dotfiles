#!/bin/bash
# Laptop backlight control via systemd-logind (no root / video group needed).
# xbacklight doesn't work with amdgpu/modesetting.
# Usage: brightness.sh up|down [step%] | set <percent> | get

dev=$(ls /sys/class/backlight | head -n1)
[ -n "$dev" ] || { echo "no backlight device" >&2; exit 1; }
sys=/sys/class/backlight/$dev
max=$(cat "$sys/max_brightness")
cur=$(cat "$sys/brightness")
pct=$((cur * 100 / max))

case "$1" in
up) pct=$((pct + ${2:-10})) ;;
down) pct=$((pct - ${2:-10})) ;;
set) pct=$2 ;;
get)
	echo "$pct%"
	exit 0
	;;
*)
	echo "usage: $0 up|down [step] | set <percent> | get" >&2
	exit 1
	;;
esac

((pct > 100)) && pct=100
((pct < 1)) && pct=1

busctl call org.freedesktop.login1 /org/freedesktop/login1/session/auto \
	org.freedesktop.login1.Session SetBrightness ssu backlight "$dev" $((pct * max / 100))
