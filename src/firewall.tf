terraform {
  required_version = "0.11.11" #Protection from syntax breakage
}

variable project {
    description = "GCP project"
}

variable myiprange {
  description = "My IP addresses range"
}

provider "google" {
  version = "2.0.0"
  project = "${var.project}"
  region  = "europe-north1-a"
}

# Define firewall rule to access db
resource "google_compute_firewall" "reddit_firewall_puma" {
  name    = "default-allow-puma"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }

  source_ranges = ["${var.myiprange}"]
  direction     = "INGRESS"
  #target_tags   = "${var.db_tags}"
  #source_tags   = "${var.app_tags}"
}
