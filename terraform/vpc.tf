# Define reddit machines network (created manually, uncomment parameters and change to resource to create by terraform)
data "google_compute_network" "reddit_network" {
  name = "${var.reddit_network}"
  #auto_create_subnetworks = "true" 
  #routing_mode = "GLOBAL"
}

# Reddit machines subnetwork
data "google_compute_subnetwork" "reddit_subnetwork" {
  name   = "${var.reddit_network}"
  region = "${var.region}"
}

# Open SSH
resource "google_compute_firewall" "reddit_firewall_ssh" {
  name = "allow-ssh-${var.reddit_network}"
  network = "${data.google_compute_network.reddit_network.self_link}"
  priority = 1000
  description = "Allow to ${var.reddit_network} SSH from anywhere"

  allow {
    protocol = "tcp"
    ports = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# Open Internal ICMP for ping
resource "google_compute_firewall" "reddit_firewall_icmp" {
  name = "allow-icmp-${var.reddit_network}"
  network = "${data.google_compute_network.reddit_network.self_link}"
  priority = 1000
  description = "Allow to ${var.reddit_network} icmp"

  allow {
    protocol = "icmp"
  }

  source_ranges = ["${data.google_compute_subnetwork.reddit_subnetwork.ip_cidr_range}"]
}