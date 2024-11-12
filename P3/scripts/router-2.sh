ip link add br0 type bridge
ip link set up dev br0
ip link add vxlan10 type vxlan id 10 dstport 4789
ip link set up dev vxlan10
ip link set eth0 master br0
ip link set vxlan10 master br0

vtysh << EOF
conf t

hostname router_hboissel-2
no ipv6 forwarding

router ospf
router-id  2.2.2.2
passive-interface default
area 0 authentication

interface br0
ip address 20.1.1.1/24

interface eth1
ip address 10.1.1.2/30
ip ospf area 0
ip ospf authentication-key R1R2
no ip ospf passive

interface lo
ip address 1.1.1.2/32
ip ospf area 0

router bgp 1
neighbor 1.1.1.1 remote-as 1
neighbor 1.1.1.1 update-source lo

address-family l2vpn evpn
neighbor 1.1.1.1 activate
advertise-all-vni
exit-address-family

end
EOF

#### Configure DHCP server
cat > /etc/default/isc-dhcp-server << EOF
INTERFACESv4="br0"
EOF

cat > /etc/dhcp/dhcpd.conf << EOF
default-lease-time 600;
max-lease-time 7200;

subnet 20.1.1.0 netmask 255.255.255.0 {
  range 20.1.1.2 20.1.1.254;
  option routers 20.1.1.1;
}

EOF

rm /var/run/dhcpd.pid
service isc-dhcp-server restart