## cloud-bastion:

bastion_IP = 35.217.57.76 

someinternalhost_IP = 10.166.0.5

## cloud-app:

```
gcloud compute instances create reddit-app \
--boot-disk-size=10GB \
--image-family ubuntu-1604-lts \
--image-project=ubuntu-os-cloud \
--machine-type=f1-micro \
--tags puma-server \
--restart-on-failure \
--metadata startup-script-url=https://raw.githubusercontent.com/sun2everyone/devopsstudy/cloud-testapp/startup.sh
```

testapp_IP = 35.228.212.144

testapp_port = 9292
