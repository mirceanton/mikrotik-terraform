locals {
  timezone       = "Europe/Bucharest"
  cloudflare_ntp = "time.cloudflare.com"

  vlans = {
    Trusted    = { name = "Trusted", vlan_id = 1969 }
    Untrusted  = { name = "Untrusted", vlan_id = 1942 }
    Guest      = { name = "Guest", vlan_id = 1742 }
    Services   = { name = "Services", vlan_id = 1010 }
    Management = { name = "Management", vlan_id = 1000 }
    Storage    = { name = "Storage", vlan_id = 1255 }
  }

  all_vlans                = keys(local.vlans)
  all_but_management_vlans = [for name, vlan in local.vlans : vlan.name if name != "Management"]
}