# =================================================================================================
# Ethernet Interfaces
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interface_ethernet
# =================================================================================================
resource "routeros_interface_ethernet" "ether1" {
  factory_name = "ether1"
  name         = "ether1"
  comment      = ""
  l2mtu        = 1514
}

resource "routeros_interface_ethernet" "nas-1" {
  factory_name             = "sfp-sfpplus1"
  name                     = "sfp-sfpplus1"
  comment                  = "NAS Port 1 (LAGG Member, Trunk Port)"
  l2mtu                    = 1514
  sfp_shutdown_temperature = 90
}

resource "routeros_interface_ethernet" "nas-2" {
  factory_name             = "sfp-sfpplus2"
  name                     = "sfp-sfpplus2"
  comment                  = "NAS Port 2 (LAGG Member, Trunk Port)"
  l2mtu                    = 1514
  sfp_shutdown_temperature = 90
}

resource "routeros_interface_ethernet" "kube01-1" {
  factory_name             = "sfp-sfpplus3"
  name                     = "sfp-sfpplus3"
  comment                  = "Kube-01 Port 1 (LAGG Member, Trunk Port)"
  l2mtu                    = 1514
  sfp_shutdown_temperature = 90
}

resource "routeros_interface_ethernet" "kube01-2" {
  factory_name             = "sfp-sfpplus4"
  name                     = "sfp-sfpplus4"
  comment                  = "Kube-01 Port 2 (LAGG Member, Trunk Port)"
  l2mtu                    = 1514
  sfp_shutdown_temperature = 90
}

resource "routeros_interface_ethernet" "kube02-1" {
  factory_name             = "sfp-sfpplus5"
  name                     = "sfp-sfpplus5"
  comment                  = "Kube-02 Port 1 (LAGG Member, Trunk Port)"
  l2mtu                    = 1514
  sfp_shutdown_temperature = 90
}

resource "routeros_interface_ethernet" "kube02-2" {
  factory_name             = "sfp-sfpplus6"
  name                     = "sfp-sfpplus6"
  comment                  = "Kube-02 Port 2 (LAGG Member, Trunk Port)"
  l2mtu                    = 1514
  sfp_shutdown_temperature = 90
}

resource "routeros_interface_ethernet" "kube03-1" {
  factory_name             = "sfp-sfpplus7"
  name                     = "sfp-sfpplus7"
  comment                  = "Kube-03 Port 1 (LAGG Member, Trunk Port)"
  l2mtu                    = 1514
  sfp_shutdown_temperature = 90
}

resource "routeros_interface_ethernet" "kube03-2" {
  factory_name             = "sfp-sfpplus8"
  name                     = "sfp-sfpplus8"
  comment                  = "Kube-03 Port 2 (LAGG Member, Trunk Port)"
  l2mtu                    = 1514
  sfp_shutdown_temperature = 90
}

resource "routeros_interface_ethernet" "pve-1" {
  factory_name             = "sfp-sfpplus9"
  name                     = "sfp-sfpplus9"
  comment                  = "Proxmox Server Port 1 (LAGG Member, Trunk Port)"
  l2mtu                    = 1514
  sfp_shutdown_temperature = 90
}

resource "routeros_interface_ethernet" "pve-2" {
  factory_name             = "sfp-sfpplus10"
  name                     = "sfp-sfpplus10"
  comment                  = "Proxmox Server Port 1 (LAGG Member, Trunk Port)"
  l2mtu                    = 1514
  sfp_shutdown_temperature = 90
}

resource "routeros_interface_ethernet" "sfp-sfpplus11" {
  factory_name             = "sfp-sfpplus11"
  name                     = "sfp-sfpplus11"
  comment                  = ""
  disabled                 = true
  l2mtu                    = 1514
  sfp_shutdown_temperature = 90
}

resource "routeros_interface_ethernet" "sfp-sfpplus12" {
  factory_name             = "sfp-sfpplus12"
  name                     = "sfp-sfpplus12"
  comment                  = ""
  disabled                 = true
  l2mtu                    = 1514
  sfp_shutdown_temperature = 90
}

resource "routeros_interface_ethernet" "sfp-sfpplus13" {
  factory_name             = "sfp-sfpplus13"
  name                     = "sfp-sfpplus13"
  comment                  = ""
  disabled                 = true
  l2mtu                    = 1514
  sfp_shutdown_temperature = 90
}

resource "routeros_interface_ethernet" "mirk-desktop" {
  factory_name             = "sfp-sfpplus14"
  name                     = "sfp-sfpplus14"
  comment                  = "Mirk Desktop 10g Card (Access Port, Trusted VLAN)"
  l2mtu                    = 1514
  sfp_shutdown_temperature = 90
}

resource "routeros_interface_ethernet" "crs326-1" {
  factory_name             = "sfp-sfpplus15"
  name                     = "sfp-sfpplus15"
  comment                  = "Uplink to CRS326 on SFP Port 1 (LAGG Member, Trunk Port)"
  l2mtu                    = 1514
  sfp_shutdown_temperature = 90
}

resource "routeros_interface_ethernet" "crs326-2" {
  factory_name             = "sfp-sfpplus16"
  name                     = "sfp-sfpplus16"
  comment                  = "Uplink to CRS326 on SFP Port 2 (LAGG Member, Trunk Port)"
  l2mtu                    = 1514
  sfp_shutdown_temperature = 90
}

