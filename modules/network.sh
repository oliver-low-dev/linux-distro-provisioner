#!/bin/bash

debian-network() {

	cat <<EOF > /etc/network/interfaces
auto lo
iface lo inet loopback

allow-hotplug enp2s0
iface enp2s0 inet static
	address 192.168.3.2
	netmask 255.255.255.0
	gateway 192.168.3.1
EOF

echo "nameserver 1.1.1.1" > /etc/resolv.conf

systemctl restart networking.service

}

ubuntu-network() {
	nmcli connection show || true
	nmcli connection modify Wired\ \Connection\ \1 ipv4.ip.address "192.168.3.2"
	nmcli connection modify Wired\ \Connection\ \1 ipv4.ip.netmask "255.255.255.0"
	nmcli connection modify Wired\ \Connection\ \1 ipv4.ip.gateway "192.168.3.1"
	nmcli connection modify Wired\ \Connection\ \1 ipv4.dns "1.1.1.1"
}

archlinux-network() {
	if command -v nmcli 2&> /etc/null; then
		nmcli connection show || true
		nmcli connection modify Wired\ \Connection\ \1 ipv4.ip.address "192.168.3.2"
		nmcli connection modify Wired\ \Connection\ \1 ipv4.ip.netmask "255.255.255.0"
		nmcli connection modify Wired\ \Connection\ \1 ipv4.ip.gateway "192.168.3.1"
		nmcli connection modify Wired\ \Connection\ \1 ipv4.dns "1.1.1.1"
	else
		cat <<EOF > /etc/systemd/network/20-wired.network
[match]
Name=enp2s0

[Network]
DHCP=yes
EOF
	fi
}

case "$checkDistro" in
	"debian")
		debian-network;
	;;
	"ubuntu")
		ubuntu-network;
	;;
	"fedora")
		fedora-network;
	;;
	"archlinux")
		archlinux-network;
	;;
esac
