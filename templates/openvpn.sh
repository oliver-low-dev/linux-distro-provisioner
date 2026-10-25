#!/bin/bash

random=$(find "/etc/openvpn/client" -maxdepth 1 \( -name "*.conf" \) | shuf -n 1)
pass=$(find "/etc/openvpn/client" -maxdepth 1 \( -name "*.txt" \) | head -n 1)

if [ -z $random ]; then
	echo "Not OpenVPN config file found"
	exit 1
fi

openvpn --config $random --auth-user-pass $pass