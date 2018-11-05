#!/bin/sh
# this should run on the devices

_log() {
	echo "$@"
}

_log "disabled kernel messages"
dmesg -n 1

_log "cat /etc/openwrt_release"
cat /etc/openwrt_release
lava-test-case openwrt-version --result pass --measurement "$(cat /etc/openwrt_version)"
_log "list opkg installed packages"
opkg list_installed
