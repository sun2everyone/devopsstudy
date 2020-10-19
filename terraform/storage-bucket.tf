terraform {
  required_version = "0.11.11" #Protection from syntax breakage
}

provider "google" {
  version = "2.0.0"
  project = "${var.project}"
  region  = "${var.region}"
}

# Initialize bucket for backends!

module "storage-bucket" {
  source  = "SweetOps/storage-bucket/google"
  version = "0.1.1"
  # insert the 1 required variable here
  name = ["devoops-terraform-tfstate"]
  versioning_enabled = "true"
  force_destroy = "true"
}

output bucket_url {
    value = "${module.storage-bucket.url}"
}
