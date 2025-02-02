resource "routeros_interface_bonding" "nas" {
  name                 = "bond-nas"
  comment              = "NAS 10g"
  forced_mac_address   = "A7:6A:BD:C0:89:11"
  mode                 = "802.3ad"
  mtu                  = "1514"
  transmit_hash_policy = "layer-3-and-4"
  slaves = [
    routeros_interface_ethernet.nas-1.name,
    routeros_interface_ethernet.nas-2.name
  ]
}

resource "routeros_interface_bonding" "kube01" {
  name                 = "bond-kube01"
  comment              = "Kube01 10g"
  forced_mac_address   = "FD:11:FF:E3:A4:3D"
  mode                 = "802.3ad"
  mtu                  = "1514"
  transmit_hash_policy = "layer-3-and-4"
  slaves = [
    routeros_interface_ethernet.kube01-1.name,
    routeros_interface_ethernet.kube01-2.name
  ]
}

resource "routeros_interface_bonding" "kube02" {
  name                 = "bond-kube02"
  comment              = "Kube02 10g"
  forced_mac_address   = "EC:15:BF:72:A7:D6"
  mode                 = "802.3ad"
  mtu                  = "1514"
  transmit_hash_policy = "layer-3-and-4"
  slaves = [
    routeros_interface_ethernet.kube02-1.name,
    routeros_interface_ethernet.kube02-2.name
  ]
}

resource "routeros_interface_bonding" "kube03" {
  name                 = "bond-kube03"
  comment              = "Kube03 10g"
  forced_mac_address   = "FC:C5:1F:4F:C3:EB"
  mode                 = "802.3ad"
  mtu                  = "1514"
  transmit_hash_policy = "layer-3-and-4"
  slaves = [
    routeros_interface_ethernet.kube03-1.name,
    routeros_interface_ethernet.kube03-2.name
  ]
}

resource "routeros_interface_bonding" "pve" {
  name                 = "bond-pve"
  comment              = "Proxmox Server 10g"
  forced_mac_address   = "DE:91:DC:52:32:ED"
  mode                 = "802.3ad"
  mtu                  = "1514"
  transmit_hash_policy = "layer-3-and-4"
  slaves = [
    routeros_interface_ethernet.pve-1.name,
    routeros_interface_ethernet.pve-2.name
  ]
}

resource "routeros_interface_bonding" "crs326" {
  name                 = "bond-crs326"
  comment              = "CRS326 Uplink 10g"
  forced_mac_address   = "9A:5A:BE:C2:5E:C1"
  mode                 = "802.3ad"
  mtu                  = "1514"
  transmit_hash_policy = "layer-3-and-4"
  slaves = [
    routeros_interface_ethernet.crs326-1.name,
    routeros_interface_ethernet.crs326-2.name
  ]
}
