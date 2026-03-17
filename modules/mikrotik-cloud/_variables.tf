variable "ddns_enabled" {
  description = "Whether to enable MikroTik DDNS"
  type        = bool
  default     = false
}

variable "ddns_update_interval" {
  description = "How often to update the DDNS record (e.g. '1m', '5m'). Empty string uses the router default."
  type        = string
  default     = "5m"
}

variable "back_to_home_vpn" {
  description = "Whether to enable the Back to Home VPN feature"
  type        = string
  default     = "revoked-and-disabled"
}

variable "update_time" {
  description = "Whether to synchronize the router clock with the MikroTik cloud server"
  type        = bool
  default     = false
}

variable "advanced_use_local_address" {
  description = "An option whether to assign an internal router address to the dynamic DNS name."
  type        = bool
  default     = false
}