variable "interface" {
  description = "WireGuard interface name."
  type        = string
}

variable "peers" {
  description = "Map of peer name to peer configuration"
  type = map(object({
    allowed_address      = list(string)
    comment              = optional(string, "")
    endpoint_address     = optional(string, null)
    endpoint_port        = optional(number, null)
    persistent_keepalive = optional(string, null)
  }))
}
