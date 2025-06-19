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

variable "vlans" {
  type = map(any) #! barbaric but works i guess
}
variable "all_vlans" {
  type = list(string)
}