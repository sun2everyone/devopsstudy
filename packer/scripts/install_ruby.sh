#!/bin/bash
set -e
apt-get update
apt-get install -y ruby-full ruby-bundler build-essential
CHK_RUBY=`ruby -v | grep 2.3.1 | wc -l`
CHK_BUNDLER=`bundler -v | grep 1.11.2 | wc -l`
if [ $CHK_RUBY == "1" ] && [ $CHK_BUNDLER == "1" ]; then
 echo "Ruby installed!"
 exit 0
else
 echo "Installation errors!"
 exit 1
fi
