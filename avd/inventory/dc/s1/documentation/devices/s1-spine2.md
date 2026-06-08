# s1-spine2

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
- [Spanning Tree](#spanning-tree)
  - [Spanning Tree Summary](#spanning-tree-summary)
  - [Spanning Tree Device Configuration](#spanning-tree-device-configuration)
- [Internal VLAN Allocation Policy](#internal-vlan-allocation-policy)
  - [Internal VLAN Allocation Policy Summary](#internal-vlan-allocation-policy-summary)
  - [Internal VLAN Allocation Policy Device Configuration](#internal-vlan-allocation-policy-device-configuration)
- [Interfaces](#interfaces)
  - [Ethernet Interfaces](#ethernet-interfaces)
  - [Loopback Interfaces](#loopback-interfaces)
- [Routing](#routing)
  - [Service Routing Protocols Model](#service-routing-protocols-model)
  - [IP Routing](#ip-routing)
  - [IPv6 Routing](#ipv6-routing)
  - [Static Routes](#static-routes)
  - [Router BGP](#router-bgp)
- [BFD](#bfd)
  - [Router BFD](#router-bfd)
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
| Management1 | OOB_MANAGEMENT | oob | mgmt | 192.168.0.11/24 | 192.168.0.1 |

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
   ip address 192.168.0.11/24
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
| FLOW-TRACKER | 70000 | 30000 | - | 1 | Ethernet1/1<br>Ethernet2/1<br>Ethernet3/1<br>Ethernet4/1<br>Ethernet31/1<br>Ethernet32/1 | - |

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

## Spanning Tree

### Spanning Tree Summary

STP mode: **none**

### Spanning Tree Device Configuration

```eos
!
spanning-tree mode none
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

## Interfaces

### Ethernet Interfaces

#### Ethernet Interfaces Summary

##### L2

| Interface | Description | Mode | VLANs | Native VLAN | Trunk Group | Channel-Group |
| --------- | ----------- | ---- | ----- | ----------- | ----------- | ------------- |

*Inherited from Port-Channel Interface

##### IPv4

| Interface | Description | Channel Group | IP Address | VRF |  MTU | Shutdown | ACL In | ACL Out |
| --------- | ----------- | ------------- | ---------- | ----| ---- | -------- | ------ | ------- |
| Ethernet1/1 | P2P_s1-leaf1_Ethernet52/1 | - | 172.16.1.2/31 | default | 9200 | False | - | - |
| Ethernet2/1 | P2P_s1-leaf2_Ethernet52/1 | - | 172.16.1.6/31 | default | 9200 | False | - | - |
| Ethernet3/1 | P2P_s1-leaf3_Ethernet52/1 | - | 172.16.1.10/31 | default | 9200 | False | - | - |
| Ethernet4/1 | P2P_s1-leaf4_Ethernet52/1 | - | 172.16.1.14/31 | default | 9200 | False | - | - |
| Ethernet31/1 | P2P_s1-brdr1_Ethernet52/1 | - | 172.16.1.18/31 | default | 9200 | False | - | - |
| Ethernet32/1 | P2P_s1-brdr2_Ethernet52/1 | - | 172.16.1.22/31 | default | 9200 | False | - | - |

#### Ethernet Interfaces Device Configuration

```eos
!
interface Ethernet1/1
   description P2P_s1-leaf1_Ethernet52/1
   no shutdown
   mtu 9200
   no switchport
   flow tracker sampled FLOW-TRACKER
   ip address 172.16.1.2/31
!
interface Ethernet2/1
   description P2P_s1-leaf2_Ethernet52/1
   no shutdown
   mtu 9200
   no switchport
   flow tracker sampled FLOW-TRACKER
   ip address 172.16.1.6/31
!
interface Ethernet3/1
   description P2P_s1-leaf3_Ethernet52/1
   no shutdown
   mtu 9200
   no switchport
   flow tracker sampled FLOW-TRACKER
   ip address 172.16.1.10/31
!
interface Ethernet4/1
   description P2P_s1-leaf4_Ethernet52/1
   no shutdown
   mtu 9200
   no switchport
   flow tracker sampled FLOW-TRACKER
   ip address 172.16.1.14/31
!
interface Ethernet31/1
   description P2P_s1-brdr1_Ethernet52/1
   no shutdown
   mtu 9200
   no switchport
   flow tracker sampled FLOW-TRACKER
   ip address 172.16.1.18/31
!
interface Ethernet32/1
   description P2P_s1-brdr2_Ethernet52/1
   no shutdown
   mtu 9200
   no switchport
   flow tracker sampled FLOW-TRACKER
   ip address 172.16.1.22/31
```

### Loopback Interfaces

#### Loopback Interfaces Summary

##### IPv4

| Interface | Description | VRF | IP Address |
| --------- | ----------- | --- | ---------- |
| Loopback0 | ROUTER_ID | default | 10.250.1.2/32 |

##### IPv6

| Interface | Description | VRF | IPv6 Address |
| --------- | ----------- | --- | ------------ |
| Loopback0 | ROUTER_ID | default | - |

#### Loopback Interfaces Device Configuration

```eos
!
interface Loopback0
   description ROUTER_ID
   no shutdown
   ip address 10.250.1.2/32
```

## Routing

### Service Routing Protocols Model

Multi agent routing protocol model enabled

```eos
!
service routing protocols model multi-agent
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
| 65100 | 10.250.1.2 |

| BGP Tuning |
| ---------- |
| no bgp default ipv4-unicast |
| maximum-paths 4 ecmp 4 |

#### Router BGP Peer Groups

##### EVPN-OVERLAY-PEERS

| Settings | Value |
| -------- | ----- |
| Address Family | evpn |
| Next-hop unchanged | True |
| Source | Loopback0 |
| BFD | True |
| Ebgp multihop | 3 |
| Send community | all |
| Maximum routes | 0 (no limit) |

##### IPv4-UNDERLAY-PEERS

| Settings | Value |
| -------- | ----- |
| Address Family | ipv4 |
| BFD | True |
| Send community | all |
| Maximum routes | 12000 |

#### BGP Neighbors

| Neighbor | Remote AS | VRF | Shutdown | Send-community | Maximum-routes | Allowas-in | BFD | RIB Pre-Policy Retain | Route-Reflector Client | Passive | TTL Max Hops |
| -------- | --------- | --- | -------- | -------------- | -------------- | ---------- | --- | --------------------- | ---------------------- | ------- | ------------ |
| 10.250.1.3 | 65101 | default | - | Inherited from peer group EVPN-OVERLAY-PEERS | Inherited from peer group EVPN-OVERLAY-PEERS | - | Inherited from peer group EVPN-OVERLAY-PEERS | - | - | - | - |
| 10.250.1.4 | 65101 | default | - | Inherited from peer group EVPN-OVERLAY-PEERS | Inherited from peer group EVPN-OVERLAY-PEERS | - | Inherited from peer group EVPN-OVERLAY-PEERS | - | - | - | - |
| 10.250.1.5 | 65102 | default | - | Inherited from peer group EVPN-OVERLAY-PEERS | Inherited from peer group EVPN-OVERLAY-PEERS | - | Inherited from peer group EVPN-OVERLAY-PEERS | - | - | - | - |
| 10.250.1.6 | 65102 | default | - | Inherited from peer group EVPN-OVERLAY-PEERS | Inherited from peer group EVPN-OVERLAY-PEERS | - | Inherited from peer group EVPN-OVERLAY-PEERS | - | - | - | - |
| 10.250.1.7 | 65103 | default | - | Inherited from peer group EVPN-OVERLAY-PEERS | Inherited from peer group EVPN-OVERLAY-PEERS | - | Inherited from peer group EVPN-OVERLAY-PEERS | - | - | - | - |
| 10.250.1.8 | 65103 | default | - | Inherited from peer group EVPN-OVERLAY-PEERS | Inherited from peer group EVPN-OVERLAY-PEERS | - | Inherited from peer group EVPN-OVERLAY-PEERS | - | - | - | - |
| 172.16.1.3 | 65101 | default | - | Inherited from peer group IPv4-UNDERLAY-PEERS | Inherited from peer group IPv4-UNDERLAY-PEERS | - | Inherited from peer group IPv4-UNDERLAY-PEERS | - | - | - | - |
| 172.16.1.7 | 65101 | default | - | Inherited from peer group IPv4-UNDERLAY-PEERS | Inherited from peer group IPv4-UNDERLAY-PEERS | - | Inherited from peer group IPv4-UNDERLAY-PEERS | - | - | - | - |
| 172.16.1.11 | 65102 | default | - | Inherited from peer group IPv4-UNDERLAY-PEERS | Inherited from peer group IPv4-UNDERLAY-PEERS | - | Inherited from peer group IPv4-UNDERLAY-PEERS | - | - | - | - |
| 172.16.1.15 | 65102 | default | - | Inherited from peer group IPv4-UNDERLAY-PEERS | Inherited from peer group IPv4-UNDERLAY-PEERS | - | Inherited from peer group IPv4-UNDERLAY-PEERS | - | - | - | - |
| 172.16.1.19 | 65103 | default | - | Inherited from peer group IPv4-UNDERLAY-PEERS | Inherited from peer group IPv4-UNDERLAY-PEERS | - | Inherited from peer group IPv4-UNDERLAY-PEERS | - | - | - | - |
| 172.16.1.23 | 65103 | default | - | Inherited from peer group IPv4-UNDERLAY-PEERS | Inherited from peer group IPv4-UNDERLAY-PEERS | - | Inherited from peer group IPv4-UNDERLAY-PEERS | - | - | - | - |

#### Router BGP EVPN Address Family

##### EVPN Peer Groups

| Peer Group | Activate | Route-map In | Route-map Out | Peer-tag In | Peer-tag Out | Encapsulation | Next-hop-self Source Interface |
| ---------- | -------- | ------------ | ------------- | ----------- | ------------ | ------------- | ------------------------------ |
| EVPN-OVERLAY-PEERS | True | - | - | - | - | default | - |

#### Router BGP Device Configuration

```eos
!
router bgp 65100
   router-id 10.250.1.2
   no bgp default ipv4-unicast
   maximum-paths 4 ecmp 4
   neighbor EVPN-OVERLAY-PEERS peer group
   neighbor EVPN-OVERLAY-PEERS next-hop-unchanged
   neighbor EVPN-OVERLAY-PEERS update-source Loopback0
   neighbor EVPN-OVERLAY-PEERS bfd
   neighbor EVPN-OVERLAY-PEERS ebgp-multihop 3
   neighbor EVPN-OVERLAY-PEERS send-community
   neighbor EVPN-OVERLAY-PEERS maximum-routes 0
   neighbor IPv4-UNDERLAY-PEERS peer group
   neighbor IPv4-UNDERLAY-PEERS bfd
   neighbor IPv4-UNDERLAY-PEERS send-community
   neighbor IPv4-UNDERLAY-PEERS maximum-routes 12000
   neighbor 10.250.1.3 peer group EVPN-OVERLAY-PEERS
   neighbor 10.250.1.3 remote-as 65101
   neighbor 10.250.1.3 description s1-leaf1_Loopback0
   neighbor 10.250.1.4 peer group EVPN-OVERLAY-PEERS
   neighbor 10.250.1.4 remote-as 65101
   neighbor 10.250.1.4 description s1-leaf2_Loopback0
   neighbor 10.250.1.5 peer group EVPN-OVERLAY-PEERS
   neighbor 10.250.1.5 remote-as 65102
   neighbor 10.250.1.5 description s1-leaf3_Loopback0
   neighbor 10.250.1.6 peer group EVPN-OVERLAY-PEERS
   neighbor 10.250.1.6 remote-as 65102
   neighbor 10.250.1.6 description s1-leaf4_Loopback0
   neighbor 10.250.1.7 peer group EVPN-OVERLAY-PEERS
   neighbor 10.250.1.7 remote-as 65103
   neighbor 10.250.1.7 description s1-brdr1_Loopback0
   neighbor 10.250.1.8 peer group EVPN-OVERLAY-PEERS
   neighbor 10.250.1.8 remote-as 65103
   neighbor 10.250.1.8 description s1-brdr2_Loopback0
   neighbor 172.16.1.3 peer group IPv4-UNDERLAY-PEERS
   neighbor 172.16.1.3 remote-as 65101
   neighbor 172.16.1.3 description s1-leaf1_Ethernet52/1
   neighbor 172.16.1.7 peer group IPv4-UNDERLAY-PEERS
   neighbor 172.16.1.7 remote-as 65101
   neighbor 172.16.1.7 description s1-leaf2_Ethernet52/1
   neighbor 172.16.1.11 peer group IPv4-UNDERLAY-PEERS
   neighbor 172.16.1.11 remote-as 65102
   neighbor 172.16.1.11 description s1-leaf3_Ethernet52/1
   neighbor 172.16.1.15 peer group IPv4-UNDERLAY-PEERS
   neighbor 172.16.1.15 remote-as 65102
   neighbor 172.16.1.15 description s1-leaf4_Ethernet52/1
   neighbor 172.16.1.19 peer group IPv4-UNDERLAY-PEERS
   neighbor 172.16.1.19 remote-as 65103
   neighbor 172.16.1.19 description s1-brdr1_Ethernet52/1
   neighbor 172.16.1.23 peer group IPv4-UNDERLAY-PEERS
   neighbor 172.16.1.23 remote-as 65103
   neighbor 172.16.1.23 description s1-brdr2_Ethernet52/1
   redistribute connected route-map RM-CONN-2-BGP
   !
   address-family evpn
      neighbor EVPN-OVERLAY-PEERS activate
   !
   address-family ipv4
      no neighbor EVPN-OVERLAY-PEERS activate
      neighbor IPv4-UNDERLAY-PEERS activate
```

## BFD

### Router BFD

#### Router BFD Multihop Summary

| Interval | Minimum RX | Multiplier |
| -------- | ---------- | ---------- |
| 1200 | 1200 | 3 |

#### Router BFD Device Configuration

```eos
!
router bfd
   multihop interval 1200 min-rx 1200 multiplier 3
```

## Filters

### Prefix-lists

#### Prefix-lists Summary

##### PL-LOOPBACKS-EVPN-OVERLAY

| Sequence | Action |
| -------- | ------ |
| 10 | permit 10.250.1.0/24 eq 32 |

#### Prefix-lists Device Configuration

```eos
!
ip prefix-list PL-LOOPBACKS-EVPN-OVERLAY
   seq 10 permit 10.250.1.0/24 eq 32
```

### Route-maps

#### Route-maps Summary

##### RM-CONN-2-BGP

| Sequence | Type | Match | Set | Sub-Route-Map | Continue |
| -------- | ---- | ----- | --- | ------------- | -------- |
| 10 | permit | ip address prefix-list PL-LOOPBACKS-EVPN-OVERLAY | - | - | - |

#### Route-maps Device Configuration

```eos
!
route-map RM-CONN-2-BGP permit 10
   match ip address prefix-list PL-LOOPBACKS-EVPN-OVERLAY
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
