# Create VXLAN devices (learning ON by default)
for vni in 20100 20101 20102 20103; do
  ip link add wifi_vx${vni} type vxlan id ${vni} dev bond0 dstport 4789
done

# Head-end replication flood lists:
# Add one wildcard (00:..:00) entry PER remote VTEP PER VNI.
for vni in 20100 20101 20102 20103; do
  bridge fdb add 00:00:00:00:00:00 dst 10.255.255.1 dev wifi_vx${vni} self permanent
done

# Assign IPs to VXLAN interfaces
ip addr add 10.100.0.10/22 dev wifi_vx20100
ip addr add 10.100.4.10/22 dev wifi_vx20101
ip addr add 10.100.8.10/22 dev wifi_vx20102
ip addr add 10.100.12.10/22 dev wifi_vx20103

# Bring VXLAN interfaces up
for vni in 20100 20101 20102 20103; do
  ip link set wifi_vx${vni} up
done
