#!/bin/bash

debian-qemu() {
	usermod -aG libvirt,kvm $get_user
	#qemu-img create -f qcow2 vpn.qcow2 10240
	#if [ -e $iso_image && sha256sum $iso_image == $iso_sha ]; then
	#	wget -t 99999 -c "";
	#fi
	#qemu-system-x86 -enable-kvm -cpu host -m 1024 -smp 1 -drive file=vpn.qcow2,format=qcow2 -cdrom $iso_image -boot d -netdev user,id=net0,net=192.168.10.1/24,dhcpstart=192.168.10.1 -device virtio-net-pci,netdev=net0 -vga qxl -device AC97
}

archlinux-qemu() {
	usermod -aG libvirt,kvm $get_user
}

case "$checkDistro" in
	"debian" | "ubuntu" | "linux mint")
		debian-qemu;
	;;
	"fedora")
		fedora-qemu;
	;;
	"archlinux")
		archlinux-qemu;
	;;
esac
