variable "interface" {
  description = "Name of the interface the DHCP server is bound to (e.g., VLAN interface name)"
  type        = string
}

variable "address" {
  description = "Router's IP address on this interface in CIDR notation (e.g., '192.168.69.1/24')"
  type        = string
}

variable "network" {
  description = "Network address in CIDR notation (e.g., '192.168.69.0/24')"
  type        = string
}

variable "gateway" {
  description = "Gateway IP address for DHCP clients. If null, no gateway is advertised."
  type        = string
  default     = null
}

variable "dhcp_pool" {
  description = "List of IP ranges for DHCP pool (e.g., ['192.168.69.100-192.168.69.200'])"
  type        = list(string)
}

variable "dns_servers" {
  description = "List of DNS servers to provide via DHCP"
  type        = list(string)
  default     = []
}

variable "domain" {
  description = "Domain name to provide via DHCP"
  type        = string
  default     = ""
}

variable "static_leases" {
  description = <<-EOT
    Map of static DHCP leases. Key is the IP address.
    
    Example:
    {
      "192.168.69.69" = { name = "MyDevice", mac = "AA:BB:CC:DD:EE:FF" }
    }
  EOT
  type = map(object({
    mac  = string
    name = string
  }))
  default = {}
}
