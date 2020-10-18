# Define firewall rule to access db
resource "google_compute_firewall" "reddit_firewall_mongo" {
  name    = "allow-mongo-${var.reddit_network}"
  network = "${data.google_compute_network.reddit_network.self_link}"

  allow {
    protocol = "tcp"
    ports    = ["27017"]
  }

  source_ranges = ["${data.google_compute_subnetwork.reddit_subnetwork.ip_cidr_range}"]
  #target_tags   = "${var.db_tags}"
  #source_tags   = "${var.app_tags}"
}

# Define boot disk image
data "google_compute_image" "reddit_db_base_image" {
  family  = "${var.db_disk_image}"
  project = "${var.project}"
}

# Define VM instance for mongo database
resource "google_compute_instance" "reddit_db" {
  name         = "reddit-db"
  machine_type = "f1-micro"
  zone         = "${var.zone}"
  tags         = "${var.db_tags}"

  boot_disk {
    initialize_params {
      #image = "${var.disk_image}"
      image = "${data.google_compute_image.reddit_db_base_image.self_link}"
    }
  }

  network_interface {
    network       = "${data.google_compute_network.reddit_network.self_link}"
    access_config = {
      network_tier = "STANDARD"
    } # Commented - do not have external IP, uncommented - Ephemeral IP
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