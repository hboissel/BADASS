vtysh << EOF
conf t

hostname router_hboissel-1
no ipv6 forwarding

router ospf
router-id  1.1.1.1
passive-interface default
area 0 authentication

interface eth0
ip address 10.1.1.1/30
ip ospf area 0
ip ospf authentication-key R1R2
no ip ospf passive

interface eth1
ip address 10.1.1.5/30
ip ospf area 0
ip ospf authentication-key R1R3
no ip ospf passive

interface eth2
ip address 10.1.1.9/30
ip ospf area 0
ip ospf authentication-key R1R4
no ip ospf passive

interface lo
ip address 1.1.1.1/32
ip ospf area 0

router bgp 1
neighbor ibgp peer-group
neighbor ibgp remote-as 1
neighbor ibgp update-source lo
bgp listen range 1.1.1.0/29 peer-group ibgp

address-family l2vpn evpn
neighbor ibgp activate
neighbor ibgp route-reflector-client
exit-address-family

end
EOF