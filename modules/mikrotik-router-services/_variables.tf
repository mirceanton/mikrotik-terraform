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
  type        = any
  description = "Map of VLAN configurations"
}

variable "static_dns" {
  type        = any
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
