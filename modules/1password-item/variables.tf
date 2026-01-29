variable "op_service_account_token" {
  description = "1Password Service Account Token"
  type        = string
  sensitive   = true
}

variable "items" {
  description = "Map of items to create/update in 1Password"
  type = map(object({
    vault    = string
    password = string
    username = optional(string, "")
    notes    = optional(string, "")
    category = optional(string, "password")
  }))
}
