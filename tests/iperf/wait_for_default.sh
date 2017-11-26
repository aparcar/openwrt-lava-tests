#!/bin/sh

while ! ip route show | grep default | grep pppoe  ; do
    echo waiting for default route via pppoe
    sleep 1
done
