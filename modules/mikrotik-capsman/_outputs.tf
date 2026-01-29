output "wifi_passphrases" {
  description = "Map of WiFi network names to their passphrases (provided or generated)"
  value       = local.wifi_passphrases
  sensitive   = true
}
