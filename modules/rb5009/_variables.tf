variable "mikrotik_host_url" {
  type        = string
  sensitive   = false
  description = "The URL of the MikroTik device."
}

variable "mikrotik_username" {
  type        = string
  sensitive   = true
  description = "The username for accessing the MikroTik device."
}

variable "mikrotik_password" {
  type        = string
  sensitive   = true
  description = "The password for accessing the MikroTik device."
}

variable "mikrotik_insecure" {
  type        = bool
  default     = true
  description = "Whether to allow insecure connections to the MikroTik device."
}


variable "digi_pppoe_username" {
  type        = string
  sensitive   = true
  description = "The PPPoE username for the Digi connection."
}

variable "digi_pppoe_password" {
  type        = string
  sensitive   = true
  description = "The PPPoE password for the Digi connection."
}

variable "wifi_password" {
  type        = string
  sensitive   = true
  description = "The password for the Wi-Fi network."
}
