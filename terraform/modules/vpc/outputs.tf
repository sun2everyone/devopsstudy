output "network_name" {
  value = "${google_compute_network.reddit_network.name}"
}

output "subnetwork_name" {
  value = "${google_compute_subnetwork.reddit_subnetwork.name}"
}
