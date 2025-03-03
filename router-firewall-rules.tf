# =================================================================================================
# NAT Rules
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_firewall_nat
# =================================================================================================
resource "routeros_ip_firewall_nat" "wan" {
  provider           = routeros.rb5009
  comment            = "WAN masquerade"
  chain              = "srcnat"
  action             = "masquerade"
  out_interface_list = routeros_interface_list.wan.name
}


resource "routeros_ip_firewall_addr_list" "k8s_services" {
  provider = routeros.rb5009
  list     = "k8s_services"
  comment  = "IPs allocated to K8S Services."
  address  = "10.0.10.90-10.0.10.99"
}
resource "routeros_ip_firewall_addr_list" "iot_internet" {
  provider = routeros.rb5009
  list     = "iot_internet"
  comment  = "IoT IPs allowed to the internet."
  address  = "172.16.69.201-172.16.69.250"
}


# =================================================================================================
# Firewall Rules
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_firewall_filter
# =================================================================================================
# Global Rules
resource "routeros_ip_firewall_filter" "fasttrack" {
  provider         = routeros.rb5009
  comment          = "Fasttrack"
  action           = "fasttrack-connection"
  chain            = "forward"
  connection_state = "established,related"
  hw_offload       = true
  place_before     = routeros_ip_firewall_filter.accept_established_related_untracked_forward.id
}
resource "routeros_ip_firewall_filter" "accept_established_related_untracked_forward" {
  provider         = routeros.rb5009
  comment          = "Allow established, related, untracked"
  action           = "accept"
  chain            = "forward"
  connection_state = "established,related,untracked"
  place_before     = routeros_ip_firewall_filter.truenas_asymmetric_routing_fix.id
}
resource "routeros_ip_firewall_filter" "truenas_asymmetric_routing_fix" {
  provider         = routeros.rb5009
  comment          = "TrueNAS Asymmetric Routing Fix"
  action           = "accept"
  chain            = "forward"
  connection_state = "invalid"
  in_interface     = "Trusted"
  out_interface    = "Servers"
  place_before     = routeros_ip_firewall_filter.drop_invalid_forward.id
}
resource "routeros_ip_firewall_filter" "drop_invalid_forward" {
  provider         = routeros.rb5009
  comment          = "Drop invalid"
  action           = "drop"
  chain            = "forward"
  connection_state = "invalid"
  place_before     = routeros_ip_firewall_filter.accept_capsman_loopback.id
  # log              = true
  # log_prefix       = "DROPPED INVALID:"
}
resource "routeros_ip_firewall_filter" "accept_capsman_loopback" {
  provider     = routeros.rb5009
  comment      = "Accept to local loopback for CAPsMAN"
  action       = "accept"
  chain        = "input"
  dst_address  = "127.0.0.1"
  place_before = routeros_ip_firewall_filter.allow_input_icmp.id
}
resource "routeros_ip_firewall_filter" "allow_input_icmp" {
  provider     = routeros.rb5009
  comment      = "Allow input ICMP"
  action       = "accept"
  chain        = "input"
  protocol     = "icmp"
  place_before = routeros_ip_firewall_filter.accept_router_established_related_untracked.id
}
resource "routeros_ip_firewall_filter" "accept_router_established_related_untracked" {
  provider         = routeros.rb5009
  comment          = "Allow established, related, untracked to router"
  action           = "accept"
  chain            = "input"
  connection_state = "established,related,untracked"
  place_before     = routeros_ip_firewall_filter.accept_trusted_input.id
}

# TRUSTED
resource "routeros_ip_firewall_filter" "accept_trusted_input" {
  provider     = routeros.rb5009
  comment      = "Accept all Trusted input"
  action       = "accept"
  chain        = "input"
  in_interface = local.vlans.Trusted.name
  place_before = routeros_ip_firewall_filter.accept_trusted_forward.id
}
resource "routeros_ip_firewall_filter" "accept_trusted_forward" {
  provider     = routeros.rb5009
  comment      = "Accept all Trusted forward"
  action       = "accept"
  chain        = "forward"
  in_interface = local.vlans.Trusted.name
  place_before = routeros_ip_firewall_filter.allow_guest_to_internet.id
}

