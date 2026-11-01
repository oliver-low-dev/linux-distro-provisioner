#!/bin/bash

install_packages() {

	#local category="$1"
	local -a packages=()

	if ! command -v jq >/dev/null 2>&1; then $PKG_INSTALL jq; fi

	while [[ $# -gt 0 && ! "$1" =~ ^-- ]]
	do
		if [[ "$1" == "default" ]]; then
			DEFAULT_PACKAGES=true
			shift
		else
			PACKAGES_TO_INSTALL+=("$1")
			shift
		fi
	done

}

export DEFAULT_PACKAGES