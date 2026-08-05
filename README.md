# 🌐 BADASS

## 📘 Overview

**BADASS** (*BGP At Doors of Autonomous Systems is Simple*) is a 42 school network-administration project focused on building and simulating modern network topologies with **GNS3** and **Docker**.

The project progresses from custom network containers to a VXLAN overlay, then introduces a BGP EVPN control plane with OSPF and route reflection.

## 🧩 Project Parts

### P1 — GNS3 & Docker

Creates two Docker images for GNS3:

- A lightweight host image.
- A router image based on **FRRouting**, with BGP, OSPF and IS-IS services enabled.

### P2 — VXLAN

Builds a Layer 2 overlay between two remote hosts using:

- Linux bridges.
- **VXLAN VNI 10**.
- Static VTEP configuration, with a multicast alternative included in the router scripts.

### P3 — BGP EVPN

Builds a small data-center topology using:

- **OSPF** as the underlay routing protocol.
- **BGP EVPN** as the overlay control plane.
- A route reflector and multiple VTEPs.
- VXLAN VNI 10 for Layer 2 connectivity between hosts.

## 🛠️ Technologies

- GNS3
- Docker
- FRRouting (FRR)
- Linux bridges and VXLAN
- OSPF, BGP and EVPN
- Bash

## 🚀 Usage

### Requirements

- A Linux virtual machine
- Docker
- GNS3

Clone the repository:

```bash
git clone https://github.com/hboissel/BADASS.git
cd BADASS
````

Build the Docker images used by GNS3:

```bash
(cd P1 && bash build.sh)
```

Open the `.gns3project` file from the desired part in GNS3 and start every node. For P2 and P3, apply the configurations from the repository root:

```bash
(cd P2 && bash config.sh)
(cd P3 && bash config.sh)
```

The configuration scripts detect running containers by hostname, so the GNS3 node names must keep the expected `hboissel` naming convention.

## 📂 Repository Structure

```text
BADASS/
├── P1/   # Docker images and initial GNS3 setup
├── P2/   # VXLAN topology and configuration scripts
└── P3/   # OSPF and BGP EVPN topology
```

