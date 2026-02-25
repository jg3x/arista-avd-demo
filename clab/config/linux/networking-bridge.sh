#!/bin/bash

HOSTNAME=$(hostname)

# create vrf
ip link add vrf_prod type vrf table 1023
ip link set dev vrf_prod up

# create interfaces
ip link set dev eth1 down
ip link set dev eth2 down
ip link add dev bridge0 type bridge stp_state 0 vlan_filtering 1

# add bond members
ip link set dev eth1 master bridge0
ip link set dev eth2 master bridge0

# vlan10 config
bridge vlan add dev bridge0 vid 10 self # enables the host stack to use vlan 10 (like an SVI) on bridge0
bridge vlan add vid 10 dev eth1 # allows receiving and sending tagged frames on this interface
bridge vlan add vid 10 dev eth2
ip link add link bridge0 name vlan10 type vlan id 10
# s1 hosts
if [ "$HOSTNAME" == "s1-host4" ]; then
ip addr add 10.10.10.104/24 dev vlan10
ip link set dev vlan10 master vrf_prod
fi

# bring interfaces up
ip link set dev eth1 up
ip link set dev eth2 up
ip link set dev bridge0 up
ip link set vlan10 up

# add default route to vrf
if [[ "$HOSTNAME" == "s1-host4" ]]; then
ip route add default vrf vrf_prod via 10.10.10.1
fi

