#!/bin/bash

set -e

URL="https://github.com/npezza93/archipelago/releases/download/v3.2.1/Archipelago-3.2.1-x86_64.AppImage"

sudo apt-get update
sudo apt-get install -y fuse libnss3 libgtk-3-0 libasound2

mkdir -p ${HOME}/AI
wget ${URL} -O ${HOME}/AI/Archipelago.AppImage
chmod 0755 ${HOME}/AI/Archipelago.AppImage
