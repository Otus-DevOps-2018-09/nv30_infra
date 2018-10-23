#!/bin/bash
set -e

# Re-synchronize the package index files from their sources.
apt update
# Install Ruby and Bundler.
apt install -y ruby-full ruby-bundler build-essential
