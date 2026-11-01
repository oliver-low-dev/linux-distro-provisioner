#!/bin/bash

OPENVPN_SCRIPT_FILE="/usr/local/bin/openvpn.sh"
OPENVPN_CONFIG_DIR="/etc/openvpn/client/"
WIREGUARD_SCRIPT_FILE="/usr/local/bin/wireguard.sh"
WIREGUARD_CONFIG_DIR="/etc/wireguard/client/"


if ! [ -d "$OPENVPN_CONFIG_DIR" ]; then
	mkdir -p "$OPENVPN_CONFIG_DIR";
	chmod  700 "$OPENVPN_CONFIG_DIR"
fi

if ! [ -d "$WIREGUARD_CONFIG_DIR" ]; then
	mkdir -p "$WIREGUARD_CONFIG_DIR";
	chmod 700 "$WIREGUARD_CONFIG_DIR"
fi

if ! [ -e "$OPENVPN_SCRIPT_FILE" ]; then
	touch "$OPENVPN_SCRIPT_FILE"
fi

if ! [ -e "$WIREGUARD_SCRIPT_FILE" ]; then
	touch "$WIREGUARD_SCRIPT_FILE"
fi