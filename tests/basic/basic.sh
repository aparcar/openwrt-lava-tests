#!/bin/sh
# this should run on the devices

_log() {
	echo "$@"
}

_log "disabled kernel messages"
dmesg -n 1

_log "list opkg installed packages"
opkg list_installed
