#!/bin/bash
docker network create reddit
docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db mongo:latest
docker run -d --network=reddit --network-alias=post reddit/post:1.0
docker run -d --network=reddit --network-alias=comment reddit/comment:1.0
docker run -d --network=reddit -p 9292:9292 reddit/ui:1.0
