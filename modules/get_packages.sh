#!/bin/bash

debian-packages() {
	$update
	$installer ${debianPackages[@]} ${debianNet[@]} ${debianUtils[@]} ${debianXFCE[@]} ${debianDev[@]} ${debianVirt[@]} ${debianAudio[@]} ${debianBrow[@]}
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
