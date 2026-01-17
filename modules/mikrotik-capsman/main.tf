# =================================================================================================
# CAPsMAN Settings
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/wifi_capsman
# =================================================================================================
resource "routeros_wifi_capsman" "settings" {
  enabled                  = true
  interfaces               = var.capsman_interfaces
  upgrade_policy           = var.upgrade_policy
  require_peer_certificate = var.require_peer_certificate
}


# =================================================================================================
# WiFi Channels
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/wifi_channel
#
# Creates a channel resource for each unique band used by the wifi_networks.
# =================================================================================================
locals {
  # Extract unique bands from wifi_networks
  unique_bands = toset([for k, v in var.wifi_networks : v.band])

  # Map band to a friendly channel name
  band_to_channel_name = {
    "2ghz-ax" = "2.4ghz"
    "5ghz-ax" = "5ghz"
    "2ghz-n"  = "2.4ghz-n"
    "5ghz-n"  = "5ghz-n"
    "5ghz-ac" = "5ghz-ac"
  }

  # Create unique datapaths based on vlan_id + client_isolation combination
  unique_datapaths = {
    for k, v in var.wifi_networks : "${v.vlan_id}-${v.client_isolation}" => {
      vlan_id          = v.vlan_id
      client_isolation = v.client_isolation
    }...
  }

  # Flatten to get one entry per unique combination
  datapath_configs = {
    for key, configs in local.unique_datapaths : key => configs[0]
  }

  # Group networks by band for provisioning rules
  networks_by_band = {
    for band in local.unique_bands : band => {
      for k, v in var.wifi_networks : k => v if v.band == band
    }
  }

  # Determine master configuration per band (first alphabetically)
  provisioning_master = {
    for band, networks in local.networks_by_band : band => sort(keys(networks))[0]
  }
}

resource "routeros_wifi_channel" "this" {
  for_each = local.unique_bands

  name = local.band_to_channel_name[each.value]
  band = each.value
}


# =================================================================================================
# WiFi Security
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/wifi_security
#
# Creates a security profile for each WiFi network.
# Uses provided passphrase if specified, otherwise generates a random 32-character string.
# =================================================================================================
locals {
  # Networks that need a generated passphrase (none provided)
  networks_needing_passphrase = {
    for k, v in var.wifi_networks : k => v if v.passphrase == null
  }

  # Resolve final passphrase for each network
  wifi_passphrases = {
    for k, v in var.wifi_networks : k => (
      v.passphrase != null ? v.passphrase : random_string.wifi_passphrase[k].result
    )
  }
}

resource "random_string" "wifi_passphrase" {
  for_each = local.networks_needing_passphrase

  length = 32
}

resource "routeros_wifi_security" "this" {
  for_each = var.wifi_networks

  name                 = "${each.key}-wifi-security"
  authentication_types = ["wpa2-psk", "wpa3-psk"]
  passphrase           = local.wifi_passphrases[each.key]
}


# =================================================================================================
# WiFi Datapath
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/wifi_datapath
#
# Creates a datapath for each unique VLAN + client_isolation combination.
# =================================================================================================
resource "routeros_wifi_datapath" "this" {
  for_each = local.datapath_configs

  name             = "vlan-${each.value.vlan_id}-tagging"
  comment          = "WiFi -> VLAN ${each.value.vlan_id}"
  vlan_id          = each.value.vlan_id
  client_isolation = each.value.client_isolation
}


# =================================================================================================
# WiFi Configurations
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/wifi_configuration
#
# Creates a configuration for each WiFi network.
# =================================================================================================
resource "routeros_wifi_configuration" "this" {
  for_each = var.wifi_networks

  name    = each.value.ssid
  ssid    = each.value.ssid
  country = var.country

  channel = {
    config = routeros_wifi_channel.this[each.value.band].name
  }
  datapath = {
    config = routeros_wifi_datapath.this["${each.value.vlan_id}-${each.value.client_isolation}"].name
  }
  security = {
    config = routeros_wifi_security.this[each.key].name
  }
}


# =================================================================================================
# WiFi Provisioning
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/wifi_provisioning
#
# Creates a provisioning rule for each band, with master and slave configurations.
# =================================================================================================
resource "routeros_wifi_provisioning" "this" {
  for_each = local.networks_by_band

  action          = "create-dynamic-enabled"
  comment         = routeros_wifi_configuration.this[local.provisioning_master[each.key]].name
  supported_bands = [each.key]

  master_configuration = routeros_wifi_configuration.this[local.provisioning_master[each.key]].name

  slave_configurations = [
    for k in sort(keys(each.value)) :
    routeros_wifi_configuration.this[k].name
    if k != local.provisioning_master[each.key]
  ]
}
