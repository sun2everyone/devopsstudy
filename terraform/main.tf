terraform {
  required_version = "0.11.11" #Protection from syntax breakage
}

provider "google" {
  version = "2.0.0"
  project = "${var.project}"
  region  = "${var.region}"
}

#use this for example to define something you dont control with TF
data "google_compute_image" "reddit_base_image" {
  family  = "${var.disk_image}"
  project = "${var.project}"
}

resource "google_compute_instance" "app" {
  name         = "reddit-app"
  machine_type = "f1-micro"
  zone         = "${var.zone}"
  tags         = "${var.tags}"

  boot_disk {
    initialize_params {
      #image = "${var.disk_image}"
      image = "${data.google_compute_image.reddit_base_image.self_link}"
    }
  }

  network_interface {
    network       = "default"
    access_config = {}        //Ephemeral IP
  }

  metadata {
    ssh-keys = "appuser:${file(var.ssh_pubkey_path)}\nappuser1:${file(var.ssh_pubkey_path)}"
  }

  connection {
    type        = "ssh"
    user        = "appuser"
    agent       = "false"
    private_key = "${file(var.ssh_privkey_path)}"
  }

  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
}

resource "google_compute_firewall" "firewall_puma" {
  name    = "allow-puma-default"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = "${var.tags}"
}
