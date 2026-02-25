#!/bin/bash

HOSTNAME=$(hostname)

# create vrf
ip link add vrf_prod type vrf table 1023
ip link set dev vrf_prod up

# create interfaces
ip link set dev eth1 down
ip link set dev eth2 down
ip link add dev bond0 type bond mode 802.3ad lacp_active on lacp_rate slow xmit_hash_policy layer3+4

# add bond members
ip link set dev eth1 master bond0
ip link set dev eth2 master bond0

# bond0 config
ip link set dev bond0 master vrf_prod
# s1 hosts
if [ "$HOSTNAME" == "s1-host1" ]; then
ip addr add 10.10.10.100/24 dev bond0
#
elif  [ "$HOSTNAME" == "s1-host2" ]; then
ip addr add 10.20.20.100/24 dev bond0
#
elif  [ "$HOSTNAME" == "s1-host3" ]; then
ip addr add 10.10.10.103/24 dev bond0
# s2 hosts
elif  [ "$HOSTNAME" == "s2-host1" ]; then
ip addr add 10.10.10.200/24 dev bond0
#
elif  [ "$HOSTNAME" == "s2-host2" ]; then
ip addr add 10.20.20.200/24 dev bond0
fi

# bring interfaces up
ip link set dev eth1 up
ip link set dev eth2 up
ip link set dev bond0 up

# add default route to vrf
if [[ "$HOSTNAME" == "s1-host1" || "$HOSTNAME" == "s2-host1" || "$HOSTNAME" == "s1-host3" ]]; then
ip route add default vrf vrf_prod via 10.10.10.1
elif  [[ "$HOSTNAME" == "s1-host2" || "$HOSTNAME" == "s2-host2" ]]; then
ip route add default vrf vrf_prod via 10.20.20.1
fi

