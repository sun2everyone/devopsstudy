#!/bin/bash
set -e

gcloud compute instances create reddit-app \
--boot-disk-size=10GB \
--image reddit-full-1602855133 \
--image-project=devopsstudy \
--machine-type=f1-micro \
--tags puma-server \
--restart-on-failure