output "mongo_internal_ip" {
  value = "${google_compute_instance.reddit_db.network_interface.0.network_ip}"
}
output "mongo_external_ip" {
  value = "${google_compute_instance.reddit_db.network_interface.0.access_config.0.nat_ip}"
}
