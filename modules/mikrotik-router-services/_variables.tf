## ================================================================================================
## PPPoE Connection Variables
## ================================================================================================
variable "digi_pppoe_password" {
  type        = string
  sensitive   = true
  description = "The PPPoE password for the Digi connection."
}
variable "digi_pppoe_username" {
  type        = string
  sensitive   = true
  description = "The PPPoE username for the Digi connection."
}

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

variable "static_dns" {
  type = map(object({
    address         = optional(string)
    cname           = optional(string)
    match_subdomain = optional(bool, false)
    comment         = string
    type            = string
  }))
  default     = {}
  description = "Map of static DNS records"
}

variable "upstream_dns" {
  type        = list(string)
  description = "List of upstream DNS servers"
}

variable "adlist" {
  type        = string
  description = "URL to adblock list for DNS"
}
