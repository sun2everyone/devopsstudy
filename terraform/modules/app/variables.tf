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

variable reddit_network {
  description = "Reddit machines network name"
  default = "reddit-default"
}

variable app_tags {
  description = "Network tags for reddit app"
  default     = ["reddit-app"]
}

variable app_disk_image {
  description = "Base disk image for reddit app"
}

variable db_url { 
    description = "Mongo database URL for reddit app"
}
