dhcp_flags() {
	while [[ $# -gt 0 && ! "$1" =~ ^-- ]]
	do
		case "$1" in
    		-i)
        		INTERFACE="$2"
            	shift 2
            	;;
        	-dns)
	        	DNS="$2"
    	    	shift 2
        		;;
        *)
        	echo "Invalid DHCP Option"
        	exit 1
        	;;
    	esac
	done

	export INTERFACE
	export DNS

}

static_flags() {
	while [[ $# -gt 0 && ! "$1" =~ ^-- ]]
	do
		case "$1" in
			-i)
				INTERFACE="$2"
				shift 2
				;;
			-ip)
				ADDRESS="$2"
				shift 2
				;;
			-mask)
				NETMASK="$2"
				shift 2
				;;
			-gw)
				GATEWAY="$2"
				shift 2;
				;;
			-dns)
				DNS="$2"
				shift 2;
				;;
			*)
				echo "Invalid Static option"
				exit 1
				;;
		esac
	done
}

network_manager_flags() {
	while [[ $# -gt 0 && ! "$1" =~ ^-- ]]
	do
		case "$1" in
			--network-manager);;
		esac
	done
}