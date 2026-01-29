include "root" { path = find_in_parent_folders("root.hcl") }
include "provider" { path = find_in_parent_folders("provider.hcl") }

dependencies {
  paths = [find_in_parent_folders("mikrotik/router-rb5009")]
}

locals {
  mikrotik_globals = read_terragrunt_config(find_in_parent_folders("globals.hcl")).locals
}

terraform {
  source = find_in_parent_folders("modules/mikrotik-firewall")
}

inputs = {
  interface_lists = {
    WAN = {
      comment    = "All Public-Facing Interfaces"
      interfaces = ["PPPoE-Digi"]
    }
    LAN = {
      comment = "All Local Interfaces"
      interfaces = concat(
        ["bridge"],
        [for v in local.mikrotik_globals.vlans : v.name]
      )
    }
  }

  nat_rules = {
    "masquerade-wan" = {
      chain              = "srcnat"
      action             = "masquerade"
      out_interface_list = "WAN"
      order              = 100
    }
    "hairpin" = {
      comment            = "Hairpin NAT - allows LAN clients to access services via public IP"
      chain              = "srcnat"
      action             = "masquerade"
      in_interface_list  = "LAN"
      out_interface_list = "LAN"
      order              = 200
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
    "allow-input-icmp" = {
      chain    = "input"
      action   = "accept"
      protocol = "icmp"
      order    = 210
    }
    "accept-router-established-related-untracked" = {
      chain            = "input"
      action           = "accept"
      connection_state = "established,related,untracked"
      order            = 220
    }

    # =========================================================================
    # MANAGEMENT ZONE
    # =========================================================================
    "accept-management-forward" = {
      chain        = "forward"
      action       = "accept"
      in_interface = local.mikrotik_globals.vlans.Management.name
      order        = 1000
    }
    "accept-management-input" = {
      chain        = "input"
      action       = "accept"
      in_interface = local.mikrotik_globals.vlans.Management.name
      order        = 1100
    }

    # =========================================================================
    # TRUSTED ZONE
    # =========================================================================
    "accept-trusted-input" = {
      chain        = "input"
      action       = "accept"
      in_interface = local.mikrotik_globals.vlans.Trusted.name
      order        = 1200
    }
    "accept-trusted-forward" = {
      chain        = "forward"
      action       = "accept"
      in_interface = local.mikrotik_globals.vlans.Trusted.name
      order        = 1300
    }

    # =========================================================================
    # GUEST ZONE
    # =========================================================================
    "allow-guest-to-internet" = {
      chain              = "forward"
      action             = "accept"
      in_interface       = local.mikrotik_globals.vlans.Guest.name
      out_interface_list = "WAN"
      order              = 1600
    }
    "drop-guest-forward" = {
      chain        = "forward"
      action       = "drop"
      in_interface = local.mikrotik_globals.vlans.Guest.name
      order        = 1699
    }
    "drop-guest-input" = {
      chain        = "input"
      action       = "drop"
      in_interface = local.mikrotik_globals.vlans.Guest.name
      order        = 1799
    }

    # =========================================================================
    # UNTRUSTED ZONE
    # =========================================================================
    "allow-untrusted-to-internet" = {
      chain              = "forward"
      action             = "accept"
      in_interface       = local.mikrotik_globals.vlans.Untrusted.name
      out_interface_list = "WAN"
      order              = 1800
    }
    "allow-untrusted-to-services-http" = {
      chain         = "forward"
      action        = "accept"
      in_interface  = local.mikrotik_globals.vlans.Untrusted.name
      out_interface = local.mikrotik_globals.vlans.Services.name
      protocol      = "tcp"
      dst_port      = "80"
      order         = 1801
    }
    "allow-untrusted-to-services-https" = {
      chain         = "forward"
      action        = "accept"
      in_interface  = local.mikrotik_globals.vlans.Untrusted.name
      out_interface = local.mikrotik_globals.vlans.Services.name
      protocol      = "tcp"
      dst_port      = "443"
      order         = 1802
    }
    "allow-untrusted-to-services-hass" = {
      chain         = "forward"
      action        = "accept"
      in_interface  = local.mikrotik_globals.vlans.Untrusted.name
      out_interface = local.mikrotik_globals.vlans.Services.name
      protocol      = "tcp"
      dst_port      = "8123"
      order         = 1803
    }
    "drop-untrusted-forward" = {
      chain        = "forward"
      action       = "drop"
      in_interface = local.mikrotik_globals.vlans.Untrusted.name
      order        = 1899
    }
    "allow-untrusted-dns-tcp" = {
      chain        = "input"
      action       = "accept"
      protocol     = "tcp"
      in_interface = local.mikrotik_globals.vlans.Untrusted.name
      dst_port     = "53"
      order        = 1900
    }
    "allow-untrusted-dns-udp" = {
      chain        = "input"
      action       = "accept"
      protocol     = "udp"
      in_interface = local.mikrotik_globals.vlans.Untrusted.name
      dst_port     = "53"
      order        = 1901
    }
    "drop-untrusted-input" = {
      chain        = "input"
      action       = "drop"
      in_interface = local.mikrotik_globals.vlans.Untrusted.name
      order        = 1999
    }

    # =========================================================================
    # SERVICES ZONE
    # =========================================================================
    "allow-services-to-internet" = {
      chain              = "forward"
      action             = "accept"
      in_interface       = local.mikrotik_globals.vlans.Services.name
      out_interface_list = "WAN"
      order              = 2000
    }
    "allow-hass-to-tesmart" = {
      chain         = "forward"
      action        = "accept"
      in_interface  = local.mikrotik_globals.vlans.Services.name
      out_interface = local.mikrotik_globals.vlans.Management.name
      src_address   = "10.0.10.253"
      dst_address   = "10.0.0.253"
      order         = 2010
    }
    "allow-hass-to-smart-tv" = {
      chain         = "forward"
      action        = "accept"
      in_interface  = local.mikrotik_globals.vlans.Services.name
      out_interface = local.mikrotik_globals.vlans.Untrusted.name
      src_address   = "10.0.10.253"
      dst_address   = "192.168.42.250"
      order         = 2011
    }
    "allow-hass-to-mirkputer" = {
      chain         = "forward"
      action        = "accept"
      in_interface  = local.mikrotik_globals.vlans.Services.name
      out_interface = local.mikrotik_globals.vlans.Trusted.name
      src_address   = "10.0.10.253"
      dst_address   = "192.168.69.69"
      order         = 2012
    }
    "allow-hass-to-untrusted-wol" = {
      chain         = "forward"
      action        = "accept"
      in_interface  = local.mikrotik_globals.vlans.Services.name
      out_interface = local.mikrotik_globals.vlans.Trusted.name
      src_address   = "10.0.10.253"
      dst_address   = "192.168.69.255"
      dst_port      = "9"
      protocol      = "udp"
      order         = 2013
    }
    "drop-services-forward" = {
      chain        = "forward"
      action       = "drop"
      in_interface = local.mikrotik_globals.vlans.Services.name
      order        = 2099
    }
    "allow-services-dns-tcp" = {
      chain        = "input"
      action       = "accept"
      protocol     = "tcp"
      in_interface = local.mikrotik_globals.vlans.Services.name
      dst_port     = "53"
      order        = 2100
    }
    "allow-services-dns-udp" = {
      chain        = "input"
      action       = "accept"
      protocol     = "udp"
      in_interface = local.mikrotik_globals.vlans.Services.name
      dst_port     = "53"
      order        = 2101
    }
    "drop-services-input" = {
      chain        = "input"
      action       = "drop"
      in_interface = local.mikrotik_globals.vlans.Services.name
      order        = 2199
    }

    # =========================================================================
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
