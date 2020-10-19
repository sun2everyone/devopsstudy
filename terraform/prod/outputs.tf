output "prod_app_external_ip" {
  value = "${module.app.app_external_ip}"
}

output "prod_app_internal_ip" {
  value = "${module.app.app_internal_ip}"
}

output "prod_mongo_internal_ip" {
  value = "${module.db.mongo_internal_ip}"
}
