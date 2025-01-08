# =================================================================================================
# System Identity
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/system_identity
# =================================================================================================
resource "routeros_system_identity" "identity" {
  name = "Rack Slow"
}
