#!/bin/bash

set -e

URL="https://github.com/zeit/hyper/releases/download/2.1.2/hyper-2.1.2-x86_64.AppImage"

sudo apt-get update
sudo apt-get install -y fuse libnss3 libasound2 libdbus-glib-1-2

# Optional ??
# apt-get install -y --no-install-recommends libxss1 libgconf-2-4

mkdir -p ${HOME}/AI
wget ${URL} -O ${HOME}/AI/hyper.AppImage
chmod 0755 ${HOME}/AI/hyper.AppImage
