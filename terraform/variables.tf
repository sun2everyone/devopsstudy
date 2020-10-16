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

variable ssh_pubkey_path {
  description = "Path to the public ssh key for future auth"
}

variable ssh_privkey_path {
  description = "Path to the private ssh key for provisioners"
}

variable disk_image {
  description = "VM boot disk image"
}

variable tags {
  description = "Network tags"
  default     = []
}
