#!/bin/bash
curl -o install_ruby.sh https://raw.githubusercontent.com/sun2everyone/devopsstudy/cloud-testapp/install_ruby.sh && chmod +x install_ruby.sh
curl -o deploy.sh https://raw.githubusercontent.com/sun2everyone/devopsstudy/cloud-testapp/deploy.sh && chmod +x deploy.sh
curl -o install_mongodb.sh https://raw.githubusercontent.com/sun2everyone/devopsstudy/cloud-testapp/install_mongodb.sh && chmod +x install_mongodb.sh
./install_ruby.sh && ./install_mongodb.sh && ./deploy.sh
