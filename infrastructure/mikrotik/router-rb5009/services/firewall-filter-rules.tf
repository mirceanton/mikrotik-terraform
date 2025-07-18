# =================================================================================================
# Firewall Rules
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_firewall_filter
# =================================================================================================
# Global Rules
resource "routeros_ip_firewall_filter" "fasttrack" {
  comment          = "Fasttrack"
  action           = "fasttrack-connection"
  chain            = "forward"
  connection_state = "established,related"
  hw_offload       = true
  place_before     = routeros_ip_firewall_filter.accept_established_related_untracked_forward.id
}
resource "routeros_ip_firewall_filter" "accept_established_related_untracked_forward" {
  comment          = "Allow established, related, untracked"
  action           = "accept"
  chain            = "forward"
  connection_state = "established,related,untracked"
  place_before     = routeros_ip_firewall_filter.truenas_asymmetric_routing_fix.id
}
resource "routeros_ip_firewall_filter" "truenas_asymmetric_routing_fix" {
  comment          = "TrueNAS Asymmetric Routing Fix"
  action           = "accept"
  chain            = "forward"
  connection_state = "invalid"
  in_interface     = local.vlans.Trusted.name
  out_interface    = local.vlans.Management.name
  place_before     = routeros_ip_firewall_filter.drop_invalid_forward.id
}
resource "routeros_ip_firewall_filter" "drop_invalid_forward" {
  comment          = "Drop invalid"
  action           = "drop"
  chain            = "forward"
  connection_state = "invalid"
  place_before     = routeros_ip_firewall_filter.accept_capsman_loopback.id
  # log              = true
  # log_prefix       = "DROPPED INVALID:"
}
resource "routeros_ip_firewall_filter" "accept_capsman_loopback" {
  comment      = "Accept to local loopback for CAPsMAN"
  action       = "accept"
  chain        = "input"
  dst_address  = "127.0.0.1"
  place_before = routeros_ip_firewall_filter.allow_input_icmp.id
}
resource "routeros_ip_firewall_filter" "allow_input_icmp" {
  comment      = "Allow input ICMP"
  action       = "accept"
  chain        = "input"
  protocol     = "icmp"
  place_before = routeros_ip_firewall_filter.accept_router_established_related_untracked.id
}
resource "routeros_ip_firewall_filter" "accept_router_established_related_untracked" {
  comment          = "Allow established, related, untracked to router"
  action           = "accept"
  chain            = "input"
  connection_state = "established,related,untracked"
  place_before     = routeros_ip_firewall_filter.allow_wireguard_connections.id
}


# ===============================================
# WIREGUARD
# ===============================================
# INPUT CHAIN
resource "routeros_ip_firewall_filter" "allow_wireguard_connections" {
  comment      = "Allow Wireguard Incoming Connections"
  action       = "accept"
  chain        = "input"
  protocol     = "udp"
  dst_port     = routeros_interface_wireguard.wireguard.listen_port
  place_before = routeros_ip_firewall_filter.allow_wireguard_dns_tcp.id
}
resource "routeros_ip_firewall_filter" "allow_wireguard_dns_tcp" {
  comment      = "Allow local DNS (TCP) for Wireguard"
  action       = "accept"
  chain        = "input"
  protocol     = "tcp"
  in_interface = routeros_interface_wireguard.wireguard.name
  dst_port     = "53"
  place_before = routeros_ip_firewall_filter.allow_wireguard_dns_udp.id
}
resource "routeros_ip_firewall_filter" "allow_wireguard_dns_udp" {
  comment      = "Allow local DNS (UDP) for Wireguard"
  action       = "accept"
  chain        = "input"
  protocol     = "udp"
  in_interface = routeros_interface_wireguard.wireguard.name
  dst_port     = "53"
  place_before = routeros_ip_firewall_filter.drop_wireguard_input.id
}
resource "routeros_ip_firewall_filter" "drop_wireguard_input" {
  comment      = "Drop all Wireguard input"
  action       = "drop"
  chain        = "input"
  in_interface = routeros_interface_wireguard.wireguard.name
  place_before = routeros_ip_firewall_filter.allow_wireguard_to_internet.id
}

