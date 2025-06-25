variable "domain" {
  description = "The domain name to create the CNAME record in"
  type        = string
}

variable "cname" {
  description = "The subdomain/hostname part of the CNAME record (will be prefixed to the domain)"
  type        = string
}

variable "cname_target" {
  description = "The target/destination for the CNAME record"
  type        = string
}
