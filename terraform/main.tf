terraform {
  required_version = "0.11.11" #Protection from syntax breakage
}

provider "google" {
  version = "2.0.0"
  project = "${var.project}"
  region  = "${var.region}"
}
