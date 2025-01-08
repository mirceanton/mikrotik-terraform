# =================================================================================================
# NAT Rules
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_firewall_nat
# =================================================================================================
resource "routeros_ip_firewall_nat" "wan" {
  comment            = "WAN masquerade"
  chain              = "srcnat"
  out_interface_list = "WAN"
  action             = "masquerade"
}

# =================================================================================================
# Firewall Rules
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_firewall_filter
# =================================================================================================

resource "routeros_ip_firewall_filter" "accept_established_related_untracked" {
  action           = "accept"
  chain            = "input"
  comment          = "accept established, related, untracked"
  connection_state = "established,related,untracked"
  place_before     = routeros_ip_firewall_filter.drop_invalid.id
}

resource "routeros_ip_firewall_filter" "drop_invalid" {
  action           = "drop"
  chain            = "input"
  comment          = "drop invalid"
  connection_state = "invalid"
  place_before     = routeros_ip_firewall_filter.accept_icmp.id
}

resource "routeros_ip_firewall_filter" "accept_icmp" {
  action       = "accept"
  chain        = "input"
  comment      = "accept ICMP"
  protocol     = "icmp"
  place_before = routeros_ip_firewall_filter.capsman_accept_local_loopback.id
}

resource "routeros_ip_firewall_filter" "capsman_accept_local_loopback" {
  action       = "accept"
  chain        = "input"
  comment      = "accept to local loopback for capsman"
  dst_address  = "127.0.0.1"
  place_before = routeros_ip_firewall_filter.drop_all_not_lan.id
}

resource "routeros_ip_firewall_filter" "drop_all_not_lan" {
  action            = "drop"
  chain             = "input"
  comment           = "drop all not coming from LAN"
  in_interface_list = "!LAN"
  place_before      = routeros_ip_firewall_filter.accept_ipsec_policy_in.id
}

resource "routeros_ip_firewall_filter" "accept_ipsec_policy_in" {
  action       = "accept"
  chain        = "forward"
  comment      = "accept in ipsec policy"
  ipsec_policy = "in,ipsec"
  place_before = routeros_ip_firewall_filter.accept_ipsec_policy_out.id
}

resource "routeros_ip_firewall_filter" "accept_ipsec_policy_out" {
  action       = "accept"
  chain        = "forward"
  comment      = "accept out ipsec policy"
  ipsec_policy = "out,ipsec"
  place_before = routeros_ip_firewall_filter.fasttrack_connection.id
}

resource "routeros_ip_firewall_filter" "fasttrack_connection" {
  action           = "fasttrack-connection"
  chain            = "forward"
  comment          = "fasttrack"
  connection_state = "established,related"
  hw_offload       = "true"
  place_before     = routeros_ip_firewall_filter.accept_established_related_untracked_forward.id
}

resource "routeros_ip_firewall_filter" "accept_established_related_untracked_forward" {
  action           = "accept"
  chain            = "forward"
  comment          = "accept established, related, untracked"
  connection_state = "established,related,untracked"
  place_before     = routeros_ip_firewall_filter.drop_invalid_forward.id
}

resource "routeros_ip_firewall_filter" "drop_invalid_forward" {
  action           = "drop"
  chain            = "forward"
  comment          = "drop invalid"
  connection_state = "invalid"
  place_before     = routeros_ip_firewall_filter.drop_all_wan_not_dstnat.id
}

resource "routeros_ip_firewall_filter" "drop_all_wan_not_dstnat" {
  action               = "drop"
  chain                = "forward"
  comment              = "drop all from WAN not DSTNATed"
  connection_nat_state = "!dstnat"
  connection_state     = "new"
  in_interface_list    = "WAN"
}
