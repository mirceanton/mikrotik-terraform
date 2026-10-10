terraform {
  required_version = ">= 1.0"

  required_providers {
    routeros = {
      source  = "terraform-routeros/routeros"
    }
  }
}

variable "nas_ip" {
  description = "IP address of the NAS for remote syslog"
  type        = string
}

# Disk-based logging action for persistent local storage
resource "routeros_system_logging_action" "disk" {
  name   = "disk-persist"
  target = "disk"
  # Lines per file before rotation
  disk_lines_per_file = 10000
  # Files kept before oldest is deleted
  disk_file_count = 50
  # Stop writing when disk is nearly full
  disk_stop_on_full = false
}

# Remote syslog to NAS (for centralized log collection)
resource "routeros_system_logging_action" "remote_nas" {
  name    = "remote-nas"
  target  = "remote"
  remote  = var.nas_ip
  src_address = "10.0.20.1"
  # Standard syslog facility
  remote_syslog_facility = "local7"
}

# Route firewall and system topics to BOTH disk and remote syslog
resource "routeros_system_logging" "firewall_to_disk" {
  topics = "firewall"
  action = routeros_system_logging_action.disk.name
}

resource "routeros_system_logging" "firewall_to_remote" {
  topics = "firewall"
  action = routeros_system_logging_action.remote_nas.name
}

resource "routeros_system_logging" "system_to_disk" {
  topics = "system,info,error,warning"
  action = routeros_system_logging_action.disk.name
}