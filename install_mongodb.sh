#!/bin/bash
gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv D68FA50FEA312927
gpg --export --armor D68FA50FEA312927 | sudo apt-key add -
sudo bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'
sudo apt-get update
sudo apt install -y mongodb-org
sudo systemctl start mongod
sudo systemctl enable mongod
CHK_MONGO_RUNNING=`sudo systemctl status mongod | grep running | wc -l`
CHK_MONGO_ENABLED=`sudo systemctl status mongod | grep 'service; enabled' | wc -l`
if [ $CHK_MONGO_RUNNING == "1" ] && [ $CHK_MONGO_ENABLED == "1" ]; then
 echo "Mongodb installed"
 exit 0
else
 echo "Errors occured!"
 exit 1
fi
