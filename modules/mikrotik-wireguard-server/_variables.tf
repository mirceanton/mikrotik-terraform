variable "name" {
  description = "Interface name"
  type        = string
}

variable "comment" {
  description = "Description"
  type        = string
  default     = ""
}

variable "listen_port" {
  description = "UDP port"
  type        = number
  default     = 13231
}

variable "mtu" {
  description = "Interface MTU"
  type        = number
  default     = 1420
}

variable "address" {
  description = "CIDR address for the interface, e.g. \"10.0.0.1/24\""
  type        = string
}

variable "private_key" {
  description = "Provide to pin the key; RouterOS auto-generates one if omitted"
  type        = string
  sensitive   = true
  default     = null
}
