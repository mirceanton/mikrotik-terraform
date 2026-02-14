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
