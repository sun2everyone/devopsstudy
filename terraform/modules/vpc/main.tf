# Define reddit machines network (created manually, uncomment parameters and change to resource to create by terraform)
resource "google_compute_network" "reddit_network" {
  name = "${var.reddit_network}"
  auto_create_subnetworks = "false" 
  routing_mode = "GLOBAL" #or REGIONAL
}

# Reddit machines subnetwork
resource "google_compute_subnetwork" "reddit_subnetwork" {
  name   = "${var.reddit_network}"
  region = "${var.region}"
  ip_cidr_range = "10.2.0.0/29"
  network = "${google_compute_network.reddit_network.self_link}"
}

# Open SSH
resource "google_compute_firewall" "reddit_firewall_ssh" {
  name = "allow-ssh-${var.reddit_network}"
  network = "${google_compute_network.reddit_network.self_link}"
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
  network = "${google_compute_network.reddit_network.self_link}"
  priority = 1000
  description = "Allow to ${var.reddit_network} icmp"

  allow {
    protocol = "icmp"
  }

  source_ranges = ["${google_compute_subnetwork.reddit_subnetwork.ip_cidr_range}"]
}
