terraform {
  required_version = "0.11.11" #Protection from syntax breakage
}

variable project {
    description="gcp project"
}

variable ssh_pubkey_path {
    description="path to ssh pubkey to authenticate"
}

variable myiprange {
    description="ips to allow access for"
    default="0.0.0.0/0"
}

provider "google" {
  version = "2.0.0"
  project = "${var.project}"
  region  = "europe-north1"
}

resource "google_compute_address" "gitlab_ip" {
    name="gitlab-ip"
    network_tier = "STANDARD"
}

# Define VM instance
resource "google_compute_instance" "gitlab" {
  name         = "server-gitlab"
  machine_type = "n1-standard-1"
  zone         = "europe-north1-a"
  tags         = ["gitlab"]

  depends_on   = ["google_compute_address.gitlab_ip"]

  boot_disk {
    initialize_params {
      image = "ubuntu-1604-lts"
    }
  }
  network_interface {
    network = "default"
    access_config = {
      nat_ip = "${google_compute_address.gitlab_ip.address}"
      network_tier = "STANDARD"
    }
  }
  metadata {
    ssh-keys = "appuser:${file(var.ssh_pubkey_path)}\nappuser1:${file(var.ssh_pubkey_path)}"
  }
}

# Open access
resource "google_compute_firewall" "gitlab_allow" {
  name        = "allow-gitlab"
  network     = "default"
  priority    = 1000
  description = "Allow HTTP, HTTPS and SSH on 2222 to gitlab"

  allow {
    protocol = "tcp"
    #ports    = ["80","443","2222"]
    ports    = ["80","443"]
  }

  target_tags = ["gitlab"]
  source_ranges = ["${var.myiprange}","${google_compute_address.gitlab_ip.address}/32"]
}
