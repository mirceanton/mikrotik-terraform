output "wifi_passphrases" {
  description = "Map of WiFi network names to their passphrases (provided or generated)"
  value       = local.wifi_passphrases
  sensitive   = true
}

output "wifi_security_profiles" {
  description = "Map of WiFi network names to their security profile names"
  value = {
    for k, v in routeros_wifi_security.this : k => v.name
  }
}

output "wifi_configurations" {
  description = "Map of WiFi network names to their configuration names"
  value = {
    for k, v in routeros_wifi_configuration.this : k => v.name
  }
}
