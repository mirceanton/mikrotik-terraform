# =================================================================================================
# Bridge Interfaces
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interface_bridge
# =================================================================================================
resource "routeros_interface_bridge" "bridge" {
  name           = "bridge"
  comment        = ""
  disabled       = false
  vlan_filtering = true
}


# =================================================================================================
# Bridge Ports
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interfa
# =================================================================================================ce_bridge_port
resource "routeros_interface_bridge_port" "nas-management" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_ethernet.nas-management.name
  comment   = routeros_interface_ethernet.nas-management.comment
  pvid      = routeros_interface_vlan.servers.vlan_id
}

resource "routeros_interface_bridge_port" "kube01" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_ethernet.kube01.name
  comment   = routeros_interface_ethernet.kube01.comment
  pvid      = routeros_interface_vlan.servers.vlan_id
}

resource "routeros_interface_bridge_port" "kube02" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_ethernet.kube02.name
  comment   = routeros_interface_ethernet.kube02.comment
  pvid      = routeros_interface_vlan.servers.vlan_id
}

resource "routeros_interface_bridge_port" "kube03" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_ethernet.kube03.name
  comment   = routeros_interface_ethernet.kube03.comment
  pvid      = routeros_interface_vlan.servers.vlan_id
}

resource "routeros_interface_bridge_port" "kube04" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_ethernet.kube04.name
  comment   = routeros_interface_ethernet.kube04.comment
  pvid      = routeros_interface_vlan.servers.vlan_id
}

resource "routeros_interface_bridge_port" "virt" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_bonding.virt.name
  comment   = routeros_interface_bonding.virt.comment
  pvid      = routeros_interface_vlan.servers.vlan_id
}

resource "routeros_interface_bridge_port" "tesmart" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_ethernet.tesmart.name
  comment   = routeros_interface_ethernet.tesmart.comment
  pvid      = routeros_interface_vlan.servers.vlan_id
}

resource "routeros_interface_bridge_port" "ipkvm" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_ethernet.ipkvm.name
  comment   = routeros_interface_ethernet.ipkvm.comment
  pvid      = routeros_interface_vlan.servers.vlan_id
}

resource "routeros_interface_bridge_port" "nas-data-1" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_ethernet.nas-data-1.name
  comment   = routeros_interface_ethernet.nas-data-1.comment
  pvid      = "1"
}

resource "routeros_interface_bridge_port" "home-assistant" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_ethernet.home-assistant.name
  comment   = routeros_interface_ethernet.home-assistant.comment
  pvid      = routeros_interface_vlan.untrusted.vlan_id
}

resource "routeros_interface_bridge_port" "uplink" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_ethernet.uplink.name
  comment   = routeros_interface_ethernet.uplink.comment
  pvid      = "1"
}

resource "routeros_interface_bridge_port" "mirkputer" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_ethernet.mirkputer.name
  comment   = routeros_interface_ethernet.mirkputer.comment
  pvid      = routeros_interface_vlan.trusted.vlan_id
}


resource "routeros_interface_bridge_port" "crs317" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_bonding.crs317.name
  comment   = routeros_interface_bonding.crs317.comment
  pvid      = "1"
}

resource "routeros_interface_bridge_port" "unassigned" {
  for_each = toset(["ether12", "ether13", "ether14", "ether15", "ether16", "ether17", "ether18", "ether19",
  "ether20", "ether21", "ether22"])

  bridge    = routeros_interface_bridge.bridge.name
  interface = each.key
  comment   = "N/A"
  pvid      = "1"
}
