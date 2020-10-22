#!/bin/bash
echo "Destroying compute instances: "
terraform state list | grep compute_instance.
read -p "Are you sure? " -n 1 -r
echo ""   # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    for i in 5 4 3 2 1
    do
        echo "Destroy all compute instances in $i..."
        sleep 1
    done
    echo "Destroying...."    
    terraform state list | grep compute_instance. | xargs -n1 -I{} terraform destroy --auto-approve=true -target={}
fi
exit 0
