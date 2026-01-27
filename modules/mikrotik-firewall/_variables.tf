# =================================================================================================
# Interface Lists
# =================================================================================================
variable "interface_lists" {
  description = <<-EOT
    Map of interface lists to create with their members.

    Example:
    {
      WAN = {
        comment    = "All Public-Facing Interfaces"
        interfaces = ["PPPoE-Digi"]
      }
      LAN = {
        comment    = "All Local Interfaces"
        interfaces = ["bridge", "Trusted", "Untrusted"]
      }
    }
  EOT
  type = map(object({
    comment    = optional(string, "")
    interfaces = list(string)
  }))
  default = {}
}


# =================================================================================================
# NAT Rules
# =================================================================================================
variable "nat_rules" {
  description = <<-EOT
    Map of NAT rules to create. Rules are ordered by the 'order' field.

    Example:
    {
      "masquerade-wan" = {
        chain              = "srcnat"
        action             = "masquerade"
        out_interface_list = "WAN"
        order              = 100
      }
      "hairpin" = {
        comment            = "Hairpin NAT"
        chain              = "srcnat"
        action             = "masquerade"
        in_interface_list  = "LAN"
        out_interface_list = "LAN"
        order              = 200
      }
    }
  EOT
  type = map(object({
    chain              = string
    action             = string
    order              = number
    comment            = optional(string)
    connection_rate    = optional(string)
    src_address        = optional(string)
    dst_address        = optional(string)
    src_port           = optional(string)
    dst_port           = optional(string)
    protocol           = optional(string)
    in_interface       = optional(string)
    out_interface      = optional(string)
    in_interface_list  = optional(string)
    out_interface_list = optional(string)
    to_addresses       = optional(string)
    to_ports           = optional(string)
    log                = optional(bool)
    log_prefix         = optional(string)
  }))
  default = {}
}


# =================================================================================================
# Filter Rules
# =================================================================================================
variable "filter_rules" {
  description = <<-EOT
    Map of firewall filter rules to create. Rules are ordered by the 'order' field.

    Example:
    {
      "fasttrack" = {
        chain            = "forward"
        action           = "fasttrack-connection"
        connection_state = "established,related"
        hw_offload       = true
        order            = 100
      }
      "accept-established" = {
        chain            = "forward"
        action           = "accept"
        connection_state = "established,related,untracked"
        order            = 110
      }
    }
  EOT
  type = map(object({
    chain              = string
    action             = string
    order              = number
    comment            = optional(string)
    connection_state   = optional(string)
    src_address        = optional(string)
    dst_address        = optional(string)
    src_port           = optional(string)
    dst_port           = optional(string)
    protocol           = optional(string)
    in_interface       = optional(string)
    out_interface      = optional(string)
    in_interface_list  = optional(string)
    out_interface_list = optional(string)
    hw_offload         = optional(bool)
    log                = optional(bool)
    log_prefix         = optional(string)
    jump_target        = optional(string)
  }))
  default = {}
}
