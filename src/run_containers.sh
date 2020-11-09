#!/bin/bash
docker network create reddit
docker volume create reddit-db
docker run --rm -d --network=reddit --network-alias=post_db --network-alias=comment_db -v reddit_db:/data/db --name=reddit-mongo mongo:latest
docker run --rm -d --network=reddit --network-alias=post --name=reddit-post reddit/post:2.2
docker run --rm -d --network=reddit --network-alias=comment --name=reddit-comment reddit/comment:2.2
docker run --rm -d --network=reddit -p 9292:9292 --name=reddit-ui reddit/ui:2.2
docker-machine ls | grep tcp | sed 's/tcp:/http:/' | sed 's/2376/9292/'