# FORWARD CHAIN
resource "routeros_ip_firewall_filter" "allow_wireguard_to_internet" {
  comment            = "Allow Wireguard to Internet"
  action             = "accept"
  chain              = "forward"
  in_interface       = routeros_interface_wireguard.wireguard.name
  out_interface_list = routeros_interface_list.wan.name
  place_before       = routeros_ip_firewall_filter.allow_wireguard_to_services.id
}
resource "routeros_ip_firewall_filter" "allow_wireguard_to_services" {
  comment          = "Allow Wireguard to Services"
  action           = "accept"
  chain            = "forward"
  in_interface     = routeros_interface_wireguard.wireguard.name
  out_interface    = local.vlans.Services.name
  dst_address_list = routeros_ip_firewall_addr_list.services.list
  place_before     = routeros_ip_firewall_filter.drop_wireguard_forward.id
}
resource "routeros_ip_firewall_filter" "drop_wireguard_forward" {
  comment      = "Drop all Wireguard forward"
  action       = "drop"
  chain        = "forward"
  in_interface = routeros_interface_wireguard.wireguard.name
  place_before = routeros_ip_firewall_filter.accept_trusted_input.id
}


# ===============================================
# TRUSTED
# ===============================================
# INPUT CHAIN
resource "routeros_ip_firewall_filter" "accept_trusted_input" {
  comment      = "Accept all Trusted input"
  action       = "accept"
  chain        = "input"
  in_interface = local.vlans.Trusted.name
  place_before = routeros_ip_firewall_filter.accept_trusted_forward.id
}

# FORWARD CHAIN
resource "routeros_ip_firewall_filter" "accept_trusted_forward" {
  comment      = "Accept all Trusted forward"
  action       = "accept"
  chain        = "forward"
  in_interface = local.vlans.Trusted.name
  place_before = routeros_ip_firewall_filter.allow_guest_to_internet.id
}

# ===============================================
# GUEST
# ===============================================
# FORWARD CHAIN
resource "routeros_ip_firewall_filter" "allow_guest_to_internet" {
  comment            = "Allow Guest to Internet"
  action             = "accept"
  chain              = "forward"
  in_interface       = local.vlans.Guest.name
  out_interface_list = routeros_interface_list.wan.name
  place_before       = routeros_ip_firewall_filter.drop_guest_forward.id
}
resource "routeros_ip_firewall_filter" "drop_guest_forward" {
  comment      = "Drop all Guest forward"
  action       = "drop"
  chain        = "forward"
  in_interface = local.vlans.Guest.name
  place_before = routeros_ip_firewall_filter.drop_guest_input.id
  # log          = true
  # log_prefix   = "DROPPED GUEST FORWARD:"
}

# INPUT CHAIN
resource "routeros_ip_firewall_filter" "drop_guest_input" {
  comment      = "Drop all Guest input"
  action       = "drop"
  chain        = "input"
  in_interface = local.vlans.Guest.name
  place_before = routeros_ip_firewall_filter.allow_untrusted_to_internet.id
  # log          = true
  # log_prefix   = "DROPPED GUEST INPUT:"
}


# ===============================================
# UNTRUSTED
# ===============================================
# FORWARD CHAIN
resource "routeros_ip_firewall_filter" "allow_untrusted_to_internet" {
  comment            = "Allow Untrusted to Internet"
  action             = "accept"
  chain              = "forward"
  in_interface       = local.vlans.Untrusted.name
  out_interface_list = routeros_interface_list.wan.name
  place_before       = routeros_ip_firewall_filter.allow_untrusted_to_services.id
}
resource "routeros_ip_firewall_filter" "allow_untrusted_to_services" {
  comment          = "Allow Untrusted to Services"
  action           = "accept"
  chain            = "forward"
  in_interface     = local.vlans.Untrusted.name
  out_interface    = local.vlans.Services.name
  dst_address_list = routeros_ip_firewall_addr_list.services.list
  place_before     = routeros_ip_firewall_filter.drop_untrusted_forward.id
}
resource "routeros_ip_firewall_filter" "drop_untrusted_forward" {
  comment      = "Drop all Untrusted forward"
  action       = "drop"
  chain        = "forward"
  in_interface = local.vlans.Untrusted.name
  place_before = routeros_ip_firewall_filter.allow_untrusted_dns_tcp.id
  # log          = true
  # log_prefix   = "DROPPED Untrusted FORWARD:"
}

# INPUT CHAIN
resource "routeros_ip_firewall_filter" "allow_untrusted_dns_tcp" {
  comment      = "Allow local DNS (TCP) for Untrusted"
  action       = "accept"
  chain        = "input"
  protocol     = "tcp"
  in_interface = local.vlans.Untrusted.name
  dst_port     = "53"
  place_before = routeros_ip_firewall_filter.allow_untrusted_dns_udp.id
}
resource "routeros_ip_firewall_filter" "allow_untrusted_dns_udp" {
  comment      = "Allow local DNS (UDP) for Untrusted"
  action       = "accept"
  chain        = "input"
  protocol     = "udp"
  in_interface = local.vlans.Untrusted.name
  dst_port     = "53"
  place_before = routeros_ip_firewall_filter.drop_untrusted_input.id
}
resource "routeros_ip_firewall_filter" "drop_untrusted_input" {
  comment      = "Drop all Untrusted input"
  action       = "drop"
  chain        = "input"
  in_interface = local.vlans.Untrusted.name
  place_before = routeros_ip_firewall_filter.allow_servers_to_internet.id
  # log          = true
  # log_prefix   = "DROPPED Untrusted INPUT:"
}


