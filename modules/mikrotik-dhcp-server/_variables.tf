variable "interface" {
  description = "Name of the interface the DHCP server is bound to"
  type        = string
}

variable "client_mac_limit" {
  description = "Maximum number of MAC addresses allowed per client"
  type        = number
  default     = 1
}

variable "conflict_detection" {
  description = "Whether to enable conflict detection for DHCP leases"
  type        = bool
  default     = false
}

variable "dynamic_lease_identifiers" {
  description = "Dynamic lease identifier."
  type        = string
  default     = "client-mac,client-id"
}

variable "address" {
  description = "IP address in CIDR notation to assign to the interface (e.g., 192.168.1.1/24)"
  type        = string
}

variable "network" {
  description = "Network address in CIDR notation (e.g., 192.168.1.0/24)"
  type        = string
}

variable "gateway" {
  description = "Gateway IP address for the network"
  type        = string
  default     = null
}

variable "dhcp_pool" {
  description = "List of IP ranges for DHCP pool (e.g., [\"192.168.1.100-192.168.1.200\"])"
  type        = list(string)
}

variable "dns_servers" {
  description = "List of DNS servers to provide via DHCP"
  type        = list(string)
}

variable "domain" {
  description = "Domain name to provide via DHCP"
  type        = string
}

variable "static_leases" {
  description = "Map of static DHCP leases keyed by IP address"
  type = map(object({
    mac               = string
    name              = string
    create_dns_record = optional(bool)
  }))
  default = {}
}

variable "create_dns_records" {
  description = "Whether to create static DNS A records for each static lease"
  type        = bool
  default     = true
}
