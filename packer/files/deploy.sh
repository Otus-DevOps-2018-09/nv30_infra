#!/bin/bash

# Clone reddit app repo.
cd ~
git clone -b monolith https://github.com/express42/reddit.git
# Install reddit app using Bundler.
cd reddit && bundle install
