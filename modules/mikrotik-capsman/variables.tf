variable "country" {
  description = "Country code for WiFi regulatory compliance (e.g., 'Romania', 'United States')"
  type        = string
  default     = "Romania"
}

variable "capsman_interfaces" {
  description = "List of interfaces where CAPsMAN will listen for CAP connections"
  type        = list(string)
  default     = ["all"]
}

variable "upgrade_policy" {
  description = "Policy for upgrading CAP devices ('none', 'suggest-same-version', 'require-same-version')"
  type        = string
  default     = "none"
}

variable "require_peer_certificate" {
  description = "Require CAP devices to present a valid certificate"
  type        = bool
  default     = false
}

variable "wifi_networks" {
  description = <<-EOT
    Map of WiFi networks to configure. Each network creates a security profile,
    datapath (for VLAN tagging), configuration, and provisioning rule.
    
    The map key is used as a unique identifier for the network resources.
    
    Example:
    {
      guest = {
        ssid             = "my-guest"
        band             = "2ghz-ax"
        vlan_id          = 50
        client_isolation = true
        passphrase       = "my-guest-passphrase"  # explicit passphrase
      }
      home_2ghz = {
        ssid    = "my-home-2ghz"
        band    = "2ghz-ax"
        vlan_id = 40
        # passphrase omitted - will generate random 32-character string
      }
      home_5ghz = {
        ssid    = "my-home-5ghz"
        band    = "5ghz-ax"
        vlan_id = 40
      }
    }
  EOT
  type = map(object({
    ssid             = string
    band             = string
    vlan_id          = number
    client_isolation = optional(bool, false)
    passphrase       = optional(string)
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.wifi_networks : contains(["2ghz-ax", "5ghz-ax", "2ghz-n", "5ghz-n", "5ghz-ac"], v.band)
    ])
    error_message = "Band must be one of: 2ghz-ax, 5ghz-ax, 2ghz-n, 5ghz-n, 5ghz-ac"
  }
}
