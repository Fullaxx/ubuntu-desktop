#!/bin/bash

set -e

URL="https://github.com/mgechev/ngrev/releases/download/0.0.26/ngrev-0.0.26-x86_64.AppImage"

sudo apt-get update
sudo apt-get install -y fuse libnss3 libgtk-3-0 libasound2

mkdir -p ${HOME}/AI ${HOME}/.config/ngrev/themes
wget ${URL} -O ${HOME}/AI/ngrev.AppImage
chmod 0755 ${HOME}/AI/ngrev.AppImage
