#!/bin/bash
configure_systemd_resolved() {

	while [[ $# -gt 0 && ! "$1" =~ ^-- ]]
	do
		if [[ "$1" ]]; then
			CUSTOM_DNS="$1"
			shift
		fi
	done
}

export CUSTOM_DNS