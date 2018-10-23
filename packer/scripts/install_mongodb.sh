#!/bin/bash
set -e

# Add key for mongodb repo without security checks.
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
# Add mongodb repo.
echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list
# Re-synchronize the package index files from their sources. 
apt update
# Install mongodb.
apt install -y mongodb-org
# Start mongodb service.
systemctl start mongod 
# Enable autostart of mongodb service.
systemctl enable mongod
