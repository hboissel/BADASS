ip link add br0 type bridge
ip link set up dev br0
ip link add vxlan10 type vxlan id 10 dstport 4789
ip link set up dev vxlan10
ip link set eth0 master br0
ip link set vxlan10 master br0

vtysh << EOF
conf t

hostname router_hboissel-4
no ipv6 forwarding

router ospf
router-id  4.4.4.4
passive-interface default
area 0 authentication

interface eth1
ip address 10.1.1.10/30
ip ospf area 0
ip ospf authentication-key R1R4
no ip ospf passive

interface lo
ip address 1.1.1.4/32
ip ospf area 0

router bgp 1
neighbor 1.1.1.1 remote-as 1
neighbor 1.1.1.1 update-source lo

address-family l2vpn evpn
neighbor 1.1.1.1 activate
advertise-all-vni
exit-address-family

end
write memory
EOF