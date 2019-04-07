#!/bin/bash

set -e

URL="https://github.com/tympanix/Electorrent/releases/download/v2.6.0/electorrent-2.6.0-x86_64.AppImage"

sudo apt-get update
sudo apt-get install -y fuse libnss3 libgtk-3-0 libasound2

mkdir -p ${HOME}/AI
wget ${URL} -O ${HOME}/AI/electorrent.AppImage
chmod 0755 ${HOME}/AI/electorrent.AppImage
