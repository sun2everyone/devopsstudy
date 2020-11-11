#!/bin/bash
TAG=${1:-"1.0"}
docker build -t reddit/comment:$TAG ./comment
docker build -t reddit/ui:$TAG ./ui
docker build -t reddit/post:$TAG ./post-py
