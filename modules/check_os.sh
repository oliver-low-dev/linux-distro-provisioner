#!/bin/bash

if ! [[ -r /etc/os-release ]]; then
	echo "Cannot identify the Linux distrubution." >&2
	exit 1
fi

source /etc/os-release

case "$ID" in
        debian)
			CHECK_DISTRO="debian"

			PACKAGE_MANAGER="apt"

			CONFIG_NETWORK_DIR="/etc/network"
			CONFIG_NETWORK_FILE="$CONFIG_NETWORK_DIR/interfaces"
			CONFIG_DNS_DIR="/etc/resolv.conf"
			CONFIG_SYSTEMD_RESOLVED_DIR="/etc/systemd/resolved.conf"
			CONFIG_SYSTEMD_RESOLVED_CUSTOM_DIR="/etc/systemd/resolved.conf.d"
			CONFIG_SYSTEMD_RESOLVED_CUSTOM_FILE="/etc/systemd/resolved.conf.d/dns_servers.conf"

			SYSTEMD_RESOLVED_CONFIGURATION=$( echo -e "[Resolve]\nDNS=$CUSTOM_DNS" > \
			$CONFIG_SYSTEMD_RESOLVED_CUSTOM_FILE)

			NETWORK_SERVICE_NAME="networking.service"
            ;;
        ubuntu | linuxmint)
            CHECK_DISTRO="ubuntu"

            PACKAGE_MANAGER="apt"

			CONFIG_NETWORK_DIR="/etc/network"
			CONFIG_NETWORK_FILE="$CONFIG_NETWORK_DIR/interfaces"
			CONFIG_DNS_DIR="/etc/resolv.conf"
			CONFIG_SYSTEMD_RESOLVED_DIR="/etc/systemd/resolved.conf"

			CONFIG_SYSTEMD_RESOLVED_CUSTOM_DIR="/etc/systemd/resolved.conf.d/dns_servers.conf"

			NETWORK_SERVICE_NAME="networking.service"
            ;;
        fedora)
            CHECK_DISTRO="fedora"

            PACKAGE_MANAGER="dnf"

			CONFIG_NETWORK_DIR=""
			CONFIG_NETWORK_FILE="$CONFIG_NETWORK_DIR"
			CONFIG_DNS_DIR=""
			CONFIG_SYSTEMD_RESOLVED_DIR=""
			NETWORK_SERVICE_NAME=""
            ;;
        arch)
            CHECK_DISTRO="archlinux"

            PACKAGE_MANAGER="pacman"

			CONFIG_NETWORK_DIR="/etc/systemd/networkd"
			CONFIG_NETWORK_FILE="$CONFIG_NETWORK_DIR/20-wired.network"
			CONFIG_DNS_DIR="/etc/resolv.conf"
			CONFIG_SYSTEMD_RESOLVED_DIR="/etc/systemd/resolved.conf"

			CONFIG_SYSTEMD_RESOLVED_CUSTOM_DIR="/etc/systemd/resolved.conf.d/dns_servers.conf"

			NETWORK_SERVICE_NAME="systemd-networkd.service"
            ;;
        *)
			case " ${ID_LIKE:-} " in
            	*" ubuntu "*|*" debian "*)
                	check_distro="ubuntu"
                    ;;
				*)
                	echo "Unsupported distribution: ${ID:-unknown}" >&2
                    exit 1
                    ;;
			esac
            ;;
esac

case "$PACKAGE_MANAGER" in
	"apt")
		PKG_UPDATE() { apt update -y; }
		PKG_UPGRADE() { apt upgrade -y; }
		PKG_INSTALL="apt-get install -y"
	;;
	"dnf")
		PKG_UPDATE() { dnf makecache; }
		PKG_UPGRADE() { dnf update -y; }
		PKG_INSTALL() { dnf install -y; }
	;;
	"pacman")
		PKG_UPDATE() { pacman -Syy --noconfirm; }
		PKG_UPGRADE() { pacman -Syyu --noconfirm; }
		PKG_INSTALL() { pacman -S --noconfirm --needed; }
	;;
esac