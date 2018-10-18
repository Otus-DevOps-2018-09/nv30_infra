#!/bin/bash

# Re-synchronize the package index files from their sources.
sudo apt update
# Install Ruby and Bundler.
sudo apt install -y ruby-full ruby-bundler build-essential
# Show installed packages versions.
echo "###############################################################"
echo "Installed Ruby version:"
ruby -v
echo "Installed Bundler version:"
bundler -v
echo "###############################################################"
