#!/bin/bash

set -e

if [ "$(id -u)" != 0 ]; then
        echo "This script must to be run as root. 'sudo bash $0'"
        exit 1
fi

if readlink /proc/$$/exe | grep -qs "dash"; then
        echo "This script needs to be run with bash, not sh"
        exit 1
fi

get_user=$(logname)
checkDistro=$(cat /etc/*-release | tr [:upper:] [:lower:] | grep -Poi '(debian|ubuntu|linux mint|fedora|archlinux)' | uniq)

. ./database/packages.conf

. ./modules/network.sh
. ./modules/packages_manager.sh
. ./modules/repositories.sh
. ./modules/dns.sh
. ./modules/get_packages.sh
. ./modules/graphical_interface.sh
. ./modules/vpn.sh
. ./modules/qemu.sh
