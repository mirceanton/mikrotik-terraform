# =================================================================================================
# System Identity
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/system_identity
# =================================================================================================
resource "routeros_system_identity" "identity" {
  name = "Rack Fast"
}


# =================================================================================================
# System Timezone
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/system_clock
# =================================================================================================
resource "routeros_system_clock" "timezone" {
  time_zone_name       = "Europe/Bucharest"
  time_zone_autodetect = false
}
