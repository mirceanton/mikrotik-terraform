# =================================================================================================
# Ethernet Interfaces
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interface_ethernet
# =================================================================================================
resource "routeros_interface_ethernet" "wan" {
  factory_name = "ether1"
  name         = "ether1"
  comment      = "Digi Uplink (PPPoE)"
  l2mtu        = 1514
}

resource "routeros_interface_ethernet" "living_room" {
  factory_name = "ether2"
  name         = "ether2"
  comment      = "Living Room Switch"
  l2mtu        = 1514
}

resource "routeros_interface_ethernet" "sploinkhole" {
  factory_name = "ether3"
  name         = "ether3"
  comment      = "Sploinkhole"
  l2mtu        = 1514
}

resource "routeros_interface_ethernet" "ether4" {
  factory_name = "ether4"
  name         = "ether4"
  disabled     = true
}

resource "routeros_interface_ethernet" "ether5" {
  factory_name = "ether5"
  name         = "ether5"
  disabled     = true
}

resource "routeros_interface_ethernet" "ether6" {
  factory_name = "ether6"
  name         = "ether6"
  disabled     = true
}

resource "routeros_interface_ethernet" "ether7" {
  factory_name = "ether7"
  name         = "ether7"
  disabled     = true
}

resource "routeros_interface_ethernet" "access_point" {
  factory_name = "ether8"
  name         = "ether8"
  comment      = "cAP AX"
  l2mtu        = 1514
}

resource "routeros_interface_ethernet" "sfp-sfpplus1" {
  factory_name             = "sfp-sfpplus1"
  name                     = "sfp-sfpplus1"
  disabled                 = true
  sfp_shutdown_temperature = 90
}
