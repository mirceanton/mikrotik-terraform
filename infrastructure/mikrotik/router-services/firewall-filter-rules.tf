locals {
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
    "truenas-asymmetric-routing-fix" = {
      chain            = "forward"
      action           = "accept"
      connection_state = "invalid"
      in_interface     = local.vlans.Trusted.name
      out_interface    = local.vlans.Management.name
      dst_address      = "10.0.0.245"
      order            = 120
    }
    "drop-invalid-forward" = {
      chain            = "forward"
      action           = "drop"
      connection_state = "invalid"
      order            = 130
      # log              = true
      # log_prefix       = "DROPPED INVALID:"
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
      in_interface = local.vlans.Management.name
      order        = 1000
    }
    "accept-management-input" = {
      chain        = "input"
      action       = "accept"
      in_interface = local.vlans.Management.name
      order        = 1100
    }

    # =========================================================================
    # TRUSTED ZONE
    # =========================================================================
    "accept-trusted-input" = {
      chain        = "input"
      action       = "accept"
      in_interface = local.vlans.Trusted.name
      order        = 1200
    }
    "accept-trusted-forward" = {
      chain        = "forward"
      action       = "accept"
      in_interface = local.vlans.Trusted.name
      order        = 1300
    }

    # =========================================================================
    # ZEROTIER ZONE
    # =========================================================================
    "allow-zerotier-dns-tcp" = {
      chain        = "input"
      action       = "accept"
      protocol     = "tcp"
      dst_port     = "53"
      in_interface = routeros_zerotier_interface.zerotier1.name
      order        = 1400
    }
    "allow-zerotier-dns-udp" = {
      chain        = "input"
      action       = "accept"
      protocol     = "udp"
      dst_port     = "53"
      in_interface = routeros_zerotier_interface.zerotier1.name
      order        = 1401
    }
    "drop-zerotier-input" = {
      chain        = "input"
      action       = "drop"
      in_interface = routeros_zerotier_interface.zerotier1.name
      order        = 1499
    }

    "allow-zerotier-to-services-http" = {
      chain         = "forward"
      action        = "accept"
      in_interface  = routeros_zerotier_interface.zerotier1.name
      out_interface = local.vlans.Services.name
      protocol      = "tcp"
      dst_port      = "80"
      order         = 1500
    }
    "allow-zerotier-to-services-https" = {
      chain         = "forward"
      action        = "accept"
      in_interface  = routeros_zerotier_interface.zerotier1.name
      out_interface = local.vlans.Services.name
      protocol      = "tcp"
      dst_port      = "443"
      order         = 1501
    }
    "allow-zerotier-to-services-hass" = {
      chain         = "forward"
      action        = "accept"
      in_interface  = routeros_zerotier_interface.zerotier1.name
      out_interface = local.vlans.Services.name
      protocol      = "tcp"
      dst_port      = "8123"
      order         = 1502
    }
    "drop-zerotier-forward" = {
      chain        = "forward"
      action       = "drop"
      in_interface = routeros_zerotier_interface.zerotier1.name
      order        = 1599
    }

    # =========================================================================
    # GUEST ZONE
    # =========================================================================
    "allow-guest-to-internet" = {
      chain              = "forward"
      action             = "accept"
      in_interface       = local.vlans.Guest.name
      out_interface_list = routeros_interface_list.wan.name
      order              = 1600
    }
    "drop-guest-forward" = {
      chain        = "forward"
      action       = "drop"
      in_interface = local.vlans.Guest.name
      order        = 1699
      # log          = true
      # log_prefix   = "DROPPED GUEST FORWARD:"
    }
    "drop-guest-input" = {
      chain        = "input"
      action       = "drop"
      in_interface = local.vlans.Guest.name
      order        = 1799
      # log          = true
      # log_prefix   = "DROPPED GUEST INPUT:"
    }

    # =========================================================================
    # UNTRUSTED ZONE
    # =========================================================================
    "allow-untrusted-to-internet" = {
      chain              = "forward"
      action             = "accept"
      in_interface       = local.vlans.Untrusted.name
      out_interface_list = routeros_interface_list.wan.name
      order              = 1800
    }
    "allow-untrusted-to-services-http" = {
      chain         = "forward"
      action        = "accept"
      in_interface  = local.vlans.Untrusted.name
      out_interface = local.vlans.Services.name
      protocol      = "tcp"
      dst_port      = "80"
      order         = 1801
    }
    "allow-untrusted-to-services-https" = {
      chain         = "forward"
      action        = "accept"
      in_interface  = local.vlans.Untrusted.name
      out_interface = local.vlans.Services.name
      protocol      = "tcp"
      dst_port      = "443"
      order         = 1802
    }
    "allow-untrusted-to-services-hass" = {
      chain         = "forward"
      action        = "accept"
      in_interface  = local.vlans.Untrusted.name
      out_interface = local.vlans.Services.name
      protocol      = "tcp"
      dst_port      = "8123"
      order         = 1803
    }
    "drop-untrusted-forward" = {
      chain        = "forward"
      action       = "drop"
      in_interface = local.vlans.Untrusted.name
      order        = 1899
      # log          = true
      # log_prefix   = "DROPPED Untrusted FORWARD:"
    }

    "allow-untrusted-dns-tcp" = {
      chain        = "input"
      action       = "accept"
      protocol     = "tcp"
      in_interface = local.vlans.Untrusted.name
      dst_port     = "53"
      order        = 1900
    }
    "allow-untrusted-dns-udp" = {
      chain        = "input"
      action       = "accept"
      protocol     = "udp"
      in_interface = local.vlans.Untrusted.name
      dst_port     = "53"
      order        = 1901
    }
    "drop-untrusted-input" = {
      chain        = "input"
      action       = "drop"
      in_interface = local.vlans.Untrusted.name
      order        = 1999
      # log          = true
      # log_prefix   = "DROPPED Untrusted INPUT:"
    }

    # =========================================================================
    # SERVICES ZONE
    # =========================================================================
    "allow-services-to-internet" = {
      chain              = "forward"
      action             = "accept"
      in_interface       = local.vlans.Services.name
      out_interface_list = routeros_interface_list.wan.name
      order              = 2000
    }
    "allow-hass-to-tesmart" = {
      chain         = "forward"
      action        = "accept"
      in_interface  = local.vlans.Services.name
      out_interface = local.vlans.Management.name
      src_address   = "10.0.10.253" # FIXME should use some sort of reference
      dst_address   = "10.0.0.253"  # FIXME should use some sort of reference
      order         = 2010
    }
    "allow-hass-to-smart-tv" = {
      chain         = "forward"
      action        = "accept"
      in_interface  = local.vlans.Services.name
      out_interface = local.vlans.Untrusted.name
      src_address   = "10.0.10.253"    # FIXME should use some sort of reference
      dst_address   = "192.168.42.250" # FIXME should use some sort of reference
      order         = 2011
    }
    "allow-hass-to-mirkputer" = {
      chain         = "forward"
      action        = "accept"
      in_interface  = local.vlans.Services.name
      out_interface = local.vlans.Trusted.name
      src_address   = "10.0.10.253"   # FIXME should use some sort of reference
      dst_address   = "192.168.69.69" # FIXME should use some sort of reference
      order         = 2012
    }
    "allow-hass-to-untrusted-wol" = {
      chain         = "forward"
      action        = "accept"
      in_interface  = local.vlans.Services.name
      out_interface = local.vlans.Trusted.name
      src_address   = "10.0.10.253"    # FIXME should use some sort of reference
      dst_address   = "192.168.69.255" # FIXME should use some sort of reference
      dst_port      = "9"
      protocol      = "udp"
      order         = 2013
    }
    "drop-services-forward" = {
      chain        = "forward"
      action       = "drop"
      in_interface = local.vlans.Services.name
      order        = 2099
    }
    "allow-services-dns-tcp" = {
      chain        = "input"
      action       = "accept"
      protocol     = "tcp"
      in_interface = local.vlans.Services.name
      dst_port     = "53"
      order        = 2100
    }
    "allow-services-dns-udp" = {
      chain        = "input"
      action       = "accept"
      protocol     = "udp"
      in_interface = local.vlans.Services.name
      dst_port     = "53"
      order        = 2101
    }
    "drop-services-input" = {
      chain        = "input"
      action       = "drop"
      in_interface = local.vlans.Services.name
      order        = 2199
    }

    # =========================================================================
    # DEFAULT DENY
    # =========================================================================
    "drop-all-forward" = {
      chain        = "forward"
      action       = "drop"
      in_interface = "!${local.vlans.Trusted.name}"
      order        = 9000
    }
    "drop-all-input" = {
      chain        = "input"
      action       = "drop"
      in_interface = "!${local.vlans.Trusted.name}"
      order        = 9010
    }
  }

  # Convert to ordered list for move_items
  # Create entries with sort keys based on order field
  filter_rules_ordered = [
    for k, v in local.filter_rules : merge(v, {
      key      = k
      sort_key = format("%04d-%s", v.order, k)
    })
  ]

  # Create a map with lexicographically sortable keys for for_each
  # Map keys are always iterated in lexicographical order
  filter_rules_map = {
    for rule in local.filter_rules_ordered :
    rule.sort_key => rule
  }
}

