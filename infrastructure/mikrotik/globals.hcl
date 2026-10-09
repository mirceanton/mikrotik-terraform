locals {
  timezone       = "Europe/Bucharest"
  cloudflare_ntp = "time.cloudflare.com"

  # ===============================================================================================
  # Certificate Defaults
  # ===============================================================================================
  certificate_country      = "RO"
  certificate_locality     = "BUC"
  certificate_organization = "MIRCEANTON"
  certificate_unit         = "HOME"

  # ===============================================================================================
  # Device Defaults
  # ===============================================================================================
  disable_ipv6          = true
  mac_server_interfaces = "none"

  # ===============================================================================================
  # Default Groups and Users
  # =============================================================================================== 
  default_groups = {
    metrics      = { policies = ["api", "read"], comment = "Metrics collection group" }
    mcp-readonly = { policies = ["ssh", "read"], comment = "Read-only group for the MikroTik MCP (SSH)" }
  }
  default_users = {
    metrics = { group = "metrics", comment = "Prometheus metrics user", inactivity_policy = "logout", inactivity_timeout = "00:05:00" }
    mircea  = { group = "full", comment = "me, lol", inactivity_policy = "logout", inactivity_timeout = "00:05:00" }
    mcp-readonly = {
      group              = "mcp-readonly"
      comment            = "Read-only user for the MikroTik MCP"
      address            = "10.0.0.0/24"
      inactivity_policy  = "logout"
      inactivity_timeout = "00:05:00"
    }
  }

  # ===============================================================================================
  # IP Services
  # ===============================================================================================
  # Kept here rather than relying on the module defaults because the module's `ip_services`
  # variable has no merge semantics: an incomplete map drops the omitted services out of the
  # module's for_each, so they would no longer be managed. `ssh` is enabled for the read-only
  # `mcp-readonly` account, which the SSH-only MikroTik MCP logs in with; every other value is
  # unchanged from the module default (v0.4.0).
  ip_services = {
    "api"     = { enabled = false, port = 8728 }
    "api-ssl" = { enabled = true, port = 8729 }
    "ftp"     = { enabled = false, port = 21 }
    "ssh"     = { enabled = true, port = 22 }
    "telnet"  = { enabled = false, port = 23 }
    "winbox"  = { enabled = true, port = 8291 }
    "www"     = { enabled = false, port = 80 }
    "www-ssl" = { enabled = true, port = 443 }
  }

  # ===============================================================================================
  # VLAN Definitions 
  # =============================================================================================== 
  all_vlans                = keys(local.vlans)
  all_but_management_vlans = [for name, vlan in local.vlans : vlan.name if name != "Management"]
  vlans = {
    Trusted    = { name = "Trusted", vlan_id = 1969 }
    Untrusted  = { name = "Untrusted", vlan_id = 1942 }
    Guest      = { name = "Guest", vlan_id = 1742 }
    Services   = { name = "Services", vlan_id = 1010 }
    Management = { name = "Management", vlan_id = 1000 }
    Storage    = { name = "Storage", vlan_id = 1255 }
  }
}