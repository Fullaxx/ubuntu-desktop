#!/bin/bash

set -e

URL="https://github.com/mb21/panwriter/releases/download/v0.6.2/panwriter-0.6.2-x86_64.AppImage"

sudo apt-get update
sudo apt-get install -y fuse libnss3 libgtk-3-0 libasound2

mkdir -p ${HOME}/AI
wget ${URL} -O ${HOME}/AI/panwriter.AppImage
chmod 0755 ${HOME}/AI/panwriter.AppImage
