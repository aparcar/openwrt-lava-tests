#!/bin/sh
# this should run on the devicea

_log() {
	echo "$@"
}

check_rules() {
	case=$1
	rule=$2

	if ! ip rule show |grep "$rule" ; then
		_log "$case Can not find rule $rule"
		lava-test-case netifd-enabled --result failure
		exit 1
	fi
}

LANIP=192.168.91.1
LANNET=192.168.91.0

_log "disabled kernel messages"
dmesg -n 1

_log "cat /etc/openwrt_release"
cat /etc/openwrt_release
_log "opkg netifd package:"
opkg list_installed |grep netifd

uci show
uci set network.lan.enabled=1
uci set network.lan.ipaddr=$LANIP
ubus call network reload

# check if lan address is assigned
if ! ip -o a show | grep "inet $LANIP" ; then
    _log "$LANIP is not bind to any interface"
	lava-test-case netifd-enabled --result failure
    exit 1
fi

if ! ip route show | grep "$LANNET" ; then
    _log "$LANNET is not in the routing table"
	lava-test-case netifd-enabled --result failure
    exit 1
fi

# disable the network
uci set network.lan.enabled=0
ubus call network reload

sleep 3

# enable again
uci set network.lan.enabled=1
ubus call network reload

# check if lan address is assigned
if ! ip -o a show | grep "inet $LANIP" ; then
    _log "$LANIP Test: is not bind to any interface"
	lava-test-case netifd-enabled --result failure
    exit 1
fi

if ! ip route show | grep "$LANNET" ; then
    _log "$LANNET Test: is not in the routing table"
	lava-test-case netifd-enabled --result failure
    exit 1
fi

_log "adding rules"
uci set network.guestable=rule
uci set network.guestable.in=lan
uci set network.guestable.lookup='1001'
uci set network.guestable.priority='100'
uci set network.unreach=rule
uci set network.unreach.in=lan
uci set network.unreach.action='unreachable'
uci set network.unreach.priority='110'
ubus call network reload
sleep 5

_log "check if rules appear"
ip rule show
check_rules rules "^100:"
check_rules rules "^110:"

_log "reloading netifd with lan.enabled=0"
uci set network.lan.enabled=0
ubus call network reload
sleep 5

_log "check if rule NOT appear"
if ip rule show |grep -q '^100:' ; then
	lava-test-case netifd-enabled --result failure
	exit 1
fi
if ip rule show |grep -q '^110:' ; then
	lava-test-case netifd-enabled --result failure
	exit 1
fi

_log "reloading netifd with lan.enabled=1"
uci set network.lan.enabled=1
ubus call network reload
sleep 5

_log "check if rules appear after reloading with enabled"
ip rule show
check_rules rules "^100:"
check_rules rules "^110:"

lava-test-case netifd-enabled --result pass
