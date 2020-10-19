#!/bin/bash
set -e
gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv D68FA50FEA312927
gpg --export --armor D68FA50FEA312927 | apt-key add -
bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'
apt-get update
apt install -y mongodb-org
sudo sed -i /etc/mongod.conf -e "s/^.*bindIp:.*$/  bindIp: 0.0.0.0/"
systemctl start mongod
systemctl enable mongod
CHK_MONGO_RUNNING=`systemctl status mongod | grep running | wc -l`
CHK_MONGO_ENABLED=`systemctl status mongod | grep 'service; enabled' | wc -l`
if [ $CHK_MONGO_RUNNING == "1" ] && [ $CHK_MONGO_ENABLED == "1" ]; then
 echo "Mongodb installed"
 exit 0
else
 echo "Errors occured!"
 exit 1
fi
