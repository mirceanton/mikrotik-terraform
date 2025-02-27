# =================================================================================================
# Device/Provider connectivity
# =================================================================================================
variable "mikrotik_ip" {
  type        = string
  sensitive   = false
  description = "The IP address of the MikroTik device."
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

# =================================================================================================
# Device settings
# =================================================================================================
variable "hostname" {
  type        = string
  description = "The name to assign to this device."
}

variable "timezone" {
  type        = string
  default     = "Europe/Bucharest"
  description = "The timezone to set on the device."
}

variable "disable_ipv6" {
  type        = bool
  default     = true
  description = "Whether to disable IPv6 on the device."
}

variable "ntp_servers" {
  type        = list(string)
  default     = ["time.cloudflare.com"]
  description = "List of NTP servers to use."
}

# =================================================================================================
# Management access
# =================================================================================================
variable "mac_server_interfaces" {
  type        = string
  default     = "all"
  description = "Interface list to allow MAC server access on."
}

# =================================================================================================
# Certificate details
# =================================================================================================
variable "certificate_country" {
  type        = string
  default     = "RO"
  description = "Country code for the device certificate."
}

variable "certificate_locality" {
  type        = string
  default     = "BUC"
  description = "Locality for the device certificate."
}

variable "certificate_organization" {
  type        = string
  default     = "MIRCEANTON"
  description = "Organization for the device certificate."
}

variable "certificate_unit" {
  type        = string
  default     = "HOME"
  description = "Organizational unit for the device certificate."
}


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
