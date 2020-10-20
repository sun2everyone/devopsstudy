## Preparation

Installation of gcloud: [https://cloud.google.com/sdk/docs/install](https://cloud.google.com/sdk/docs/install)

Installation of packer: [https://www.packer.io/downloads.html](https://www.packer.io/downloads.html)

Installation of terraform (use 0.11.11): [https://www.terraform.io/downloads.html](https://www.terraform.io/downloads.html)

Installation of ansible>=2.4 and cryptography==2.2.2:

```
cd ansible && pip install -r requirements.txt
```

## cloud-bastion:

bastion_IP = 35.217.57.76

someinternalhost_IP = 10.166.0.5

## cloud-app:

```
# Instance:
gcloud compute instances create reddit-ap \
--boot-disk-size=10GB \
--image-family ubuntu-1604-lts \
--image-project=ubuntu-os-cloud \
--machine-type=f1-micro \
--tags puma-server \
--restart-on-failure \
--zone=europe-north1-a
--metadata startup-script-url=https://raw.githubusercontent.com/sun2everyone/devopsstudy/cloud-testapp/startup.sh

# Firewall rule:
gcloud compute --project=devopsstudy firewall-rules create default-puma-server --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:9292 --source-ranges=0.0.0.0/0 --target-tags=puma-server
```

testapp_IP = 35.228.212.144

testapp_port = 9292

## packer-base:

Packer practice.

First, build ubuntu16.json, then immutable.json, then use create-reddit-vm.sh

## Terraform

Useful commands:

```
# Get modules
terraform init #or
terraform get

# Plan
terraform plan

# Fromat all .tf files
terraform fmt

# Show resources
terraform state list
 
# Destroy single resource:
terraform destroy -target module.db.google_compute_instance.reddit_db
```
