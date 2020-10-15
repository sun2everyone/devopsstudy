#!/bin/bash
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
puma -d
ps -waux | grep puma | grep -v grep
CHK_DEPLOY=`ps -waux | grep puma | grep -v grep | wc -l`
if [ $CHK_DEPLOY == "1" ]; then
 echo "App installed, server running!"
 exit 0
else
 echo "Installation errors!"
 exit 1
fi
