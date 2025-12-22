locals {
  zerotier_rb5009_ip = "172.29.0.1"
}

resource "zerotier_identity" "identity" {}

resource "zerotier_network" "homelab" {
  name        = "Homelab"
  description = "Managed by Terraform from mikrotik-terraform"
  private     = true # Members need manual approval

  dns {
    domain  = "zt.h.mirceanton.com"
    servers = [local.zerotier_rb5009_ip]
  }

  route {
    target = "${var.vlans.Services.network}/${var.vlans.Services.cidr_suffix}"
    via    = local.zerotier_rb5009_ip
  }
  route {
    target = "192.168.10.0/24" # Parent network
    via    = "172.29.0.2"      # cAP AX Parents zerotier IP
  }
  route {
    target = "172.29.0.0/24" # default zerotier managed range
  }

  assignment_pool {
    start = "172.29.0.1"
    end   = "172.29.0.254"
  }

  assign_ipv4 {
    zerotier = true
  }
  assign_ipv6 {
    zerotier = false
    sixplane = false
    rfc4193  = false
  }

  lifecycle {
    ignore_changes = [flow_rules] #FIXME
  }
}

resource "routeros_zerotier" "zt1" {
  name       = "zt1"
  comment    = "ZeroTier Central"
  identity   = zerotier_identity.identity.private_key
  interfaces = ["all"]
  port       = 9993
}

resource "routeros_zerotier_interface" "zerotier1" {
  instance = routeros_zerotier.zt1.name
  name     = "zerotier1"
  network  = zerotier_network.homelab.id

  allow_default = false
  allow_global  = false
  allow_managed = true
}

resource "zerotier_member" "this" {
  member_id        = zerotier_identity.identity.id
  network_id       = zerotier_network.homelab.id
  name             = "RB5009"
  authorized       = true
  ipv4_assignments = [local.zerotier_rb5009_ip]
}
