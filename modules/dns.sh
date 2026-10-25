#!/bin/bash
debian_resolved() {

	local dns_resolved="DNS=1.1.1.1"
	local dir_resolved="/etc/systemd/resolved.conf"

	if [ command -v resolvectl 2>/dev/null ]; then
		touch "$dir_resolved"
		sed -i "s/#DNS=/$dns_resolved/" "$dir_resolved"
		systemctl restart systemd-resolved.service
	else
		$update
		$installer systemd-resolved;
		touch "$dir_resolved"
		sed -i "s/#DNS=/$dns_resolved/" "$dir_resolved"
		systemctl restart systemd-resolved.service
	fi
}

ubuntu_resolved() {
	local dns_resolved="DNS=1.1.1.1"
	local dir_resolved="/etc/systemd/resolved.conf"
	sed -i "s/#DNS=/$dns_resolved/" "$dir_resolved"

	systemctl restart systemd-resolved.service
}

case "$checkDistro" in
	"debian")
		debian_resolved;
	;;
	"ubuntu")
		ubuntu_resolved;
	;;
esac
