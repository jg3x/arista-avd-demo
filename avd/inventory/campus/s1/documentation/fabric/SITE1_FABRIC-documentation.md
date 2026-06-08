# SITE1_FABRIC

## Table of Contents

- [Fabric Switches and Management IP](#fabric-switches-and-management-ip)
  - [Fabric Switches with inband Management IP](#fabric-switches-with-inband-management-ip)
- [Fabric Topology](#fabric-topology)
- [Fabric IP Allocation](#fabric-ip-allocation)
  - [Fabric Point-To-Point Links](#fabric-point-to-point-links)
  - [Point-To-Point Links Node Allocation](#point-to-point-links-node-allocation)
  - [Loopback Interfaces (BGP EVPN Peering)](#loopback-interfaces-bgp-evpn-peering)
  - [Loopback0 Interfaces Node Allocation](#loopback0-interfaces-node-allocation)
  - [VTEP Loopback VXLAN Tunnel Source Interfaces (VTEPs Only)](#vtep-loopback-vxlan-tunnel-source-interfaces-vteps-only)
  - [VTEP Loopback Node allocation](#vtep-loopback-node-allocation)

## Fabric Switches and Management IP

| POD | Type | Node | Management IP | Platform | Provisioned in CloudVision | Serial Number |
| --- | ---- | ---- | ------------- | -------- | -------------------------- | ------------- |
| SITE1_FABRIC | l3leaf | s1-brdr1 | 192.168.0.100/24 | cEOS | Provisioned | - |
| SITE1_FABRIC | l3leaf | s1-brdr2 | 192.168.0.101/24 | cEOS | Provisioned | - |
| SITE1_FABRIC | l3leaf | s1-leaf1 | 192.168.0.12/24 | 7050SX3 | Provisioned | - |
| SITE1_FABRIC | l3leaf | s1-leaf2 | 192.168.0.13/24 | 7050SX3 | Provisioned | - |
| SITE1_FABRIC | l3leaf | s1-leaf3 | 192.168.0.14/24 | 7050SX3 | Provisioned | - |
| SITE1_FABRIC | l3leaf | s1-leaf4 | 192.168.0.15/24 | 7050SX3 | Provisioned | - |
| SITE1_FABRIC | spine | s1-spine1 | 192.168.0.10/24 | cEOS | Provisioned | - |
| SITE1_FABRIC | spine | s1-spine2 | 192.168.0.11/24 | cEOS | Provisioned | - |
| SITE1_FABRIC | l2leaf | s1-wifi-gw1 | 192.168.0.102/24 | 7050SX3 | Provisioned | - |
| SITE1_FABRIC | l2leaf | s1-wifi-gw2 | 192.168.0.103/24 | 7050SX3 | Provisioned | - |

> Provision status is based on Ansible inventory declaration and do not represent real status from CloudVision.

### Fabric Switches with inband Management IP

| POD | Type | Node | Management IP | Inband Interface |
| --- | ---- | ---- | ------------- | ---------------- |

## Fabric Topology

| Type | Node | Node Interface | Peer Type | Peer Node | Peer Interface |
| ---- | ---- | -------------- | --------- | ----------| -------------- |
| l3leaf | s1-brdr1 | Ethernet1 | l2leaf | s1-wifi-gw1 | Ethernet1 |
| l3leaf | s1-brdr1 | Ethernet2 | l2leaf | s1-wifi-gw2 | Ethernet1 |
| l3leaf | s1-brdr1 | Ethernet49/1 | mlag_peer | s1-brdr2 | Ethernet49/1 |
| l3leaf | s1-brdr1 | Ethernet50/1 | mlag_peer | s1-brdr2 | Ethernet50/1 |
| l3leaf | s1-brdr1 | Ethernet51/1 | spine | s1-spine1 | Ethernet31/1 |
| l3leaf | s1-brdr1 | Ethernet52/1 | spine | s1-spine2 | Ethernet31/1 |
| l3leaf | s1-brdr2 | Ethernet1 | l2leaf | s1-wifi-gw1 | Ethernet2 |
| l3leaf | s1-brdr2 | Ethernet2 | l2leaf | s1-wifi-gw2 | Ethernet2 |
| l3leaf | s1-brdr2 | Ethernet51/1 | spine | s1-spine1 | Ethernet32/1 |
| l3leaf | s1-brdr2 | Ethernet52/1 | spine | s1-spine2 | Ethernet32/1 |
| l3leaf | s1-leaf1 | Ethernet49/1 | mlag_peer | s1-leaf2 | Ethernet49/1 |
| l3leaf | s1-leaf1 | Ethernet50/1 | mlag_peer | s1-leaf2 | Ethernet50/1 |
| l3leaf | s1-leaf1 | Ethernet51/1 | spine | s1-spine1 | Ethernet1/1 |
| l3leaf | s1-leaf1 | Ethernet52/1 | spine | s1-spine2 | Ethernet1/1 |
| l3leaf | s1-leaf2 | Ethernet51/1 | spine | s1-spine1 | Ethernet2/1 |
| l3leaf | s1-leaf2 | Ethernet52/1 | spine | s1-spine2 | Ethernet2/1 |
| l3leaf | s1-leaf3 | Ethernet49/1 | mlag_peer | s1-leaf4 | Ethernet49/1 |
| l3leaf | s1-leaf3 | Ethernet50/1 | mlag_peer | s1-leaf4 | Ethernet50/1 |
| l3leaf | s1-leaf3 | Ethernet51/1 | spine | s1-spine1 | Ethernet3/1 |
| l3leaf | s1-leaf3 | Ethernet52/1 | spine | s1-spine2 | Ethernet3/1 |
| l3leaf | s1-leaf4 | Ethernet51/1 | spine | s1-spine1 | Ethernet4/1 |
| l3leaf | s1-leaf4 | Ethernet52/1 | spine | s1-spine2 | Ethernet4/1 |
| l2leaf | s1-wifi-gw1 | Ethernet49/1 | mlag_peer | s1-wifi-gw2 | Ethernet49/1 |
| l2leaf | s1-wifi-gw1 | Ethernet50/1 | mlag_peer | s1-wifi-gw2 | Ethernet50/1 |

## Fabric IP Allocation

### Fabric Point-To-Point Links

| Uplink IPv4 Pool | Available Addresses | Assigned addresses | Assigned Address % |
| ---------------- | ------------------- | ------------------ | ------------------ |
| 172.16.1.0/24 | 256 | 24 | 9.38 % |

### Point-To-Point Links Node Allocation

| Node | Node Interface | Node IP Address | Peer Node | Peer Interface | Peer IP Address |
| ---- | -------------- | --------------- | --------- | -------------- | --------------- |
| s1-brdr1 | Ethernet51/1 | 172.16.1.17/31 | s1-spine1 | Ethernet31/1 | 172.16.1.16/31 |
| s1-brdr1 | Ethernet52/1 | 172.16.1.19/31 | s1-spine2 | Ethernet31/1 | 172.16.1.18/31 |
| s1-brdr2 | Ethernet51/1 | 172.16.1.21/31 | s1-spine1 | Ethernet32/1 | 172.16.1.20/31 |
| s1-brdr2 | Ethernet52/1 | 172.16.1.23/31 | s1-spine2 | Ethernet32/1 | 172.16.1.22/31 |
| s1-leaf1 | Ethernet51/1 | 172.16.1.1/31 | s1-spine1 | Ethernet1/1 | 172.16.1.0/31 |
| s1-leaf1 | Ethernet52/1 | 172.16.1.3/31 | s1-spine2 | Ethernet1/1 | 172.16.1.2/31 |
| s1-leaf2 | Ethernet51/1 | 172.16.1.5/31 | s1-spine1 | Ethernet2/1 | 172.16.1.4/31 |
| s1-leaf2 | Ethernet52/1 | 172.16.1.7/31 | s1-spine2 | Ethernet2/1 | 172.16.1.6/31 |
| s1-leaf3 | Ethernet51/1 | 172.16.1.9/31 | s1-spine1 | Ethernet3/1 | 172.16.1.8/31 |
| s1-leaf3 | Ethernet52/1 | 172.16.1.11/31 | s1-spine2 | Ethernet3/1 | 172.16.1.10/31 |
| s1-leaf4 | Ethernet51/1 | 172.16.1.13/31 | s1-spine1 | Ethernet4/1 | 172.16.1.12/31 |
| s1-leaf4 | Ethernet52/1 | 172.16.1.15/31 | s1-spine2 | Ethernet4/1 | 172.16.1.14/31 |

### Loopback Interfaces (BGP EVPN Peering)

| Loopback Pool | Available Addresses | Assigned addresses | Assigned Address % |
| ------------- | ------------------- | ------------------ | ------------------ |
| 10.250.1.0/24 | 256 | 8 | 3.13 % |

### Loopback0 Interfaces Node Allocation

| POD | Node | Loopback0 |
| --- | ---- | --------- |
| SITE1_FABRIC | s1-brdr1 | 10.250.1.7/32 |
| SITE1_FABRIC | s1-brdr2 | 10.250.1.8/32 |
| SITE1_FABRIC | s1-leaf1 | 10.250.1.3/32 |
| SITE1_FABRIC | s1-leaf2 | 10.250.1.4/32 |
| SITE1_FABRIC | s1-leaf3 | 10.250.1.5/32 |
| SITE1_FABRIC | s1-leaf4 | 10.250.1.6/32 |
| SITE1_FABRIC | s1-spine1 | 10.250.1.1/32 |
| SITE1_FABRIC | s1-spine2 | 10.250.1.2/32 |

### VTEP Loopback VXLAN Tunnel Source Interfaces (VTEPs Only)

| VTEP Loopback Pool | Available Addresses | Assigned addresses | Assigned Address % |
| ------------------ | ------------------- | ------------------ | ------------------ |
| 10.255.1.0/24 | 256 | 6 | 2.35 % |

### VTEP Loopback Node allocation

| POD | Node | Loopback1 |
| --- | ---- | --------- |
| SITE1_FABRIC | s1-brdr1 | 10.255.1.7/32 |
| SITE1_FABRIC | s1-brdr2 | 10.255.1.7/32 |
| SITE1_FABRIC | s1-leaf1 | 10.255.1.3/32 |
| SITE1_FABRIC | s1-leaf2 | 10.255.1.3/32 |
| SITE1_FABRIC | s1-leaf3 | 10.255.1.5/32 |
| SITE1_FABRIC | s1-leaf4 | 10.255.1.5/32 |
