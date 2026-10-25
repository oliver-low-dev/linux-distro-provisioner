#!/bin/bash

case "$checkDistro" in
	"debian" | "ubuntu" | "linux mint")
		update="apt update -y";
		upgrade="apt upgrade -y";
		installer="apt install -y";
	;;
	"fedora")
		update="dnf update -y";
		installer="dnf install -y";
	;;
	"archlinux")
		update="pacman -Sy --noconfirm"
		installer="pacman -S --noconfirm";
	;;
esac
