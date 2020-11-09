# Micorservices

Install and create docker machine (see root README). Switch to remote docker context.

Build commands:

```
docker build -t reddit/comment:2.2 ./comment
docker build -t reddit/ui:2.2 ./ui
docker build -t reddit/post:2.2 ./post-py
```

Create *terraform.tfvars* with content:

```
project="gcpprojectname"
myiprange = "my.external.ip.range/32"
```

Create firewall rule:

```
terraform init
terraform plan
terraform apply
```

Run containers in docker-machine using `./run_containers.sh`
