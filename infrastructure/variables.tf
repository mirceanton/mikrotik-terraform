## ================================================================================================
## Mikrotik Variables
## ================================================================================================
variable "mikrotik_username" {
  type        = string
  default     = "admin"
  description = "The username to authenticate against the RouterOS API."
}
variable "mikrotik_password" {
  type        = string
  description = "The password to authenticate against the RouterOS API."
  sensitive   = true
}


## ================================================================================================
## PPPoE Connection Variables
## ================================================================================================
variable "digi_pppoe_password" {
  type        = string
  sensitive   = true
  description = "The PPPoE password for the Digi connection."
}
variable "digi_pppoe_username" {
  type        = string
  sensitive   = true
  description = "The PPPoE username for the Digi connection."
}


## ================================================================================================
## WiFi Variables
## ================================================================================================
variable "untrusted_wifi_password" {
  type        = string
  sensitive   = true
  description = "The password for the Untrusted Wi-Fi network."
}
variable "guest_wifi_password" {
  type        = string
  sensitive   = true
  description = "The password for the Guest Wi-Fi network."
}
variable "iot_wifi_password" {
  type        = string
  sensitive   = true
  description = "The password for the IoT Wi-Fi network."
}
