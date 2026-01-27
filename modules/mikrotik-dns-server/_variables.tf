variable "upstream_dns" {
  type        = list(string)
  description = "List of upstream DNS servers to forward queries to"
}

variable "allow_remote_requests" {
  type        = bool
  default     = true
  description = "Whether to allow DNS requests from remote hosts (clients on the network)"
}

variable "cache_size" {
  type        = number
  default     = 8192
  description = "Size of the DNS cache in KiB"
}

variable "cache_max_ttl" {
  type        = string
  default     = "1d"
  description = "Maximum time-to-live for cached DNS entries (e.g., '1d', '12h', '3600')"
}

variable "adlist_url" {
  type        = string
  default     = null
  description = "URL to an adblock list for DNS-based ad blocking. Set to null or empty string to disable"
}

variable "adlist_ssl_verify" {
  type        = bool
  default     = false
  description = "Whether to verify SSL certificates when fetching the adblock list"
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
  description = "Map of static DNS records. Key is the DNS name. Type can be 'A', 'AAAA', 'CNAME', etc."
}
