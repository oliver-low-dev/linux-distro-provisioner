#!/bin/bash

tmp_file="/tmp/wg_current.conf"

if [ -f "$tmp_file" ]; then
	wg-quick down "$tmp_file" 2>/dev/null
fi

random=$(find "/etc/wireguard/client" -maxdepth 1 \( -name "*.conf" -o -name "*.wg" \) | shuf -n 1)

if [ -z "$random" ]; then
	echo "No WireGuard config file found"
	exit 1;
fi

cp "$random" "$tmp_file"

wg-quick up $random