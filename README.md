[![Build Status](https://travis-ci.org/sun2everyone/devopsstudy.svg?branch=master)](https://travis-ci.org/sun2everyone/devopsstudy)

## Preparation

Installation of gcloud: [https://cloud.google.com/sdk/docs/install](https://cloud.google.com/sdk/docs/install)

Installation of packer: [https://www.packer.io/downloads.html](https://www.packer.io/downloads.html)

Installation of terraform (use 0.11.11): [https://www.terraform.io/downloads.html](https://www.terraform.io/downloads.html)

Installation of ansible>=2.4 and cryptography==2.2.2:

```
cd ansible && pip install -r requirements.txt
```

Install Vagrant: [https://www.vagrantup.com/downloads.html](https://www.vagrantup.com/downloads.html)

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

## Packer:

```
packer validate -var-file=variables.json app.json

packer build -var-file=variables.json app.json
```

Packer practice.

First, build ubuntu16.json, then immutable.json, then use create-reddit-vm.sh

With ansible provisioners - run from repository root!

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
terraform destroy -target=module.db.google_compute_instance.reddit_db

# Destroy all compute instances:
terraform state list | grep compute_instance. | xargs -n1 -I{} terraform destroy --auto-approve=true -target={}
```

## Ansible

Command examples (from **devopsstudy/ansible**):

```
# Encrypt credentials
ansible-vault encrypt environments/*/credentials.yml
EDITOR=nano ansible-vault edit ./environments/test/credentials.yml

# Run playbook in environment
ansible-playbook -i ./environments/test/gcp_inventory.py playbooks/ping.yml

# View all gcp hosts (can be used with environment too)
ansible-inventory -i ./gcp_inventory.py --graph

# Deploy testapp on terraform-provisioned infra
ansible-playbook -i environments/test/gcp_inventory.py --tags=config,deploy playbooks/site.yml
```

## Vagrant

Vagrant-libvirt documentation: [https://github.com/vagrant-libvirt/vagrant-libvirt](https://github.com/vagrant-libvirt/vagrant-libvirt)

Use vagrant docker-based with libvirt:

```
docker run -it --rm \
  -e LIBVIRT_DEFAULT_URI \
  -v /var/run/libvirt/:/var/run/libvirt/ \
  -v ~/.vagrant.d:/.vagrant.d \
  -v $(pwd):$(pwd) \
  -w $(pwd) \
  vagrantlibvirt/vagrant-libvirt:latest \
    vagrant status
```

## Python virtualenv

```
 apt-get install python-virtualenv
apt-get install python3-venv
apt-get install virtualenvwrapper
#cd ansible && virtualenv .venv #Python2
cd ansible && python3 -m venv .venv #Python3

#start working in venv
source .venv/bin/activate

#install requirements
pip install --upgrade pip
pip install -r requirements.txt

#after work is done
deactivate
```

## Molecule & Tesinfra

[Testinfra documentation](https://testinfra.readthedocs.io/en/latest/modules.html)

*Work in venv!*

cd **ansible/roles/db**

```
#initalize role testing template
molecule init scenario -r db -d vagrant --verifier-name testinfra default

#db/molecule/default/molecule.yml - provider settings

#create test vm
molecule create

#list instances
molecule list

#connect for debug
molecule login -h instance

#db/molecule/default/converge.yml - playbook for provisioning with role, vars go here

#Provisioning with role
molecule converge

#db/molecule/default/tests/test_default.py - testinfra test code

#Testing role
molecule verify
```

## Docker machine

With gcloud. Needs installed docker, docker machine, gloud sdk. Before usage:

```
gcloud init
gcloud auth application-default login
```

Create host:

```
docker-machine create --driver google \
--google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts \
--google-machine-type g1-small \
--google-zone europe-north1-a \
docker-host
```

or use script `./docker-monolith/create_machine.sh`

Switch to remote docker context for current tty:

```
eval $(docker-machine env docker-host) #remote docker
eval $(docker-machine env --unset) #local docker
```

## Gitlab

How to deploy gitlab instance. Commands from `./gitlab-ci`

### Step 1: login to gce (assuming you have ansible,terraform,glcoud installed)

```
gcloud auth login
gcloud auth application-default login
```

### Step 2: create gitlab VM

```
# Adjust variables
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars

# Get external ip and terraform plan
./tf_external_ip_rule.sh

# Start VM
terraform apply

```

### Step 3: Provision gitlab VM

`````
ansible-playbook -e gitlab_external_ip=<x.x.x.x> playbooks/gitlab_provision.yml
`````

### Step 4: How to run and stop gitlab

```
# Run via compose
ansible-plybook playbooks/gitlab_run.yml #long load! You may login via ssh and check with `docker logs -f`
# Stop server
gcloud compute instances stop server-gitlab
# or compose-down
ansible-playbook playbooks/gitlab_stop.yml
```

### Step 5: add gitlab runner

```
ansible-playbook playbooks/gitlab_runner_provision.yml
```

Please do this manual steps to register it:

1. Obtain token via gitlab web interface: Settings -> CI/CD -> Runners -> Expand
2. login via: `ssh -i appuser appuser@$gitlab_ip`
3. Register runner with token: `docker exec -it gitlab_gitlab-runner_1 gitlab-runner register --run-untagged --locked=false` specifying address `http://web/`

### Step 6: Cleanup

```
# Destroy resources to save money
terraform destroy
```
