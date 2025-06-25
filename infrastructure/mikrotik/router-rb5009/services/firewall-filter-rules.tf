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
  in_interface     = "Trusted"
  out_interface    = "Servers"
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

# WIREGUARD
resource "routeros_ip_firewall_filter" "allow_wireguard_connections" {
  comment      = "Allow Wireguard Incoming Connections"
  action       = "accept"
  chain        = "input"
  protocol     = "udp"
  dst_port     = routeros_interface_wireguard.wireguard.listen_port
  place_before = routeros_ip_firewall_filter.allow_wireguard_to_internet.id
}

resource "routeros_ip_firewall_filter" "allow_wireguard_to_internet" {
  comment            = "Allow Wireguard to Internet"
  action             = "accept"
  chain              = "forward"
  in_interface       = routeros_interface_wireguard.wireguard.name
  out_interface_list = routeros_interface_list.wan.name
  place_before       = routeros_ip_firewall_filter.allow_wireguard_to_untrusted.id
}
resource "routeros_ip_firewall_filter" "allow_wireguard_to_untrusted" {
  comment       = "Allow Wireguard to Untrusted"
  action        = "accept"
  chain         = "forward"
  in_interface  = routeros_interface_wireguard.wireguard.name
  out_interface = local.vlans.Untrusted.name
  place_before  = routeros_ip_firewall_filter.allow_wireguard_to_k8s.id
}
resource "routeros_ip_firewall_filter" "allow_wireguard_to_k8s" {
  comment          = "Allow Wireguard to K8S Services"
  action           = "accept"
  chain            = "forward"
  in_interface     = routeros_interface_wireguard.wireguard.name
  out_interface    = local.vlans.Services.name
  dst_address_list = routeros_ip_firewall_addr_list.k8s_services.list
  place_before     = routeros_ip_firewall_filter.drop_wireguard_forward.id
}
resource "routeros_ip_firewall_filter" "drop_wireguard_forward" {
  comment      = "Drop all Wireguard forward"
  action       = "drop"
  chain        = "forward"
  in_interface = routeros_interface_wireguard.wireguard.name
  place_before = routeros_ip_firewall_filter.allow_wireguard_dns_tcp.id
}
resource "routeros_ip_firewall_filter" "allow_wireguard_dns_tcp" {
  comment      = "Allow local DNS (TCP) for Wireguard"
  action       = "accept"
  chain        = "input"
  protocol     = "tcp"
  in_interface = routeros_interface_wireguard.wireguard.name
  place_before = routeros_ip_firewall_filter.allow_wireguard_dns_udp.id
}
resource "routeros_ip_firewall_filter" "allow_wireguard_dns_udp" {
  comment      = "Allow local DNS (UDP) for Wireguard"
  action       = "accept"
  chain        = "input"
  protocol     = "udp"
  in_interface = routeros_interface_wireguard.wireguard.name
  place_before = routeros_ip_firewall_filter.drop_wireguard_input.id
}
resource "routeros_ip_firewall_filter" "drop_wireguard_input" {
  comment      = "Drop all Wireguard input"
  action       = "drop"
  chain        = "input"
  in_interface = routeros_interface_wireguard.wireguard.name
  place_before = routeros_ip_firewall_filter.accept_trusted_input.id
}


# TRUSTED
resource "routeros_ip_firewall_filter" "accept_trusted_input" {
  comment      = "Accept all Trusted input"
  action       = "accept"
  chain        = "input"
  in_interface = local.vlans.Trusted.name
  place_before = routeros_ip_firewall_filter.accept_trusted_forward.id
}
resource "routeros_ip_firewall_filter" "accept_trusted_forward" {
  comment      = "Accept all Trusted forward"
  action       = "accept"
  chain        = "forward"
  in_interface = local.vlans.Trusted.name
  place_before = routeros_ip_firewall_filter.allow_guest_to_internet.id
}

