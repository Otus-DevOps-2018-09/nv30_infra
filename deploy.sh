#!/bin/bash

# Clone reddit app repo.
cd ~
git clone -b monolith https://github.com/express42/reddit.git
# Install reddit app using Bundler.
cd reddit && bundle install
# Start puma web server as daemon for reddit app.
puma -d
# Check port for puma web server.
echo "###############################################################"
echo "Puma web server TCP port:"
ps aux | grep "[p]uma" | awk -F: '{print $5}' | awk -F')' '{print $1}'
echo "###############################################################"
