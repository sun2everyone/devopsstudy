output "app_external_ip" {
  value = "${module.app.app_external_ip}"
}
output "app_internal_ip" {
  value = "${module.app.app_internal_ip}"
}
output "mongo_external_ip" {
  value = "${module.db.mongo_external_ip}"
}
output "mongo_internal_ip" {
  value = "${module.db.mongo_internal_ip}"
}
