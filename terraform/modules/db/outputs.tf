output "mongo_internal_ip" {
  value = "${google_compute_instance.reddit_db.network_interface.0.network_ip}"
}
