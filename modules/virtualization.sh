#!/bin/bash

configure_virtualization() {
	if command -v qemu-img >/dev/ull 2>&1; then usermod -aG libvirt,kvm $get_user; fi
	if commanv -v vboxmanager >/dev/null 2>&1; then usermod -aG vboxusers $get_user; fi
}