#!/usr/bin/env bash

mem="$(free | awk '/^Mem:/{print $2}')"
[ -z "$mem" ] && mem = 0
if "$mem"S -lt 10000000; then
	echo ""
	exit 1
fi