# GUEST
resource "routeros_ip_firewall_filter" "allow_guest_to_internet" {
  provider           = routeros.rb5009
  comment            = "Allow Guest to Internet"
  action             = "accept"
  chain              = "forward"
  in_interface       = local.vlans.Guest.name
  out_interface_list = routeros_interface_list.wan.name
  place_before       = routeros_ip_firewall_filter.drop_guest_forward.id
}
resource "routeros_ip_firewall_filter" "drop_guest_forward" {
  provider     = routeros.rb5009
  comment      = "Drop all Guest forward"
  action       = "drop"
  chain        = "forward"
  in_interface = local.vlans.Guest.name
  place_before = routeros_ip_firewall_filter.drop_guest_input.id
  # log          = true
  # log_prefix   = "DROPPED GUEST FORWARD:"
}
resource "routeros_ip_firewall_filter" "drop_guest_input" {
  provider     = routeros.rb5009
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
  provider           = routeros.rb5009
  comment            = "Allow SOME IoT to Internet"
  action             = "accept"
  chain              = "forward"
  in_interface       = local.vlans.IoT.name
  out_interface_list = routeros_interface_list.wan.name
  src_address_list   = routeros_ip_firewall_addr_list.iot_internet.list
  place_before       = routeros_ip_firewall_filter.drop_iot_forward.id
}
resource "routeros_ip_firewall_filter" "drop_iot_forward" {
  provider     = routeros.rb5009
  comment      = "Drop all IoT forward"
  action       = "drop"
  chain        = "forward"
  in_interface = local.vlans.IoT.name
  place_before = routeros_ip_firewall_filter.allow_iot_dns_tcp.id
  # log          = true
  # log_prefix   = "DROPPED IoT FORWARD:"
}
resource "routeros_ip_firewall_filter" "allow_iot_dns_tcp" {
  provider     = routeros.rb5009
  comment      = "Allow local DNS (TCP) for IoT"
  action       = "accept"
  chain        = "input"
  protocol     = "tcp"
  in_interface = local.vlans.IoT.name
  place_before = routeros_ip_firewall_filter.allow_iot_dns_udp.id
}
resource "routeros_ip_firewall_filter" "allow_iot_dns_udp" {
  provider     = routeros.rb5009
  comment      = "Allow local DNS (UDP) for IoT"
  action       = "accept"
  chain        = "input"
  protocol     = "udp"
  in_interface = local.vlans.IoT.name
  place_before = routeros_ip_firewall_filter.drop_iot_input.id
}
resource "routeros_ip_firewall_filter" "drop_iot_input" {
  provider     = routeros.rb5009
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
  provider           = routeros.rb5009
  comment            = "Allow Untrusted to Internet"
  action             = "accept"
  chain              = "forward"
  in_interface       = local.vlans.Untrusted.name
  out_interface_list = routeros_interface_list.wan.name
  place_before       = routeros_ip_firewall_filter.allow_untrusted_to_iot.id
}
resource "routeros_ip_firewall_filter" "allow_untrusted_to_iot" {
  provider      = routeros.rb5009
  comment       = "Allow Untrusted to IoT"
  action        = "accept"
  chain         = "forward"
  in_interface  = local.vlans.Untrusted.name
  out_interface = local.vlans.IoT.name
  place_before  = routeros_ip_firewall_filter.allow_untrusted_to_k8s.id
}
resource "routeros_ip_firewall_filter" "allow_untrusted_to_k8s" {
  provider         = routeros.rb5009
  comment          = "Allow Untrusted to K8S Services"
  action           = "accept"
  chain            = "forward"
  in_interface     = local.vlans.Untrusted.name
  out_interface    = local.vlans.Kubernetes.name
  dst_address_list = routeros_ip_firewall_addr_list.k8s_services.list
  place_before     = routeros_ip_firewall_filter.drop_untrusted_forward.id
}
resource "routeros_ip_firewall_filter" "drop_untrusted_forward" {
  provider     = routeros.rb5009
  comment      = "Drop all Untrusted forward"
  action       = "drop"
  chain        = "forward"
  in_interface = local.vlans.Untrusted.name
  place_before = routeros_ip_firewall_filter.allow_untrusted_dns_tcp.id
  # log          = true
  # log_prefix   = "DROPPED Untrusted FORWARD:"
}
resource "routeros_ip_firewall_filter" "allow_untrusted_dns_tcp" {
  provider     = routeros.rb5009
  comment      = "Allow local DNS (TCP) for Untrusted"
  action       = "accept"
  chain        = "input"
  protocol     = "tcp"
  in_interface = local.vlans.Untrusted.name
  place_before = routeros_ip_firewall_filter.allow_untrusted_dns_udp.id
}
resource "routeros_ip_firewall_filter" "allow_untrusted_dns_udp" {
  provider     = routeros.rb5009
  comment      = "Allow local DNS (UDP) for Untrusted"
  action       = "accept"
  chain        = "input"
  protocol     = "udp"
  in_interface = local.vlans.Untrusted.name
  place_before = routeros_ip_firewall_filter.drop_untrusted_input.id
}
resource "routeros_ip_firewall_filter" "drop_untrusted_input" {
  provider     = routeros.rb5009
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
  provider           = routeros.rb5009
  comment            = "Allow Servers to Internet"
  action             = "accept"
  chain              = "forward"
  in_interface       = local.vlans.Servers.name
  out_interface_list = routeros_interface_list.wan.name
  place_before       = routeros_ip_firewall_filter.drop_servers_forward.id
}
resource "routeros_ip_firewall_filter" "drop_servers_forward" {
  provider     = routeros.rb5009
  comment      = "Drop all Servers forward"
  action       = "drop"
  chain        = "forward"
  in_interface = local.vlans.Servers.name
  place_before = routeros_ip_firewall_filter.allow_servers_dns_tcp.id
  # log          = true
  # log_prefix   = "DROPPED Servers FORWARD:"
}
resource "routeros_ip_firewall_filter" "allow_servers_dns_tcp" {
  provider     = routeros.rb5009
  comment      = "Allow local DNS (TCP) for Servers"
  action       = "accept"
  chain        = "input"
  protocol     = "tcp"
  in_interface = local.vlans.Servers.name
  place_before = routeros_ip_firewall_filter.allow_servers_dns_udp.id
}
resource "routeros_ip_firewall_filter" "allow_servers_dns_udp" {
  provider     = routeros.rb5009
  comment      = "Allow local DNS (UDP) for Servers"
  action       = "accept"
  chain        = "input"
  protocol     = "udp"
  in_interface = local.vlans.Servers.name
  place_before = routeros_ip_firewall_filter.drop_servers_input.id
}
resource "routeros_ip_firewall_filter" "drop_servers_input" {
  provider     = routeros.rb5009
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
  provider           = routeros.rb5009
  comment            = "Allow Kubernetes to Internet"
  action             = "accept"
  chain              = "forward"
  in_interface       = local.vlans.Kubernetes.name
  out_interface_list = routeros_interface_list.wan.name
  place_before       = routeros_ip_firewall_filter.drop_kubernetes_forward.id
}
resource "routeros_ip_firewall_filter" "drop_kubernetes_forward" {
  provider     = routeros.rb5009
  comment      = "Drop all Kubernetes forward"
  action       = "drop"
  chain        = "forward"
  in_interface = local.vlans.Kubernetes.name
  place_before = routeros_ip_firewall_filter.allow_kubernetes_dns_tcp.id
  # log          = true
  # log_prefix   = "DROPPED Kubernetes FORWARD:"
}
resource "routeros_ip_firewall_filter" "allow_kubernetes_dns_tcp" {
  provider     = routeros.rb5009
  comment      = "Allow local DNS (TCP) for Kubernetes"
  action       = "accept"
  chain        = "input"
  protocol     = "tcp"
  in_interface = local.vlans.Kubernetes.name
  place_before = routeros_ip_firewall_filter.allow_kubernetes_dns_udp.id
}
resource "routeros_ip_firewall_filter" "allow_kubernetes_dns_udp" {
  provider     = routeros.rb5009
  comment      = "Allow local DNS (UDP) for Kubernetes"
  action       = "accept"
  chain        = "input"
  protocol     = "udp"
  in_interface = local.vlans.Kubernetes.name
  place_before = routeros_ip_firewall_filter.drop_kubernetes_input.id
}
resource "routeros_ip_firewall_filter" "drop_kubernetes_input" {
  provider     = routeros.rb5009
  comment      = "Drop all Kubernetes input"
  action       = "drop"
  chain        = "input"
  in_interface = local.vlans.Kubernetes.name
  place_before = routeros_ip_firewall_filter.drop_all_forward.id
  # log          = true
  # log_prefix   = "DROPPED Kubernetes INPUT:"
}

# DEFAULT DENY
resource "routeros_ip_firewall_filter" "drop_all_forward" {
  provider     = routeros.rb5009
  comment      = "Drop all forward not from Trusted"
  action       = "drop"
  chain        = "forward"
  in_interface = "!${local.vlans.Trusted.name}"
  place_before = routeros_ip_firewall_filter.drop_all_input.id
}
resource "routeros_ip_firewall_filter" "drop_all_input" {
  provider     = routeros.rb5009
  comment      = "Drop all input not from Trusted"
  action       = "drop"
  chain        = "input"
  in_interface = "!${local.vlans.Trusted.name}"
}
