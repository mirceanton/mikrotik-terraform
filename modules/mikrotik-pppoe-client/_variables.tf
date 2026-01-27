variable "interface" {
  description = "Physical interface to use for PPPoE connection (e.g., ether1)"
  type        = string
}

variable "name" {
  description = "Name for the PPPoE client interface"
  type        = string
}

variable "comment" {
  description = "Optional comment/description for the PPPoE client"
  type        = string
  default     = ""
}

variable "username" {
  description = "PPPoE authentication username"
  type        = string
  sensitive   = true
}

variable "password" {
  description = "PPPoE authentication password"
  type        = string
  sensitive   = true
}

variable "add_default_route" {
  description = "Whether to add a default route when connected"
  type        = bool
  default     = true
}

variable "use_peer_dns" {
  description = "Whether to use DNS servers provided by the PPPoE server"
  type        = bool
  default     = false
}
