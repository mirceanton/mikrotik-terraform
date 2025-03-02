# =================================================================================================
# DHCP Client
# =================================================================================================
variable "dhcp_client_interface" {
  type        = string
  default     = ""
  description = "Interface to use for DHCP client"
}

variable "dhcp_client_comment" {
  type        = string
  default     = ""
  description = "Comment for the DHCP client configuration"
}

variable "dhcp_client_use_peer_dns" {
  type        = bool
  default     = true
  description = "Whether to use DNS servers provided by DHCP server"
}
