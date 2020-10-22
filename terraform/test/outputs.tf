output "stage_app_external_ip" {
  value = "${module.app.app_external_ip}"
}

output "stage_app_internal_ip" {
  value = "${module.app.app_internal_ip}"
}

output "stage_mongo_internal_ip" {
  value = "${module.db.mongo_internal_ip}"
}

output "stage_mongo_external_ip" {
  value = "${module.db.mongo_external_ip}"
}

