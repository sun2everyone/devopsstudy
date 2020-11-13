#!/bin/bash
echo "Gettting external IP for terraform rules..."
IP=`curl -Ls -o - https://api.myip.com | grep -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | sed -E 's/[^0-9.]*//g'`
if [[ $IP != "" ]]; then
echo $IP
sed -i "s/myiprange=.*/myiprange= \"$IP\/32\"/" terraform.tfvars
terraform plan
echo "Now please run terraform apply!"
exit 0
else
echo "No IP found, check manually: "
curl -Ls -o - https://api.myip.com
exit 1
fi
