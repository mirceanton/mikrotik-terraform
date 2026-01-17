## ================================================================================================
## Network Configuration Variables
## ================================================================================================
variable "vlans" {
  type = map(object({
    name        = string
    vlan_id     = number
    network     = string
    cidr_suffix = string
    gateway     = string
    dhcp_pool   = list(string)
    dns_servers = list(string)
    domain      = string
    mtu         = optional(number, 1500)
    static_leases = map(object({
      name = string
      mac  = string
    }))
  }))
  default     = {}
  description = "Map of VLANs to configure"
}

variable "wan_interface" {
  type        = string
  description = "Name of the WAN interface (e.g., PPPoE interface name)"
}