# GUEST
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
resource "routeros_ip_firewall_filter" "drop_guest_input" {
  comment      = "Drop all Guest input"
  action       = "drop"
  chain        = "input"
  in_interface = local.vlans.Guest.name
  place_before = routeros_ip_firewall_filter.allow_iot_to_internet.id
  # log          = true
  # log_prefix   = "DROPPED GUEST INPUT:"
}

# IOT
resource "routeros_ip_firewall_filter" "allow_iot_to_internet" {
  comment            = "Allow SOME IoT to Internet"
  action             = "accept"
  chain              = "forward"
  in_interface       = local.vlans.IoT.name
  out_interface_list = routeros_interface_list.wan.name
  src_address_list   = routeros_ip_firewall_addr_list.iot_internet.list
  place_before       = routeros_ip_firewall_filter.drop_iot_forward.id
}
resource "routeros_ip_firewall_filter" "drop_iot_forward" {
  comment      = "Drop all IoT forward"
  action       = "drop"
  chain        = "forward"
  in_interface = local.vlans.IoT.name
  place_before = routeros_ip_firewall_filter.allow_iot_dns_tcp.id
  # log          = true
  # log_prefix   = "DROPPED IoT FORWARD:"
}
resource "routeros_ip_firewall_filter" "allow_iot_dns_tcp" {
  comment      = "Allow local DNS (TCP) for IoT"
  action       = "accept"
  chain        = "input"
  protocol     = "tcp"
  in_interface = local.vlans.IoT.name
  place_before = routeros_ip_firewall_filter.allow_iot_dns_udp.id
}
resource "routeros_ip_firewall_filter" "allow_iot_dns_udp" {
  comment      = "Allow local DNS (UDP) for IoT"
  action       = "accept"
  chain        = "input"
  protocol     = "udp"
  in_interface = local.vlans.IoT.name
  place_before = routeros_ip_firewall_filter.drop_iot_input.id
}
resource "routeros_ip_firewall_filter" "drop_iot_input" {
  comment      = "Drop all IoT input"
  action       = "drop"
  chain        = "input"
  in_interface = local.vlans.IoT.name
  place_before = routeros_ip_firewall_filter.allow_untrusted_to_internet.id
  # log          = true
  # log_prefix   = "DROPPED IoT INPUT:"
}