# ===============================================
# SERVERS
# ===============================================
# FORWARD CHAIN
resource "routeros_ip_firewall_filter" "allow_servers_to_internet" {
  comment            = "Allow Servers to Internet"
  action             = "accept"
  chain              = "forward"
  in_interface       = local.vlans.Management.name
  out_interface_list = routeros_interface_list.wan.name
  place_before       = routeros_ip_firewall_filter.drop_servers_forward.id
}
resource "routeros_ip_firewall_filter" "drop_servers_forward" {
  comment      = "Drop all Servers forward"
  action       = "drop"
  chain        = "forward"
  in_interface = local.vlans.Management.name
  place_before = routeros_ip_firewall_filter.allow_servers_dns_tcp.id
  # log          = true
  # log_prefix   = "DROPPED Servers FORWARD:"
}

# INPUT CHAIN
resource "routeros_ip_firewall_filter" "allow_servers_dns_tcp" {
  comment      = "Allow local DNS (TCP) for Servers"
  action       = "accept"
  chain        = "input"
  protocol     = "tcp"
  in_interface = local.vlans.Management.name
  dst_port     = "53"
  place_before = routeros_ip_firewall_filter.allow_servers_dns_udp.id
}
resource "routeros_ip_firewall_filter" "allow_servers_dns_udp" {
  comment      = "Allow local DNS (UDP) for Servers"
  action       = "accept"
  chain        = "input"
  protocol     = "udp"
  in_interface = local.vlans.Management.name
  dst_port     = "53"
  place_before = routeros_ip_firewall_filter.drop_servers_input.id
}
resource "routeros_ip_firewall_filter" "drop_servers_input" {
  comment      = "Drop all Servers input"
  action       = "drop"
  chain        = "input"
  in_interface = local.vlans.Management.name
  place_before = routeros_ip_firewall_filter.allow_services_to_internet.id
  # log          = true
  # log_prefix   = "DROPPED Servers INPUT:"
}


# ===============================================
# Services
# ===============================================
# FORWARD CHAIN
resource "routeros_ip_firewall_filter" "allow_services_to_internet" {
  comment            = "Allow Services to Internet"
  action             = "accept"
  chain              = "forward"
  in_interface       = local.vlans.Services.name
  out_interface_list = routeros_interface_list.wan.name
  place_before       = routeros_ip_firewall_filter.drop_services_forward.id
}
resource "routeros_ip_firewall_filter" "drop_services_forward" {
  comment      = "Drop all Services forward"
  action       = "drop"
  chain        = "forward"
  in_interface = local.vlans.Services.name
  place_before = routeros_ip_firewall_filter.allow_services_dns_tcp.id
}

# INPUT CHAIN
resource "routeros_ip_firewall_filter" "allow_services_dns_tcp" {
  comment      = "Allow local DNS (TCP) for Services"
  action       = "accept"
  chain        = "input"
  protocol     = "tcp"
  in_interface = local.vlans.Services.name
  dst_port     = "53"
  place_before = routeros_ip_firewall_filter.allow_services_dns_udp.id
}
resource "routeros_ip_firewall_filter" "allow_services_dns_udp" {
  comment      = "Allow local DNS (UDP) for Services"
  action       = "accept"
  chain        = "input"
  protocol     = "udp"
  in_interface = local.vlans.Services.name
  dst_port     = "53"
  place_before = routeros_ip_firewall_filter.drop_services_input.id
}
resource "routeros_ip_firewall_filter" "drop_services_input" {
  comment      = "Drop all Services input"
  action       = "drop"
  chain        = "input"
  in_interface = local.vlans.Services.name
  place_before = routeros_ip_firewall_filter.drop_all_forward.id
}


# ===============================================
# DEFAULT DENY
# ===============================================
resource "routeros_ip_firewall_filter" "drop_all_forward" {
  comment      = "Drop all forward not from Trusted"
  action       = "drop"
  chain        = "forward"
  in_interface = "!${local.vlans.Trusted.name}"
  place_before = routeros_ip_firewall_filter.drop_all_input.id
}
resource "routeros_ip_firewall_filter" "drop_all_input" {
  comment      = "Drop all input not from Trusted"
  action       = "drop"
  chain        = "input"
  in_interface = "!${local.vlans.Trusted.name}"
}
