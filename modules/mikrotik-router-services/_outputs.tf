output "untrusted_wifi_password" {
  description = "Password for the untrusted WiFi network"
  value       = random_string.untrusted_wifi_password.result
  sensitive   = true
}

output "guest_wifi_password" {
  description = "Password for the guest WiFi network"
  value       = random_string.guest_wifi_password.result
  sensitive   = true
}