# =================================================================================================
# Firewall Filter Rules
# =================================================================================================
resource "routeros_ip_firewall_filter" "rules" {
  for_each = local.filter_rules_map

  comment = "Managed by Terrform - ${each.value.key}"
  chain   = each.value.chain
  action  = each.value.action

  # Optional fields - only set if present in rule definition
  connection_state   = lookup(each.value, "connection_state", null)
  in_interface       = lookup(each.value, "in_interface", null)
  out_interface      = lookup(each.value, "out_interface", null)
  in_interface_list  = lookup(each.value, "in_interface_list", null)
  out_interface_list = lookup(each.value, "out_interface_list", null)
  protocol           = lookup(each.value, "protocol", null)
  dst_port           = lookup(each.value, "dst_port", null)
  src_port           = lookup(each.value, "src_port", null)
  src_address        = lookup(each.value, "src_address", null)
  dst_address        = lookup(each.value, "dst_address", null)
  jump_target        = lookup(each.value, "jump_target", null)
  hw_offload         = lookup(each.value, "hw_offload", null)

  lifecycle {
    create_before_destroy = true
  }
}

# Move rules to correct order after creation
resource "routeros_move_items" "firewall_rules" {
  resource_path = "/ip/firewall/filter"
  sequence      = [for idx in sort(keys(local.filter_rules_map)) : routeros_ip_firewall_filter.rules[idx].id]
  depends_on    = [routeros_ip_firewall_filter.rules]
}