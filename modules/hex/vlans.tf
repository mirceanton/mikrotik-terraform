# =================================================================================================
# Servers
# =================================================================================================
resource "routeros_interface_vlan" "servers" {
  interface = routeros_interface_ethernet.uplink.name
  name      = "Servers"
  vlan_id   = 1000
}

resource "routeros_interface_bridge_vlan" "bridge_vlan_servers" {
  bridge   = routeros_interface_bridge.bridge.name
  comment  = routeros_interface_vlan.servers.name
  vlan_ids = [routeros_interface_vlan.servers.vlan_id]

  tagged = [
    routeros_interface_bridge.bridge.name,
    routeros_interface_ethernet.uplink.name,
    routeros_interface_ethernet.rack.name,
  ]

  untagged = []
}

# =================================================================================================
# Kubernetes
# =================================================================================================
resource "routeros_interface_vlan" "kubernetes" {
  interface = routeros_interface_ethernet.uplink.name
  name      = "Kubernetes"
  vlan_id   = 1010
}

resource "routeros_interface_bridge_vlan" "bridge_vlan_kubernetes" {
  bridge   = routeros_interface_bridge.bridge.name
  comment  = routeros_interface_vlan.kubernetes.name
  vlan_ids = [routeros_interface_vlan.kubernetes.vlan_id]

  tagged = [
    routeros_interface_bridge.bridge.name,
    routeros_interface_ethernet.uplink.name,
    routeros_interface_ethernet.rack.name,
  ]

  untagged = []
}

# =================================================================================================
# Guest
# =================================================================================================
resource "routeros_interface_vlan" "guest" {
  interface = routeros_interface_ethernet.uplink.name
  name      = "Guest"
  vlan_id   = 1742
}

resource "routeros_interface_bridge_vlan" "bridge_vlan_guest" {
  bridge   = routeros_interface_bridge.bridge.name
  comment  = routeros_interface_vlan.guest.name
  vlan_ids = [routeros_interface_vlan.guest.vlan_id]

  tagged = [
    routeros_interface_bridge.bridge.name,
    routeros_interface_ethernet.uplink.name,
    routeros_interface_ethernet.rack.name,
  ]

  untagged = []
}

# =================================================================================================
# IoT
# =================================================================================================
resource "routeros_interface_vlan" "iot" {
  interface = routeros_interface_ethernet.uplink.name
  name      = "IoT"
  vlan_id   = 1769
}

resource "routeros_interface_bridge_vlan" "bridge_vlan_iot" {
  bridge   = routeros_interface_bridge.bridge.name
  comment  = routeros_interface_vlan.iot.name
  vlan_ids = [routeros_interface_vlan.iot.vlan_id]

  tagged = [
    routeros_interface_bridge.bridge.name,
    routeros_interface_ethernet.uplink.name,
    routeros_interface_ethernet.rack.name,
  ]

  untagged = [
    routeros_interface_ethernet.smarttv.name,
  ]
}

# =================================================================================================
# Untrusted
# =================================================================================================
resource "routeros_interface_vlan" "untrusted" {
  interface = routeros_interface_ethernet.uplink.name
  name      = "Untrusted"
  vlan_id   = 1942
}

resource "routeros_interface_bridge_vlan" "bridge_vlan_untrusted" {
  bridge   = routeros_interface_bridge.bridge.name
  comment  = routeros_interface_vlan.untrusted.name
  vlan_ids = [routeros_interface_vlan.untrusted.vlan_id]

  tagged = [
    routeros_interface_bridge.bridge.name,
    routeros_interface_ethernet.uplink.name,
    routeros_interface_ethernet.rack.name,
  ]

  untagged = []
}

# =================================================================================================
# Trusted
# =================================================================================================
resource "routeros_interface_vlan" "trusted" {
  interface = routeros_interface_ethernet.uplink.name
  name      = "Trusted"
  vlan_id   = 1969
}

resource "routeros_interface_bridge_vlan" "bridge_vlan_trusted" {
  bridge   = routeros_interface_bridge.bridge.name
  comment  = routeros_interface_vlan.trusted.name
  vlan_ids = [routeros_interface_vlan.trusted.vlan_id]

  tagged = [
    routeros_interface_bridge.bridge.name,
    routeros_interface_ethernet.uplink.name,
    routeros_interface_ethernet.rack.name,
  ]

  untagged = []
}
