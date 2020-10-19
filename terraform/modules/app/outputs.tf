output "app_external_ip" {
  value = "${google_compute_instance.reddit_app.network_interface.0.access_config.0.nat_ip}"
}

output "app_internal_ip" {
  value = "${google_compute_instance.reddit_app.network_interface.0.network_ip}"
}
