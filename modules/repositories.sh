#!/bin/bash


configure_debian_repository() {

	local file
	local files=(
		/etc/apt/sources.list{,.d/*.list}{,.d/*.sources}
	)

	for file in "$files"; do
		[[ -f "$file" ]] || continue

		sed -i -E "s/http:\/\/(deb\.debian\.org|security\.debian\.org)/https:\/\/\1/" "$files"

	done
}


configure_ubuntu_repository() {

	local file
	local files=(
		/etc/apt/sources.list{,.d/*.list}{,.d/*.sources}
	)

	for file in "${files[@]}"; do
		[[ -f "$file" ]] || continue

		sed -i -E "s/http:\/\/(archive\.ubuntu\.com|security\.ubuntu\.com|ports\.ubuntu\.com|mirrors\.ubuntu\.com)|https:\/\/\1/" \\
		"$files"

	done
}