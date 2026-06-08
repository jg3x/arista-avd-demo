# s2-leaf3

## Table of Contents

- [Management](#management)
  - [Management Interfaces](#management-interfaces)
  - [IP Name Servers](#ip-name-servers)
  - [NTP](#ntp)
  - [Management API gNMI](#management-api-gnmi)
  - [Management API HTTP](#management-api-http)
- [Authentication](#authentication)
  - [Local Users](#local-users)
  - [Enable Password](#enable-password)
  - [AAA Authorization](#aaa-authorization)
- [Monitoring](#monitoring)
  - [TerminAttr Daemon](#terminattr-daemon)
  - [Flow Tracking](#flow-tracking)
- [MLAG](#mlag)
  - [MLAG Summary](#mlag-summary)
  - [MLAG Device Configuration](#mlag-device-configuration)
- [Spanning Tree](#spanning-tree)
  - [Spanning Tree Summary](#spanning-tree-summary)
  - [Spanning Tree Device Configuration](#spanning-tree-device-configuration)
- [Internal VLAN Allocation Policy](#internal-vlan-allocation-policy)
  - [Internal VLAN Allocation Policy Summary](#internal-vlan-allocation-policy-summary)
  - [Internal VLAN Allocation Policy Device Configuration](#internal-vlan-allocation-policy-device-configuration)
- [VLANs](#vlans)
  - [VLANs Summary](#vlans-summary)
  - [VLANs Device Configuration](#vlans-device-configuration)
- [Interfaces](#interfaces)
  - [Ethernet Interfaces](#ethernet-interfaces)
  - [Port-Channel Interfaces](#port-channel-interfaces)
  - [Loopback Interfaces](#loopback-interfaces)
  - [VLAN Interfaces](#vlan-interfaces)
  - [VXLAN Interface](#vxlan-interface)
- [Routing](#routing)
  - [Service Routing Protocols Model](#service-routing-protocols-model)
  - [Virtual Router MAC Address](#virtual-router-mac-address)
  - [IP Routing](#ip-routing)
  - [IPv6 Routing](#ipv6-routing)
  - [Static Routes](#static-routes)
  - [Router BGP](#router-bgp)
- [BFD](#bfd)
  - [Router BFD](#router-bfd)
- [Multicast](#multicast)
  - [IP IGMP Snooping](#ip-igmp-snooping)
- [Filters](#filters)
  - [Prefix-lists](#prefix-lists)
  - [Route-maps](#route-maps)
- [VRF Instances](#vrf-instances)
  - [VRF Instances Summary](#vrf-instances-summary)
  - [VRF Instances Device Configuration](#vrf-instances-device-configuration)

## Management

### Management Interfaces

#### Management Interfaces Summary

##### IPv4

| Management Interface | Description | Type | VRF | IP Address | Gateway |
| -------------------- | ----------- | ---- | --- | ---------- | ------- |
| Management1 | OOB_MANAGEMENT | oob | mgmt | 192.168.0.24/24 | 192.168.0.1 |

##### IPv6

| Management Interface | Description | Type | VRF | IPv6 Address | IPv6 Gateway |
| -------------------- | ----------- | ---- | --- | ------------ | ------------ |
| Management1 | OOB_MANAGEMENT | oob | mgmt | - | - |

#### Management Interfaces Device Configuration

```eos
!
interface Management1
   description OOB_MANAGEMENT
   no shutdown
   vrf mgmt
   ip address 192.168.0.24/24
```

### IP Name Servers

#### IP Name Servers Summary

| Name Server | VRF | Priority |
| ----------- | --- | -------- |
| 8.8.8.8 | mgmt | 0 |

#### IP Name Servers Device Configuration

```eos
ip name-server vrf mgmt 8.8.8.8 priority 0
```

### NTP

#### NTP Summary

##### NTP Servers

| Server | VRF | Preferred | Burst | iBurst | Version | Min Poll | Max Poll | Local-interface | Key |
| ------ | --- | --------- | ----- | ------ | ------- | -------- | -------- | --------------- | --- |
| time1.google.com | mgmt | - | - | True | - | - | - | - | - |
| time2.google.com | mgmt | - | - | True | - | - | - | - | - |

#### NTP Device Configuration

```eos
!
ntp server vrf mgmt time1.google.com iburst
ntp server vrf mgmt time2.google.com iburst
```

### Management API gNMI

#### Management API gNMI Summary

| Transport | SSL Profile | VRF | Notification Timestamp | ACL | Port | Authorization Requests |
| --------- | ----------- | --- | ---------------------- | --- | ---- | ---------------------- |
| default | - | mgmt | last-change-time | - | 6030 | - |

#### Management API gNMI Device Configuration

```eos
!
management api gnmi
   transport grpc default
      port 6030
      vrf mgmt
```

### Management API HTTP

#### Management API HTTP Summary

| HTTP | HTTPS | UNIX-Socket | Default Services |
| ---- | ----- | ----------- | ---------------- |
| False | True | - | - |

#### Management API VRF Access

| VRF Name | IPv4 ACL | IPv6 ACL |
| -------- | -------- | -------- |
| mgmt | - | - |

#### Management API HTTP Device Configuration

```eos
!
management api http-commands
   protocol https
   no shutdown
   !
   vrf mgmt
      no shutdown
```

## Authentication

### Local Users

#### Local Users Summary

| User | Privilege | Role | Disabled | Shell |
| ---- | --------- | ---- | -------- | ----- |
| admin | 15 | network-admin | False | - |

#### Local Users Device Configuration

```eos
!
username admin privilege 15 role network-admin secret sha512 <removed>
username admin ssh-key ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBMq7V3lWrRkB0w63hdbG4gEZ8KuLFwf7cRv/3ln9GOU9nZhrfRHvLSRj9c07DvLi1aR/hBWkXBeKWLDMZurtcV8= avd@3b32407628ed
```

### Enable Password

Enable password has been disabled

### AAA Authorization

#### AAA Authorization Summary

| Type | User Stores |
| ---- | ----------- |
| Exec | local |

Authorization for configuration commands is disabled.

#### AAA Authorization Device Configuration

```eos
aaa authorization exec default local
!
```

## Monitoring

### TerminAttr Daemon

#### TerminAttr Daemon Summary

| CV Compression | CloudVision Servers | VRF | Authentication | Smash Excludes | Ingest Exclude | Bypass AAA |
| -------------- | ------------------- | --- | -------------- | -------------- | -------------- | ---------- |
| gzip | 1.2.3.4:443 | mgmt | token-secure,/mnt/flash/cv-onboarding-token | ale,flexCounter,hardware,kni,pulse,strata | /Sysdb/cell/1/agent,/Sysdb/cell/2/agent | True |

#### TerminAttr Daemon Device Configuration

```eos
!
daemon TerminAttr
   exec /usr/bin/TerminAttr -cvaddr=1.2.3.4:443 -cvauth=token-secure,/mnt/flash/cv-onboarding-token -cvvrf=mgmt -disableaaa -smashexcludes=ale,flexCounter,hardware,kni,pulse,strata -ingestexclude=/Sysdb/cell/1/agent,/Sysdb/cell/2/agent -taillogs
   no shutdown
```

### Flow Tracking

#### Flow Tracking Sampled

| Sample Size | Minimum Sample Size | Hardware Offload for IPv4 | Hardware Offload for IPv6 | Encapsulations |
| ----------- | ------------------- | ------------------------- | ------------------------- | -------------- |
| 5000 | default | disabled | disabled | ipv4, ipv6 |

##### Trackers Summary

| Tracker Name | Record Export On Inactive Timeout | Record Export On Interval | MPLS | Number of Exporters | Applied On | Table Size |
| ------------ | --------------------------------- | ------------------------- | ---- | ------------------- | ---------- | ---------- |
| FLOW-TRACKER | 70000 | 30000 | - | 1 | Ethernet51/1<br>Ethernet52/1<br>Ethernet1<br>Ethernet2<br>Ethernet3<br>Ethernet4<br>Ethernet5<br>Ethernet6<br>Ethernet7<br>Ethernet8<br>Ethernet9<br>Ethernet10<br>Ethernet11<br>Ethernet12<br>Ethernet13<br>Ethernet14<br>Ethernet15<br>Ethernet16<br>Ethernet17<br>Ethernet18<br>Ethernet19<br>Ethernet20<br>Ethernet21<br>Ethernet22<br>Ethernet23<br>Ethernet24<br>Ethernet25<br>Ethernet26<br>Ethernet27<br>Ethernet28<br>Ethernet29<br>Ethernet30<br>Ethernet31<br>Ethernet32<br>Ethernet33<br>Ethernet34<br>Ethernet35<br>Ethernet36<br>Ethernet37<br>Ethernet38<br>Ethernet39<br>Ethernet40<br>Ethernet41<br>Ethernet42<br>Ethernet43<br>Ethernet44<br>Ethernet45<br>Ethernet46<br>Ethernet47<br>Ethernet48<br>Port-Channel491 | - |

##### Exporters Summary

| Tracker Name | Exporter Name | Collector IP/Host | Collector Port | Local Interface |
| ------------ | ------------- | ----------------- | -------------- | --------------- |
| FLOW-TRACKER | CV-TELEMETRY | 127.0.0.1 | - | Loopback0 |

#### Flow Tracking Device Configuration

```eos
!
flow tracking sampled
   encapsulation ipv4 ipv6
   sample 5000
   tracker FLOW-TRACKER
      record export on inactive timeout 70000
      record export on interval 30000
      exporter CV-TELEMETRY
         collector 127.0.0.1
         local interface Loopback0
         template interval 3600000
   no shutdown
```

## MLAG

### MLAG Summary

| Domain-id | Local-interface | Peer-address | Peer-link |
| --------- | --------------- | ------------ | --------- |
| S2_RACK2 | Vlan4094 | 10.251.2.5 | Port-Channel491 |

Dual primary detection is disabled.

### MLAG Device Configuration

```eos
!
mlag configuration
   domain-id S2_RACK2
   local-interface Vlan4094
   peer-address 10.251.2.5
   peer-link Port-Channel491
   reload-delay mlag 300
   reload-delay non-mlag 330
```

## Spanning Tree

### Spanning Tree Summary

STP mode: **mstp**

#### MSTP Instance and Priority

| Instance(s) | Priority |
| -------- | -------- |
| 0 | 4096 |

#### Global Spanning-Tree Settings

- Spanning Tree disabled for VLANs: **4093-4094**

### Spanning Tree Device Configuration

```eos
!
spanning-tree mode mstp
no spanning-tree vlan-id 4093-4094
spanning-tree mst 0 priority 4096
```

## Internal VLAN Allocation Policy

### Internal VLAN Allocation Policy Summary

| Policy Allocation | Range Beginning | Range Ending |
| ------------------| --------------- | ------------ |
| ascending | 1006 | 1199 |

### Internal VLAN Allocation Policy Device Configuration

```eos
!
vlan internal order ascending range 1006 1199
```

## VLANs

### VLANs Summary

| VLAN ID | Name | Trunk Groups |
| ------- | ---- | ------------ |
| 4093 | MLAG_L3 | MLAG |
| 4094 | MLAG | MLAG |

### VLANs Device Configuration

```eos
!
vlan 4093
   name MLAG_L3
   trunk group MLAG
!
vlan 4094
   name MLAG
   trunk group MLAG
```

## Interfaces

### Ethernet Interfaces

#### Ethernet Interfaces Summary

##### L2

| Interface | Description | Mode | VLANs | Native VLAN | Trunk Group | Channel-Group |
| --------- | ----------- | ---- | ----- | ----------- | ----------- | ------------- |
| Ethernet1 | UNUSED | - | - | - | - | - |
| Ethernet2 | UNUSED | - | - | - | - | - |
| Ethernet3 | UNUSED | - | - | - | - | - |
| Ethernet4 | UNUSED | - | - | - | - | - |
| Ethernet5 | UNUSED | - | - | - | - | - |
| Ethernet6 | UNUSED | - | - | - | - | - |
| Ethernet7 | UNUSED | - | - | - | - | - |
| Ethernet8 | UNUSED | - | - | - | - | - |
| Ethernet9 | UNUSED | - | - | - | - | - |
| Ethernet10 | UNUSED | - | - | - | - | - |
| Ethernet11 | UNUSED | - | - | - | - | - |
| Ethernet12 | UNUSED | - | - | - | - | - |
| Ethernet13 | UNUSED | - | - | - | - | - |
| Ethernet14 | UNUSED | - | - | - | - | - |
| Ethernet15 | UNUSED | - | - | - | - | - |
| Ethernet16 | UNUSED | - | - | - | - | - |
| Ethernet17 | UNUSED | - | - | - | - | - |
| Ethernet18 | UNUSED | - | - | - | - | - |
| Ethernet19 | UNUSED | - | - | - | - | - |
| Ethernet20 | UNUSED | - | - | - | - | - |
| Ethernet21 | UNUSED | - | - | - | - | - |
| Ethernet22 | UNUSED | - | - | - | - | - |
| Ethernet23 | UNUSED | - | - | - | - | - |
| Ethernet24 | UNUSED | - | - | - | - | - |
| Ethernet25 | UNUSED | - | - | - | - | - |
| Ethernet26 | UNUSED | - | - | - | - | - |
| Ethernet27 | UNUSED | - | - | - | - | - |
| Ethernet28 | UNUSED | - | - | - | - | - |
| Ethernet29 | UNUSED | - | - | - | - | - |
| Ethernet30 | UNUSED | - | - | - | - | - |
| Ethernet31 | UNUSED | - | - | - | - | - |
| Ethernet32 | UNUSED | - | - | - | - | - |
| Ethernet33 | UNUSED | - | - | - | - | - |
| Ethernet34 | UNUSED | - | - | - | - | - |
| Ethernet35 | UNUSED | - | - | - | - | - |
| Ethernet36 | UNUSED | - | - | - | - | - |
| Ethernet37 | UNUSED | - | - | - | - | - |
| Ethernet38 | UNUSED | - | - | - | - | - |
| Ethernet39 | UNUSED | - | - | - | - | - |
| Ethernet40 | UNUSED | - | - | - | - | - |
| Ethernet41 | UNUSED | - | - | - | - | - |
| Ethernet42 | UNUSED | - | - | - | - | - |
| Ethernet43 | UNUSED | - | - | - | - | - |
| Ethernet44 | UNUSED | - | - | - | - | - |
| Ethernet45 | UNUSED | - | - | - | - | - |
| Ethernet46 | UNUSED | - | - | - | - | - |
| Ethernet47 | UNUSED | - | - | - | - | - |
| Ethernet48 | UNUSED | - | - | - | - | - |
| Ethernet49/1 | MLAG_s2-leaf4_Ethernet49/1 | *trunk | *- | *- | *MLAG | 491 |
| Ethernet50/1 | MLAG_s2-leaf4_Ethernet50/1 | *trunk | *- | *- | *MLAG | 491 |

*Inherited from Port-Channel Interface

##### IPv4

| Interface | Description | Channel Group | IP Address | VRF |  MTU | Shutdown | ACL In | ACL Out |
| --------- | ----------- | ------------- | ---------- | ----| ---- | -------- | ------ | ------- |
| Ethernet51/1 | P2P_s2-spine1_Ethernet3/1 | - | 172.16.2.9/31 | default | 9200 | False | - | - |
| Ethernet52/1 | P2P_s2-spine2_Ethernet3/1 | - | 172.16.2.11/31 | default | 9200 | False | - | - |

#### Ethernet Interfaces Device Configuration

```eos
!
interface Ethernet1
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet2
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet3
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet4
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet5
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet6
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet7
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet8
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet9
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet10
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet11
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet12
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet13
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet14
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet15
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet16
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet17
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet18
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet19
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet20
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet21
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet22
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet23
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet24
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet25
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet26
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet27
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet28
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet29
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet30
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet31
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet32
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet33
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet34
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet35
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet36
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet37
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet38
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet39
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet40
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet41
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet42
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet43
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet44
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet45
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet46
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet47
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet48
   description UNUSED
   shutdown
   switchport
   flow tracker sampled FLOW-TRACKER
!
interface Ethernet49/1
   description MLAG_s2-leaf4_Ethernet49/1
   no shutdown
   channel-group 491 mode active
!
interface Ethernet50/1
   description MLAG_s2-leaf4_Ethernet50/1
   no shutdown
   channel-group 491 mode active
!
interface Ethernet51/1
   description P2P_s2-spine1_Ethernet3/1
   no shutdown
   mtu 9200
   no switchport
   flow tracker sampled FLOW-TRACKER
   ip address 172.16.2.9/31
!
interface Ethernet52/1
   description P2P_s2-spine2_Ethernet3/1
   no shutdown
   mtu 9200
   no switchport
   flow tracker sampled FLOW-TRACKER
   ip address 172.16.2.11/31
```

### Port-Channel Interfaces

#### Port-Channel Interfaces Summary

##### L2

| Interface | Description | Mode | VLANs | Native VLAN | Trunk Group | LACP Fallback Timeout | LACP Fallback Mode | MLAG ID | EVPN ESI |
| --------- | ----------- | ---- | ----- | ----------- | ------------| --------------------- | ------------------ | ------- | -------- |
| Port-Channel491 | MLAG_s2-leaf4_Port-Channel491 | trunk | - | - | MLAG | - | - | - | - |

#### Port-Channel Interfaces Device Configuration

```eos
!
interface Port-Channel491
   description MLAG_s2-leaf4_Port-Channel491
   no shutdown
   switchport mode trunk
   switchport trunk group MLAG
   switchport
   flow tracker sampled FLOW-TRACKER
```

### Loopback Interfaces

#### Loopback Interfaces Summary

##### IPv4

| Interface | Description | VRF | IP Address |
| --------- | ----------- | --- | ---------- |
| Loopback0 | ROUTER_ID | default | 10.250.2.5/32 |
| Loopback1 | VXLAN_TUNNEL_SOURCE | default | 10.255.2.5/32 |

##### IPv6

| Interface | Description | VRF | IPv6 Address |
| --------- | ----------- | --- | ------------ |
| Loopback0 | ROUTER_ID | default | - |
| Loopback1 | VXLAN_TUNNEL_SOURCE | default | - |

#### Loopback Interfaces Device Configuration

```eos
!
interface Loopback0
   description ROUTER_ID
   no shutdown
   ip address 10.250.2.5/32
!
interface Loopback1
   description VXLAN_TUNNEL_SOURCE
   no shutdown
   ip address 10.255.2.5/32
```

### VLAN Interfaces

#### VLAN Interfaces Summary

| Interface | Description | VRF |  MTU | Shutdown |
| --------- | ----------- | --- | ---- | -------- |
| Vlan4093 | MLAG_L3 | default | 9200 | False |
| Vlan4094 | MLAG | default | 9200 | False |

##### IPv4

| Interface | VRF | IP Address | IP Address Virtual | IP Router Virtual Address | ACL In | ACL Out |
| --------- | --- | ---------- | ------------------ | ------------------------- | ------ | ------- |
| Vlan4093 |  default  |  10.252.2.4/31  |  -  |  -  |  -  |  -  |
| Vlan4094 |  default  |  10.251.2.4/31  |  -  |  -  |  -  |  -  |

#### VLAN Interfaces Device Configuration

```eos
!
interface Vlan4093
   description MLAG_L3
   no shutdown
   mtu 9200
   ip address 10.252.2.4/31
!
interface Vlan4094
   description MLAG
   no shutdown
   mtu 9200
   no autostate
   ip address 10.251.2.4/31
```

### VXLAN Interface

#### VXLAN Interface Summary

| Setting | Value |
| ------- | ----- |
| Source Interface | Loopback1 |
| UDP port | 4789 |
| EVPN MLAG Shared Router MAC | mlag-system-id |

#### VXLAN Interface Device Configuration

```eos
!
interface Vxlan1
   description s2-leaf3_VTEP
   vxlan source-interface Loopback1
   vxlan virtual-router encapsulation mac-address mlag-system-id
   vxlan udp-port 4789
```

## Routing

### Service Routing Protocols Model

Multi agent routing protocol model enabled

```eos
!
service routing protocols model multi-agent
```

### Virtual Router MAC Address

#### Virtual Router MAC Address Summary

Virtual Router MAC Address: 00:1c:73:00:00:99

#### Virtual Router MAC Address Device Configuration

```eos
!
ip virtual-router mac-address 00:1c:73:00:00:99
```

### IP Routing

#### IP Routing Summary

| VRF | Routing Enabled |
| --- | --------------- |
| default | True |
| mgmt | False |

#### IP Routing Device Configuration

```eos
!
ip routing
no ip routing vrf mgmt
```

### IPv6 Routing

#### IPv6 Routing Summary

| VRF | Routing Enabled |
| --- | --------------- |
| default | False |
| mgmt | false |

### Static Routes

#### Static Routes Summary

| VRF | Destination Prefix | Next Hop IP | Exit interface | Administrative Distance | Tag | Route Name | Metric |
| --- | ------------------ | ----------- | -------------- | ----------------------- | --- | ---------- | ------ |
| mgmt | 0.0.0.0/0 | 192.168.0.1 | - | 1 | - | - | - |

#### Static Routes Device Configuration

```eos
!
ip route vrf mgmt 0.0.0.0/0 192.168.0.1
```

### Router BGP

ASN Notation: asplain

#### Router BGP Summary

| BGP AS | Router ID |
| ------ | --------- |
| 65202 | 10.250.2.5 |

| BGP Tuning |
| ---------- |
| update wait-install |
| no bgp default ipv4-unicast |
| maximum-paths 4 ecmp 4 |

#### Router BGP Peer Groups

##### EVPN-OVERLAY-PEERS

| Settings | Value |
| -------- | ----- |
| Address Family | evpn |
| Source | Loopback0 |
| BFD | True |
| Ebgp multihop | 3 |
| Send community | all |
| Maximum routes | 0 (no limit) |

##### IPv4-UNDERLAY-PEERS

| Settings | Value |
| -------- | ----- |
| Address Family | ipv4 |
| Send community | all |
| Maximum routes | 12000 |

##### MLAG-IPv4-UNDERLAY-PEER

| Settings | Value |
| -------- | ----- |
| Address Family | ipv4 |
| Remote AS | 65202 |
| Next-hop self | True |
| Send community | all |
| Maximum routes | 12000 |

#### BGP Neighbors

| Neighbor | Remote AS | VRF | Shutdown | Send-community | Maximum-routes | Allowas-in | BFD | RIB Pre-Policy Retain | Route-Reflector Client | Passive | TTL Max Hops |
| -------- | --------- | --- | -------- | -------------- | -------------- | ---------- | --- | --------------------- | ---------------------- | ------- | ------------ |
| 10.250.2.1 | 65200 | default | - | Inherited from peer group EVPN-OVERLAY-PEERS | Inherited from peer group EVPN-OVERLAY-PEERS | - | Inherited from peer group EVPN-OVERLAY-PEERS | - | - | - | - |
| 10.250.2.2 | 65200 | default | - | Inherited from peer group EVPN-OVERLAY-PEERS | Inherited from peer group EVPN-OVERLAY-PEERS | - | Inherited from peer group EVPN-OVERLAY-PEERS | - | - | - | - |
| 10.252.2.5 | Inherited from peer group MLAG-IPv4-UNDERLAY-PEER | default | - | Inherited from peer group MLAG-IPv4-UNDERLAY-PEER | Inherited from peer group MLAG-IPv4-UNDERLAY-PEER | - | - | - | - | - | - |
| 172.16.2.8 | 65200 | default | - | Inherited from peer group IPv4-UNDERLAY-PEERS | Inherited from peer group IPv4-UNDERLAY-PEERS | - | - | - | - | - | - |
| 172.16.2.10 | 65200 | default | - | Inherited from peer group IPv4-UNDERLAY-PEERS | Inherited from peer group IPv4-UNDERLAY-PEERS | - | - | - | - | - | - |

#### Router BGP EVPN Address Family

##### EVPN Peer Groups

| Peer Group | Activate | Route-map In | Route-map Out | Peer-tag In | Peer-tag Out | Encapsulation | Next-hop-self Source Interface |
| ---------- | -------- | ------------ | ------------- | ----------- | ------------ | ------------- | ------------------------------ |
| EVPN-OVERLAY-PEERS | True | - | - | - | - | default | - |

#### Router BGP Device Configuration

```eos
!
router bgp 65202
   router-id 10.250.2.5
   update wait-install
   no bgp default ipv4-unicast
   maximum-paths 4 ecmp 4
   neighbor EVPN-OVERLAY-PEERS peer group
   neighbor EVPN-OVERLAY-PEERS update-source Loopback0
   neighbor EVPN-OVERLAY-PEERS bfd
   neighbor EVPN-OVERLAY-PEERS ebgp-multihop 3
   neighbor EVPN-OVERLAY-PEERS send-community
   neighbor EVPN-OVERLAY-PEERS maximum-routes 0
   neighbor IPv4-UNDERLAY-PEERS peer group
   neighbor IPv4-UNDERLAY-PEERS send-community
   neighbor IPv4-UNDERLAY-PEERS maximum-routes 12000
   neighbor MLAG-IPv4-UNDERLAY-PEER peer group
   neighbor MLAG-IPv4-UNDERLAY-PEER remote-as 65202
   neighbor MLAG-IPv4-UNDERLAY-PEER next-hop-self
   neighbor MLAG-IPv4-UNDERLAY-PEER description s2-leaf4
   neighbor MLAG-IPv4-UNDERLAY-PEER route-map RM-MLAG-PEER-IN in
   neighbor MLAG-IPv4-UNDERLAY-PEER send-community
   neighbor MLAG-IPv4-UNDERLAY-PEER maximum-routes 12000
   neighbor 10.250.2.1 peer group EVPN-OVERLAY-PEERS
   neighbor 10.250.2.1 remote-as 65200
   neighbor 10.250.2.1 description s2-spine1_Loopback0
   neighbor 10.250.2.2 peer group EVPN-OVERLAY-PEERS
   neighbor 10.250.2.2 remote-as 65200
   neighbor 10.250.2.2 description s2-spine2_Loopback0
   neighbor 10.252.2.5 peer group MLAG-IPv4-UNDERLAY-PEER
   neighbor 10.252.2.5 description s2-leaf4_Vlan4093
   neighbor 172.16.2.8 peer group IPv4-UNDERLAY-PEERS
   neighbor 172.16.2.8 remote-as 65200
   neighbor 172.16.2.8 description s2-spine1_Ethernet3/1
   neighbor 172.16.2.10 peer group IPv4-UNDERLAY-PEERS
   neighbor 172.16.2.10 remote-as 65200
   neighbor 172.16.2.10 description s2-spine2_Ethernet3/1
   redistribute connected route-map RM-CONN-2-BGP
   !
   address-family evpn
      neighbor EVPN-OVERLAY-PEERS activate
   !
   address-family ipv4
      no neighbor EVPN-OVERLAY-PEERS activate
      neighbor IPv4-UNDERLAY-PEERS activate
      neighbor MLAG-IPv4-UNDERLAY-PEER activate
```

## BFD

### Router BFD

#### Router BFD Multihop Summary

| Interval | Minimum RX | Multiplier |
| -------- | ---------- | ---------- |
| 300 | 300 | 3 |

#### Router BFD Device Configuration

```eos
!
router bfd
   multihop interval 300 min-rx 300 multiplier 3
```

## Multicast

### IP IGMP Snooping

#### IP IGMP Snooping Summary

| IGMP Snooping | Fast Leave | Interface Restart Query | Proxy | Restart Query Interval | Robustness Variable |
| ------------- | ---------- | ----------------------- | ----- | ---------------------- | ------------------- |
| Enabled | - | - | - | - | - |

#### IP IGMP Snooping Device Configuration

```eos
```

## Filters

### Prefix-lists

#### Prefix-lists Summary

##### PL-LOOPBACKS-EVPN-OVERLAY

| Sequence | Action |
| -------- | ------ |
| 10 | permit 10.250.2.0/24 eq 32 |
| 20 | permit 10.255.2.0/24 eq 32 |

#### Prefix-lists Device Configuration

```eos
!
ip prefix-list PL-LOOPBACKS-EVPN-OVERLAY
   seq 10 permit 10.250.2.0/24 eq 32
   seq 20 permit 10.255.2.0/24 eq 32
```

### Route-maps

#### Route-maps Summary

##### RM-CONN-2-BGP

| Sequence | Type | Match | Set | Sub-Route-Map | Continue |
| -------- | ---- | ----- | --- | ------------- | -------- |
| 10 | permit | ip address prefix-list PL-LOOPBACKS-EVPN-OVERLAY | - | - | - |

##### RM-MLAG-PEER-IN

| Sequence | Type | Match | Set | Sub-Route-Map | Continue |
| -------- | ---- | ----- | --- | ------------- | -------- |
| 10 | permit | - | origin incomplete | - | - |

#### Route-maps Device Configuration

```eos
!
route-map RM-CONN-2-BGP permit 10
   match ip address prefix-list PL-LOOPBACKS-EVPN-OVERLAY
!
route-map RM-MLAG-PEER-IN permit 10
   description Make routes learned over MLAG Peer-link less preferred on spines to ensure optimal routing
   set origin incomplete
```

## VRF Instances

### VRF Instances Summary

| VRF Name | IP Routing |
| -------- | ---------- |
| mgmt | disabled |

### VRF Instances Device Configuration

```eos
!
vrf instance mgmt
```
