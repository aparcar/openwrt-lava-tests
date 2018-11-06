#!/bin/sh -e

# iperf.lava must be redirected to a iperf host in the same network
iperf -c iperf.lava -f m >/tmp/iperf.output 2>&1

cat /tmp/iperf.output
MBIT=$(tail -n1 /tmp/iperf.output | awk '{ print $7 }')

if echo "$MBIT" | cut -c1 | grep -q 0 ; then
    lava-test-case iperf-result --result fail --measurement "$MBIT" --units Mbits/sec
else
    lava-test-case iperf-result --result pass --measurement "$MBIT" --units Mbits/sec
fi

