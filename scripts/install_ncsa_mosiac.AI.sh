#!/bin/bash

set -e

URL="https://github.com/AppImage/NCSA-Mosaic-AppImage/releases/download/1/NCSA_Mosaic-git.6f488cb-x86_64.AppImage"

sudo apt-get update
sudo apt-get install -y fuse

mkdir -p ${HOME}/AI
wget ${URL} -O ${HOME}/AI/NCSA_Mosaic.AppImage
chmod 0755 ${HOME}/AI/NCSA_Mosaic.AppImage
