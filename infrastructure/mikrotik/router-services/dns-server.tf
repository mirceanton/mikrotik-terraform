# =================================================================================================
# DNS Server
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_dns
# =================================================================================================
resource "routeros_ip_dns" "dns-server" {
  allow_remote_requests = true
  servers               = ["1.1.1.1", "8.8.8.8"]
  cache_size            = 8192
  cache_max_ttl         = "1d"
}

# =================================================================================================
# AdList
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_dns_adlist
# =================================================================================================
resource "routeros_ip_dns_adlist" "dns_blocker" {
  url        = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
  ssl_verify = false
}

# =================================================================================================
# Static DNS Records
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_dns_record
# =================================================================================================
locals {
  static_dns = {
    # Others
    "odroidc4.mgmt.h.mirceanton.com" = { address = "10.0.0.250", type = "A", comment = "Odroid C4 GH Runners" },
    "bmc.nas.mgmt.h.mirceanton.com"  = { address = "10.0.0.10", type = "A", comment = "TrueNAS BMC" },

    # TrueNAS
    "nas.trst.h.mirceanton.com"  = { address = "192.168.69.245", type = "A", comment = "TrueNAS Trusted" },
    "nas.utrst.h.mirceanton.com" = { address = "192.168.42.245", type = "A", comment = "TrueNAS Untrusted" },
    "nas.svc.h.mirceanton.com"   = { address = "10.0.10.245", type = "A", comment = "TrueNAS Services" },
    "nas.mgmt.h.mirceanton.com"  = { address = "10.0.0.245", type = "A", comment = "TrueNAS Servers" },
    "nas.stor.h.mirceanton.com"  = { address = "10.255.255.245", type = "A", comment = "TrueNAS Servers" },

    # KVM
    "kvm.mgmt.h.mirceanton.com"     = { address = "10.0.0.254", type = "A", comment = "JetKVM Web UI" },
    "tesmart.mgmt.h.mirceanton.com" = { address = "10.0.0.253", type = "A", comment = "TeSmart KVM" },

    # HomeAssistant
    "hass.home.mirceanton.com"  = { address = "10.0.10.253", type = "A", comment = "HomeAssistant Odroid" },
    "hass.svc.h.mirceanton.com" = { address = "10.0.10.253", type = "A", comment = "HomeAssistant Odroid" },

    # Proxmox
    "pve.mgmt.h.mirceanton.com"   = { address = "10.0.0.20", type = "A", comment = "Proxmox Cluster Management Interface" },
    "pve01.mgmt.h.mirceanton.com" = { address = "10.0.0.21", type = "A", comment = "Proxmox Node 1 Management Interface" },
    "pve02.mgmt.h.mirceanton.com" = { address = "10.0.0.22", type = "A", comment = "Proxmox Node 2 Management Interface" },
    "pve03.mgmt.h.mirceanton.com" = { address = "10.0.0.23", type = "A", comment = "Proxmox Node 3 Management Interface" },

    "pve01.stor.h.mirceanton.com" = { address = "10.255.255.21", type = "A", comment = "Proxmox Node 1 Storage Interface" },
    "pve02.stor.h.mirceanton.com" = { address = "10.255.255.22", type = "A", comment = "Proxmox Node 2 Storage Interface" },
    "pve03.stor.h.mirceanton.com" = { address = "10.255.255.23", type = "A", comment = "Proxmox Node 3 Storage Interface" },
  }
}

resource "routeros_ip_dns_record" "static" {
  for_each = local.static_dns

  name    = each.key
  address = each.value.address
  comment = each.value.comment
  type    = each.value.type
}
