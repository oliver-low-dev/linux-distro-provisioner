#!/bin/bash


debian-repository() {

	local dir="/etc/apt/sources.list";

	local url="deb http://deb.debian.org/debian trixie main non-free-firmware"
	local apt=$(test -e "$dir" && cat "$dir" | grep -o "$url")

	if [ "$apt" == "$url" ]; then
		sed -i "s/http/https/" "$debiandir";
	else
		cat <<EOF > "$dir"
deb https://deb.debian.org/debian trixie main non-free-firmware
deb-src https://deb.debian.org/debian trixie main non-free-firmware

deb https://security.debian.org/debian-security trixie-security main non-free-firmware
deb-src https://security.debian.org/debian-security trixie-security main non-free-firmware

deb https://deb.debian.org/debian trixie-updates main non-free-firmware
deb-src https://deb.debian.org/debian trixie-updates main non-free-firmware
EOF
	fi
}

ubuntu-repository() {
	sed -i "s/http/https/" "/etc/apt/sources.list.d/ubuntu.sources";
}

case "$checkDistro" in
	"debian")
		debian-repository;
	;;
	"ubuntu")
		ubuntu-repository;
	;;
esac
