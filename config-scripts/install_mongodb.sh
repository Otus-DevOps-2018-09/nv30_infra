#!/bin/bash

# Add key for mongodb repo without security checks.
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
# Add mongodb repo.
sudo bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'
# Re-synchronize the package index files from their sources. 
sudo apt update
# Install mongodb.
sudo apt install -y mongodb-org
# Start mongodb service.
sudo systemctl start mongod 
# Enable autostart of mongodb service.
sudo systemctl enable mongod
# Show mongodb service status.
echo "###############################################################"
echo "MongoDB service status::"
sudo systemctl status mongodb
echo "###############################################################"
