# Firstly, create bucket !! Comment to use local
terraform {
  backend "gcs" {
    bucket  = "devoops-terraform-tfstate"
    prefix  = "terraform/stage"
  }
}
