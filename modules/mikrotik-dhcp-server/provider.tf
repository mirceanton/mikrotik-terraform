terraform {
  required_providers {
    routeros = {
      source  = "terraform-routeros/routeros"
      version = "1.98.0"
    }
  }
}

variable "mikrotik_hostname" {
  type        = string
  description = "The hostname or IP address of the MikroTik device."
}
variable "mikrotik_username" {
  type        = string
  description = "The username for accessing the MikroTik device."
}
variable "mikrotik_password" {
  type        = string
  description = "The password for accessing the MikroTik device."
  sensitive   = true
}
variable "mikrotik_insecure" {
  type        = bool
  default     = true
  description = "Whether to skip TLS certificate verification when connecting to the MikroTik device."
}

provider "routeros" {
  hosturl  = var.mikrotik_hostname
  username = var.mikrotik_username
  password = var.mikrotik_password
  insecure = var.mikrotik_insecure
}
