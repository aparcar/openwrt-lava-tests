#!/bin/sh

iperf -c lunarius.fe80.eu -f m >/tmp/iperf.output 2>&1
cat /tmp/iperf.output
MBIT=$(tail -n1 /tmp/iperf.output | awk '{ print $7 }')

if echo "$MBIT" | cut -c1 | grep -q 0 ; then
    lava-test-case iperf-result --result fail --measurement "$MBIT"
else
    lava-test-case iperf-result --result pass --measurement "$MBIT"
fi

