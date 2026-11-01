#!/bin/bash

if [ -z "${BASH_VERSION:-}" ]; then
        echo "This Script mus be run with Bash, not sh." >&2
        exit 1
fi

set -eo pipefail

if (( $EUID != 0 )); then
        echo "This script must to be run as root. 'sudo bash $0'"
        exit 1
fi

mem="$(free | awk '/^Mem:/{print $2}')"
[ -z "$mem" ] && mem = 0
if [[ $mem -lt 1000000 ]]; then echo "To run this script the system needs more than 1024MB of memory"; exit 1; fi

get_user="${SUDO_USER:-root}"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
JSON_FILE="${SCRIPT_DIR}/data/packages.json"

source "$SCRIPT_DIR/modules/check_os.sh"
source "$SCRIPT_DIR/modules/mod_network.sh"
source "$SCRIPT_DIR/modules/install_packages.sh"
source "$SCRIPT_DIR/modules/mod_dns.sh"
source "$SCRIPT_DIR/modules/mod_vpn.sh"
source "$SCRIPT_DIR/modules/virtualization.sh"


DHCP_ENABLED=false
NETWORKMANAGER_ENABLED=false
STATIC_ENABLED=false



while [[ $# -gt 0 ]]
do
    case "$1" in
        "--dhcp")
            DHCP_ENABLED=true
            shift

            dhcp_flags "$@"

            if [[ -n "$INTERFACE" ]]; then shift 2; fi
            continue
            ;;
        "--static")
            STATIC_ENABLED=true
            shift

            static_flags "$@"

            if [[ -n "$ADDRESS" ]]; then shift 2; fi
            continue
            ;;
        "--network-manager")
            NETWORKMANAGER_ENABLED=true
            shift

            continue
            ;;
        "--packages")
            SELECT_PACKAGES=true
            shift

            install_packages "$@"

            if [[ -n "$PACKAGES" ]]; then shift 2; fi

            continue
            ;;
        "--systemd-resolved")
            SYSTEMD_RESOLVED_ENABLED=true
            shift

            configure_systemd_resolved "$@"
            ;;
        "--vm")
            shift

            configure_virtualization "$@"
            ;;
    esac
    shift
done

echo "DHCP está ativo? $DHCP_ENABLED na interface "$INTERFACE
echo "Estático está ativo? $STATIC_ENABLED na interface $INTERFACE"
echo "$ADDRESS $NETMASK $GATEWAY $DNS" 


echo "--- Initial System Configuration ---"

if [ "$NETWORKMANAGER_ENABLED" = true ]; then
    echo "Appling setting via Network Manager (nmcli)..."

    if [ "$STATIC_ENABLED" = true ]; then
        systemctl enable --now NetworkManager.service
        nmcli connection show || true
        nmcli connection modify "$INTERFACE" ipv4.ip.address "$ADDRESS"
        nmcli connection modify "$INTERFACE" ipv4.ip.netmask "$NETMASK"
        nmcli connection modify "$INTERFACE" ipv4.ip.gateway "$GATEWAY"
        nmcli connection modify "$INTERFACE" ipv4.dns "$DNS"
        echo "Command: nmcli setup IP $ADDRESS in interface $INTERFACE"
        systemctl restart NetworkManager.service
    elif [ "$DHCP_ENABLED" = true ]; then
        systemctl enable --now NetworkManager.service
        nmcli connection show || true
        systemctl restart NetworkManager.service
        echo "Command: nmcli setup DHCP in interface "$INTERFACE""
    fi

else

    if [ "$STATIC_ENABLED" = true ]; then
        ip addr add $ADDRESS dev $INTERFACE
        echo "Command: ip addr add $ADDRESS dev $INTERFACE"
    elif [ "$DHCP_ENABLED" = true ]; then
        echo "DHCP Enabled"
    fi

    if [ -n "$DNS" ]; then
        echo "Updating DNS $CONFIG_DNS_DIR with the DNS $DNS"
    fi

fi

echo "--- Custom DNS Configuration ---"
if [ "$SYSTEMD_RESOLVED_ENABLED" = true ]; then
    mkdir -p "$CONFIG_SYSTEMD_RESOLVED_CUSTOM_DIR"
    #$SYSTEMD_RESOLVED_CONFIGURATION
    
    echo "Setting up systemd-resolved with DNS $CUSTOM_DNS"

    echo -e "[Resolve]\nDNS=$CUSTOM_DNS" > \
    $CONFIG_SYSTEMD_RESOLVED_CUSTOM_FILE
    systemctl restart systemd-resolved.service
fi


echo "--- VPN Configuration ---"

chmod +x "$OPENVPN_SCRIPT_FILE"
install -m 644 "$SCRIPT_DIR/templates/openvpn.service" /etc/systemd/system/openvpn.service
cp "$SCRIPT_DIR/templates/openvpn.sh" "$OPENVPN_SCRIPT_FILE"
chmod +x "$WIREGUARD_SCRIPT_FILE"
systemctl daemon-reload

chmod +x "$WIREGUARD_SCRIPT_FILE"
install -m 644 "$SCRIPT_DIR/templates/wireguard.service" /etc/systemd/system/wireguard.service
cp "$SCRIPT_DIR/templates/wireguard.sh" "$WIREGUARD_SCRIPT_FILE"
chmod +x "$WIREGUARD_SCRIPT_FILE"
systemctl daemon-reload

echo "--- Packages Configuration ---"

if [ "$DEFAULT_PACKAGES" = true ]; then
    echo "Updating Repositories"
    $PKG_UPDATE

    category=(core network security hardened development virtualization graphical-interface graphical-engine audio)

    for i in "${category[@]}"
    do
        mapfile -t packages < <(
            jq -r --arg distro "$CHECK_DISTRO" \
            --arg cat "$i" \
            '.distro[$distro] | getpath($cat | split(".")) | [.. | arrays | .[] | strings] | unique[]' \
            "$JSON_FILE"
        )
        if [[ ${#packages} -gt 0 ]]; then
            echo "Installing following packages ${packages[@]}"
            echo  "installing packages category $i"

            $PKG_INSTALL "${packages[@]}"
        else
            echo "Not found packages in category $i"
        fi
    done
    echo "All packages installed!"
else
    if [ ${#PACKAGES_TO_INSTALL[@]} -gt 0 ]; then
        echo "Updating Repositories"
        $PKG_UPDATE

        echo "Installing following packages ${PACKAGES_TO_INSTALL[@]}"

        $PKG_INSTALL ${PACKAGES_TO_INSTALL[@]}

        echo "All packages installed!"
    fi
fi