output "interface_name" {
  description = "The name of the created PPPoE client interface"
  value       = routeros_interface_pppoe_client.this.name
}
