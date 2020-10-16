#!/bin/bash
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
ln -s /usr/local/bin/puma
systemctl daemon-reload
systemctl enable reddit
