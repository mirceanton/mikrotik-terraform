include "root" { path = find_in_parent_folders("root.hcl") }
include "provider" { path = find_in_parent_folders("provider.hcl") }

dependencies {
  paths = [find_in_parent_folders("mikrotik/router-rb5009")]
}

locals {
  mikrotik_globals = read_terragrunt_config(find_in_parent_folders("globals.hcl")).locals

  wireguard_interface = "wg1"
  pppoe_interface     = "PPPoE-Digi"

  mirkphone_ip     = "172.16.69.11"
  mirkbook_ip      = "172.16.69.14"
  kubernetes_gw_ip = "10.0.10.250"
  mqtt_svc_ip      = "10.0.10.252"
  minecraft_svc_ip = "10.0.10.253"
  nas_svc_ip       = "10.0.10.245"
}

terraform {
  source = "git::https://github.com/mirceanton/terraform-modules-routeros.git//modules/firewall?ref=v0.2.1"
}

inputs = {
  address_lists = {
    "wireguard-trusted" = {
      comment   = "Personal WireGuard devices with trusted-level access"
      addresses = [local.mirkphone_ip, local.mirkbook_ip]
    }
    "exposed-services" = {
      comment = "Services exposed to other VLANs"
      addresses = [
        local.kubernetes_gw_ip,
        local.mqtt_svc_ip,
        local.minecraft_svc_ip,
        local.nas_svc_ip
      ]
    }
  }

  interface_lists = {
    WAN = {
      comment    = "All Public-Facing Interfaces"
      interfaces = [local.pppoe_interface]
    }
    LAN = {
      comment = "All Local Interfaces"
      interfaces = concat(
        ["bridge", local.wireguard_interface],
        [for v in local.mikrotik_globals.vlans : v.name]
      )
    }

    INTERNET_ONLY = {
      comment = "VLANs with internet-only access"
      interfaces = [
        local.mikrotik_globals.vlans.Guest.name,
        local.mikrotik_globals.vlans.Untrusted.name,
        local.mikrotik_globals.vlans.Management.name
      ]
    }
    CLIENTS = {
      comment = "VLANs allowed limited access to exposed services"
      interfaces = [local.mikrotik_globals.vlans.Untrusted.name,
        local.mikrotik_globals.vlans.Management.name,
        local.wireguard_interface
      ]
    }
  }

  nat_rules = {
    "masquerade-wan" = {
      chain              = "srcnat"
      action             = "masquerade"
      out_interface_list = "WAN"
      order              = 100
    }
  }

  filter_rules = {
    # =========================================================================
    # GLOBAL RULES - Forward Chain
    # =========================================================================
    "fasttrack" = {
      chain            = "forward"
      action           = "fasttrack-connection"
      connection_state = "established,related"
      hw_offload       = true
      order            = 100
    }
    "accept-established-related-untracked-forward" = {
      chain            = "forward"
      action           = "accept"
      connection_state = "established,related,untracked"
      order            = 110
    }
    "asymmetric-routing-fix-trusted-to-mgmt" = {
      chain            = "forward"
      action           = "accept"
      connection_state = "invalid"
      in_interface     = local.mikrotik_globals.vlans.Trusted.name
      out_interface    = local.mikrotik_globals.vlans.Management.name
      order            = 120
    }
    "asymmetric-routing-fix-trusted-to-svc" = {
      chain            = "forward"
      action           = "accept"
      connection_state = "invalid"
      in_interface     = local.mikrotik_globals.vlans.Trusted.name
      out_interface    = local.mikrotik_globals.vlans.Services.name
      order            = 121
    }
    "asymmetric-routing-fix-mgmt-to-svc" = {
      chain            = "forward"
      action           = "accept"
      connection_state = "invalid"
      in_interface     = local.mikrotik_globals.vlans.Management.name
      out_interface    = local.mikrotik_globals.vlans.Services.name
      order            = 122
    }
    "drop-invalid-forward" = {
      chain            = "forward"
      action           = "drop"
      connection_state = "invalid"
      order            = 130
    }

    # =========================================================================
    # GLOBAL RULES - Input Chain
    # =========================================================================
    "accept-capsman-loopback" = {
      chain       = "input"
      action      = "accept"
      dst_address = "127.0.0.1"
      order       = 200
    }
    "allow-LAN-icmp" = {
      chain             = "input"
      action            = "accept"
      protocol          = "icmp"
      in_interface_list = "LAN"
      order             = 210
    }
    "allow-LAN-dhcp-67" = {
      chain             = "input"
      action            = "accept"
      protocol          = "udp"
      dst_port          = "67"
      in_interface_list = "LAN"
      order             = 211
    }
    "allow-LAN-dhcp-68" = {
      chain             = "input"
      action            = "accept"
      protocol          = "udp"
      dst_port          = "68"
      in_interface_list = "LAN"
      order             = 212
    }
    "allow-LAN-dns-tcp" = {
      chain             = "input"
      action            = "accept"
      protocol          = "tcp"
      dst_port          = "53"
      in_interface_list = "LAN"
      order             = 213
    }
    "allow-LAN-dns-udp" = {
      chain             = "input"
      action            = "accept"
      protocol          = "udp"
      dst_port          = "53"
      in_interface_list = "LAN"
      order             = 214
    }
    "allow-wireguard-input" = {
      chain    = "input"
      action   = "accept"
      protocol = "udp"
      dst_port = "13231"
      order    = 215
    }
    "accept-router-established-related-untracked" = {
      chain            = "input"
      action           = "accept"
      connection_state = "established,related,untracked"
      order            = 220
    }

    # =========================================================================
    # ZONE-BASED RULES
    # =========================================================================
    "allow-MANAGEMENT-input" = {
      chain        = "input"
      action       = "accept"
      in_interface = local.mikrotik_globals.vlans.Management.name
      order        = 1100
    }
    "allow-MANAGEMENT-to-LAN" = {
      chain              = "forward"
      action             = "accept"
      in_interface       = local.mikrotik_globals.vlans.Management.name
      out_interface_list = "LAN"
      order              = 1110
    }

    "allow-WG-TRUSTED-input" = {
      chain            = "input"
      action           = "accept"
      in_interface     = local.wireguard_interface
      src_address_list = "wireguard-trusted"
      order            = 1200
    }
    "allow-WG-TRUSTED-to-LAN" = {
      chain              = "forward"
      action             = "accept"
      in_interface       = local.wireguard_interface
      src_address_list   = "wireguard-trusted"
      out_interface_list = "LAN"
      order              = 1300
    }

    "allow-INTERNET_ONLY-to-internet" = {
      chain              = "forward"
      action             = "accept"
      in_interface_list  = "INTERNET_ONLY"
      out_interface_list = "WAN"
      order              = 1400
    }
    "allow-CLIENTS-to-services" = {
      chain             = "forward"
      action            = "accept"
      in_interface_list = "CLIENTS"
      out_interface     = local.mikrotik_globals.vlans.Services.name
      dst_address_list  = "exposed-services"
      order             = 1401
    }

    # ========================================================================
    # DEFAULT DENY
    # =========================================================================
    "drop-all-forward" = {
      chain        = "forward"
      action       = "drop"
      in_interface = "!${local.mikrotik_globals.vlans.Trusted.name}"
      order        = 9000
    }
    "drop-all-input" = {
      chain        = "input"
      action       = "drop"
      in_interface = "!${local.mikrotik_globals.vlans.Trusted.name}"
      order        = 9010
    }
  }
}
