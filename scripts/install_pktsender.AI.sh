#!/bin/bash

set -e

URL="https://github.com/dannagle/PacketSender/releases/download/v6.1.25/PacketSender_Linux_x64_v6.1.25.AppImage"

sudo apt-get update
sudo apt-get install -y fuse

mkdir -p ${HOME}/AI
wget ${URL} -O ${HOME}/AI/pktsender.AppImage
chmod 0755 ${HOME}/AI/pktsender.AppImage
