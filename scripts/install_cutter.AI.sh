#!/bin/bash

set -e

URL="https://github.com/radareorg/cutter/releases/download/v1.8.0/Cutter-v1.8.0-x64.Linux.AppImage"
#URL="https://github.com/radareorg/cutter/releases/download/v1.7.4/Cutter-v1.7.4-x64.Linux.AppImage"
#URL="https://github.com/radareorg/cutter/releases/download/v1.6/Cutter-v1.6-x86_64.AppImage"
#URL="https://github.com/radareorg/cutter/releases/download/v1.5/Cutter-v1.5-x86_64.AppImage"
#URL="https://github.com/radareorg/cutter/releases/download/v1.4/Cutter-v1.4-x86_64.AppImage"

sudo apt-get update
sudo apt-get install -y fuse
# v1.4 - v1.6: apt-get install -y fuse libnss3 libasound2

mkdir -p ${HOME}/AI
wget ${URL} -O ${HOME}/AI/Cutter.AppImage
chmod 0755 ${HOME}/AI/Cutter.AppImage
