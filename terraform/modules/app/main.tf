# Define external IP address
resource "google_compute_address" "reddit_app_ip" {
  name = "reddit-app-ip"
  network_tier = "STANDARD"
  project = "${var.project}"
}

# Define firewall rule to access app by http
resource "google_compute_firewall" "reddit_firewall_puma" {
  name    = "allow-puma-${var.reddit_network}"
  network = "${data.google_compute_network.reddit_network.self_link}"

  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = "${var.app_tags}"
}

data "google_compute_network" "reddit_network" {
  name = "${var.reddit_network}"
}

data "google_compute_subnetwork" "reddit_subnetwork" {
  name = "${var.reddit_network}"
  region = "${var.region}"
}

# Define boot disk image
data "google_compute_image" "reddit_app_base_image" {
  family  = "${var.app_disk_image}"
  project = "${var.project}"
}

# Define VM instance
resource "google_compute_instance" "reddit_app" {
  name         = "reddit-app"
  machine_type = "f1-micro"
  zone         = "${var.zone}"
  tags         = "${var.app_tags}"
  depends_on   = ["google_compute_address.reddit_app_ip"]

  boot_disk {
    initialize_params {
      #image = "${var.disk_image}"
      image = "${data.google_compute_image.reddit_app_base_image.self_link}"
    }
  }

  network_interface {
    #network       = "${data.google_compute_network.reddit_network.self_link}"
    subnetwork    = "${data.google_compute_subnetwork.reddit_subnetwork.self_link}"
    access_config = {
      network_tier = "STANDARD"
      nat_ip = "${google_compute_address.reddit_app_ip.address}"
    }
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

  #provisioner "file" {
  #  source      = "files/puma.service"
  #  destination = "/tmp/puma.service"
  #}

  #provisioner "remote-exec" {
  #  script = "files/deploy.sh"
  #}
}
