#!/bin/bash

debian-packages() {
	$update
<<<<<<< HEAD
	category=(core network security virtualization)
	for i in "${category[@]}"
	do
	mapfile -t packages < <(
		jq -r --arg distro "$checkDistro" --arg cat "$i" '.distro[$distro] | \
		getpath($cat | split(".")) | [.. | arrays | .[] | strings | unique[]' ../data/packages.json
	)
	$installer "${packages[@]}"
	done
=======
	$installer cat $SCRIPT_DIR/data/packages.json | jq '.Packages.distro.debian.core'
>>>>>>> df4c4d8 (Restrucutre of script)
	$upgrade
}

ubuntu-packages() {
	$update && $installer $ubuntuPackages $debianNet $debianUtils $debianGnome $debianDev $debianVirt $debianAudio $debianBrow && $upgrade
}

fedora-packages() {
	$installer $fedoraPackages $fedoraNet $fedoraUtils $fedoraGnome $fedoraDev $fedoraVirt $fedoraAudio $fedoraBrow
}

archlinux-packages() {
	$update
	$installer $archlinuxPackages $archlinuxNet $archlinuxUtils $archlinuxGnome $archlinuxDev $archlinuxVirt $archlinuxAudio $archlinuxBrow
}

case "$checkDistro" in
	"debian")
		debian-packages;
	;;
	"ubuntu")
		ubuntu-packages;
	;;
	"fedora")
		fedora-packages;
	;;
	"archlinux")
		archlinux-packages;
	;;
esac