# UNTRUSTED
resource "routeros_ip_firewall_filter" "allow_untrusted_to_internet" {
  comment            = "Allow Untrusted to Internet"
  action             = "accept"
  chain              = "forward"
  in_interface       = local.vlans.Untrusted.name
  out_interface_list = routeros_interface_list.wan.name
  place_before       = routeros_ip_firewall_filter.allow_untrusted_to_iot.id
}
resource "routeros_ip_firewall_filter" "allow_untrusted_to_iot" {
  comment       = "Allow Untrusted to IoT"
  action        = "accept"
  chain         = "forward"
  in_interface  = local.vlans.Untrusted.name
  out_interface = local.vlans.IoT.name
  place_before  = routeros_ip_firewall_filter.allow_untrusted_to_k8s.id
}
resource "routeros_ip_firewall_filter" "allow_untrusted_to_k8s" {
  comment          = "Allow Untrusted to K8S Services"
  action           = "accept"
  chain            = "forward"
  in_interface     = local.vlans.Untrusted.name
  out_interface    = local.vlans.Services.name
  dst_address_list = routeros_ip_firewall_addr_list.k8s_services.list
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
resource "routeros_ip_firewall_filter" "allow_untrusted_dns_tcp" {
  comment      = "Allow local DNS (TCP) for Untrusted"
  action       = "accept"
  chain        = "input"
  protocol     = "tcp"
  in_interface = local.vlans.Untrusted.name
  place_before = routeros_ip_firewall_filter.allow_untrusted_dns_udp.id
}
resource "routeros_ip_firewall_filter" "allow_untrusted_dns_udp" {
  comment      = "Allow local DNS (UDP) for Untrusted"
  action       = "accept"
  chain        = "input"
  protocol     = "udp"
  in_interface = local.vlans.Untrusted.name
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

# SERVERS
resource "routeros_ip_firewall_filter" "allow_servers_to_internet" {
  comment            = "Allow Servers to Internet"
  action             = "accept"
  chain              = "forward"
  in_interface       = local.vlans.Servers.name
  out_interface_list = routeros_interface_list.wan.name
  place_before       = routeros_ip_firewall_filter.drop_servers_forward.id
}
resource "routeros_ip_firewall_filter" "drop_servers_forward" {
  comment      = "Drop all Servers forward"
  action       = "drop"
  chain        = "forward"
  in_interface = local.vlans.Servers.name
  place_before = routeros_ip_firewall_filter.allow_servers_dns_tcp.id
  # log          = true
  # log_prefix   = "DROPPED Servers FORWARD:"
}
resource "routeros_ip_firewall_filter" "allow_servers_dns_tcp" {
  comment      = "Allow local DNS (TCP) for Servers"
  action       = "accept"
  chain        = "input"
  protocol     = "tcp"
  in_interface = local.vlans.Servers.name
  place_before = routeros_ip_firewall_filter.allow_servers_dns_udp.id
}
resource "routeros_ip_firewall_filter" "allow_servers_dns_udp" {
  comment      = "Allow local DNS (UDP) for Servers"
  action       = "accept"
  chain        = "input"
  protocol     = "udp"
  in_interface = local.vlans.Servers.name
  place_before = routeros_ip_firewall_filter.drop_servers_input.id
}
resource "routeros_ip_firewall_filter" "drop_servers_input" {
  comment      = "Drop all Servers input"
  action       = "drop"
  chain        = "input"
  in_interface = local.vlans.Servers.name
  place_before = routeros_ip_firewall_filter.allow_kubernetes_to_internet.id
  # log          = true
  # log_prefix   = "DROPPED Servers INPUT:"
}

# KUBERNETES
resource "routeros_ip_firewall_filter" "allow_kubernetes_to_internet" {
  comment            = "Allow Kubernetes to Internet"
  action             = "accept"
  chain              = "forward"
  in_interface       = local.vlans.Services.name
  out_interface_list = routeros_interface_list.wan.name
  place_before       = routeros_ip_firewall_filter.drop_kubernetes_forward.id
}
resource "routeros_ip_firewall_filter" "drop_kubernetes_forward" {
  comment      = "Drop all Kubernetes forward"
  action       = "drop"
  chain        = "forward"
  in_interface = local.vlans.Services.name
  place_before = routeros_ip_firewall_filter.allow_kubernetes_dns_tcp.id
  # log          = true
  # log_prefix   = "DROPPED Kubernetes FORWARD:"
}
resource "routeros_ip_firewall_filter" "allow_kubernetes_dns_tcp" {
  comment      = "Allow local DNS (TCP) for Kubernetes"
  action       = "accept"
  chain        = "input"
  protocol     = "tcp"
  in_interface = local.vlans.Services.name
  place_before = routeros_ip_firewall_filter.allow_kubernetes_dns_udp.id
}
resource "routeros_ip_firewall_filter" "allow_kubernetes_dns_udp" {
  comment      = "Allow local DNS (UDP) for Kubernetes"
  action       = "accept"
  chain        = "input"
  protocol     = "udp"
  in_interface = local.vlans.Services.name
  place_before = routeros_ip_firewall_filter.drop_kubernetes_input.id
}
resource "routeros_ip_firewall_filter" "drop_kubernetes_input" {
  comment      = "Drop all Kubernetes input"
  action       = "drop"
  chain        = "input"
  in_interface = local.vlans.Services.name
  place_before = routeros_ip_firewall_filter.drop_all_forward.id
  # log          = true
  # log_prefix   = "DROPPED Kubernetes INPUT:"
}

# DEFAULT DENY
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
