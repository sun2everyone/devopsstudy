#!/bin/bash
TAG=${1:-"1.0"}
docker network create reddit-front --subnet=10.0.2.0/24
docker network create reddit-back --subnet=10.0.1.0/24
docker volume create reddit-db
docker run --rm -d --network=reddit-back --network-alias=post_db --network-alias=comment_db -v reddit-db:/data/db --name=reddit-mongo mongo:latest
docker run --rm -d --network=reddit-front --network-alias=post --name=reddit-post reddit/post:$TAG
docker run --rm -d --network=reddit-front --network-alias=comment --name=reddit-comment reddit/comment:$TAG
docker run --rm -d --network=reddit-front  -p 9292:9292 --name=reddit-ui --network-alias=ui reddit/ui:$TAG
docker network connect reddit-back reddit-post
docker network connect reddit-back reddit-comment
docker-machine ls | grep tcp | sed 's/tcp:/http:/' | sed 's/2376/9292/'
