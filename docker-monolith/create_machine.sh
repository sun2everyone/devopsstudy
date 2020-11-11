#/bin/bash
MACHINE_TYPE="g1-small"
MACHINE_NAME=${2:-"docker-host"}
PROJECT=${1:-"default"}
echo "$MACHINE_NAME"

docker-machine create --driver google \
--google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts \
--google-machine-type $MACHINE_TYPE \
--google-zone europe-north1-a \
--google-project $PROJECT \
$MACHINE_NAME
