variable project {
  description = "Project ID"
}

variable region {
  description = "Region"
  default     = "europe-north1"
}

variable zone {
  description = "Zone"
  default     = "europe-north1-a"
}

variable reddit_network {
  description = "Reddit machines network name"
  default     = "reddit-default"
}

variable ip_cidr_range {
  description = "Reddit machines subnetwork IP range"
  default     = "10.2.0.0/16"
}

variable ssh_allowed_ips {
  description = "Addresses to allow ssh connection"
  default     = "0.0.0.0/0"
}
