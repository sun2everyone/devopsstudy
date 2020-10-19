terraform {
  required_version = "0.11.11" #Protection from syntax breakage
}

provider "google" {
  version = "2.0.0"
  project = "${var.project}"
  region  = "${var.region}"
}

## Production configuration

module "vpc" {
  source          = "../modules/vpc"                           # Creates network and subnet for selected region
  project         = "${var.project}"
  region          = "${var.region}"
  zone            = "${var.zone}"
  reddit_network  = "${var.reddit_network}-${var.env_postfix}"
  ip_cidr_range   = "10.2.0.0/29"
  ssh_allowed_ips = "109.252.36.120/32"
}

module "app" {
  source           = "../modules/app"
  project          = "${var.project}"
  region           = "${var.region}"
  zone             = "${var.zone}"
  ssh_pubkey_path  = "${var.ssh_pubkey_path}"
  ssh_privkey_path = "${var.ssh_privkey_path}"
  reddit_network   = "${module.vpc.subnetwork_name}"
  app_tags         = "${var.app_tags}"
  app_disk_image   = "${var.app_disk_image}"
  db_url           = "${module.db.mongo_internal_ip}"
  instance_name    = "reddit-app-${var.env_postfix}"
}

module "db" {
  source           = "../modules/db"
  project          = "${var.project}"
  region           = "${var.region}"
  zone             = "${var.zone}"
  ssh_pubkey_path  = "${var.ssh_pubkey_path}"
  ssh_privkey_path = "${var.ssh_privkey_path}"
  reddit_network   = "${module.vpc.subnetwork_name}"
  db_tags          = "${var.db_tags}"
  db_disk_image    = "${var.db_disk_image}"
  instance_name    = "reddit-db-${var.env_postfix}"
}
