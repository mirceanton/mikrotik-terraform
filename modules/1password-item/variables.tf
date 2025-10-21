variable "op_service_account_token" {
  description = "1Password Service Account Token"
  type        = string
  sensitive   = true
}

variable "vault" {
  description = "Name of the 1Password vault"
  type        = string
}

variable "items" {
  description = "Map of items to create/update in 1Password"
  type = map(object({
    password = string
    notes    = optional(string, "")
    category = optional(string, "password")
  }))
}
