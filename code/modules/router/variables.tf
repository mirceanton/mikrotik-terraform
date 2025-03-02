# =================================================================================================
# PPPoE Client
# =================================================================================================
variable "pppoe_client_interface" {
  type        = string
  default     = ""
  description = "Physical interface to use for PPPoE client connection"
}

variable "pppoe_client_name" {
  type        = string
  default     = "pppoe-out"
  description = "Name for the PPPoE client interface"
}

variable "pppoe_client_comment" {
  type        = string
  default     = ""
  description = "Comment for the PPPoE client interface"
}

variable "pppoe_add_default_route" {
  type        = bool
  default     = true
  description = "Whether to add a default route through the PPPoE connection"
}

variable "pppoe_use_peer_dns" {
  type        = bool
  default     = false
  description = "Whether to use DNS servers provided by PPPoE server"
}

variable "pppoe_username" {
  type        = string
  sensitive   = true
  default     = ""
  description = "Username for PPPoE authentication"
}

variable "pppoe_password" {
  type        = string
  sensitive   = true
  default     = ""
  description = "Password for PPPoE authentication"
}


# =================================================================================================
# DNS Server
# =================================================================================================
variable "dns_allow_remote_requests" {
  description = "Whether to allow remote DNS requests"
  type        = bool
  default     = true
}

variable "upstream_dns" {
  description = "List of upstream DNS servers"
  type        = list(string)
  default     = ["1.1.1.1", "8.8.8.8"]
}

variable "dns_cache_size" {
  description = "Size of the DNS cache in KiB"
  type        = number
  default     = 8192
}

variable "dns_cache_max_ttl" {
  description = "Maximum time-to-live for cached DNS entries"
  type        = string
  default     = "1d"
}

variable "mdns_repeat_ifaces" {
  description = "Interfaces to repeat mDNS packets to"
  type        = list(string)
}

variable "adlist_url" {
  description = "URL for DNS blocklists"
  type        = string
  default     = ""
}

variable "static_dns" {
  description = "Map of static DNS records to create"
  type = map(object({
    address = string
    type    = string
    comment = string
  }))
}
