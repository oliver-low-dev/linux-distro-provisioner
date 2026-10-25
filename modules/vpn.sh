#!/bin/bash

openvpn_dir="/usr/local/sbin/"
openvpn_file="/usr/local/sbin/openvpn.sh"
openvpn_service="/etc/systemd/system/openvpn.service"
wireguard_dir="/usr/local/sbin/"
wireguard_file="/usr/local/sbin/wireguard.sh"
wireguard_service="/etc/systemd/system/wireguard.service"

if ! [ -d "$openvpn_dir" ]; then
	mkdir -p "$openvpn_dir";
fi
if ! [ -d "$wireguard_dir" ]; then
	mkdir -p "$wireguard_dir";
fi

openvpn_config() {
cat <<EOF > "$openvpn_file"
#!/bin/bash

random=\$(ls /home/$get_user/vpn/ | grep .ovpn | shuf -n 1)
pass=\$(ls /home/$get_user/vpn/ | grep .txt)

openvpn --config \$random --auth-user-pass \$pass
EOF

chmod +x "$openvpn_file"

cat <<EOF > "$openvpn_service"
[Unit]
Description="openvpn"
After=network.target
StartLimitIntervalSec=5

[Service]
ExecStart=$openvpn_file

[Install]
WantedBy=default.target
EOF

systemctl daemon-reload && systemctl disable openvpn.service

}

wireguard_config() {
cat <<EOF > "$wireguard_file"
#!/bin/bash

name=\$(cat tmp.txt)

wg quick down \$name

random=\$(ls /home/$get_user/vpn | grep .wg | shuf -n 1)
pass=\$(ls /home/$get_user/vpn | grep .txt)
disconnect=\$(cat \$random > tmp.txt)

wg-quick up \$random
EOF

chmod +x "$wireguard_file"

cat <<EOF > "$wireguard_service"
[Unit]
Description="wireguard"
After=network.target
StartLimitIntervalSec=5

[Service]
ExecStart=$wireguard_file

[Install]
WantedBy=default.target
EOF

systemctl daemon-reload && systemctl disable wireguard.service
}

case "$checkDistro" in
	"debian" | "ubuntu" | "linux mint")
		openvpn_config;
		wireguard_config;
	;;
esac
