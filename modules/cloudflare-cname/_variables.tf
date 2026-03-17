variable "zone_name" {
  description = "The Cloudflare zone domain name (e.g. 'mirceanton.com'). The zone ID is looked up automatically."
  type        = string
}

variable "name" {
  description = "The subdomain name (e.g. 'vpn' creates vpn.<domain>)"
  type        = string
  default     = "vpn"
}

variable "target" {
  description = "The CNAME target hostname (e.g. the MikroTik DDNS dns_name output)"
  type        = string
}

variable "ttl" {
  description = "TTL in seconds. Use 1 for auto (only valid when proxied = false)"
  type        = number
  default     = 1
}

variable "proxied" {
  description = "Whether to proxy through Cloudflare. Must be false for WireGuard (UDP)."
  type        = bool
  default     = false
}
