#!/bin/bash

gnome-interface() {
	gsettings;
}

kde-interface() {
	echo "";
}

xfce4-interface() {
	touch /home/$get_user/.Xauthority
}
