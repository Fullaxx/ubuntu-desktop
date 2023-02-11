#!/bin/bash

set -e

URL="http://www.avidemux.org/nightly/appImage4/avidemuxUniversal_amd64_230208_177.app"

sudo apt-get update
sudo apt-get install -y fuse libglu1 qt5dxcb-plugin

mkdir -p ${HOME}/AI
wget ${URL} -O ${HOME}/AI/avidemux.AppImage
chmod 0755 ${HOME}/AI/avidemux.AppImage
