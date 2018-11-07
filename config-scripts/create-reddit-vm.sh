#!/bin/bash

gcloud compute instances create reddit-app\
 --boot-disk-size=10GB \
 --image-family=reddit-full \
 --machine-type=g1-small \
 --tags puma-server,http-server,https-server \
 --restart-on-failure
