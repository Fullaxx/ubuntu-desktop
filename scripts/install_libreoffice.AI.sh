#!/bin/bash

set -e

URL="https://libreoffice.soluzioniopen.com/stable/fresh/LibreOffice-fresh.basic-x86_64.AppImage"

sudo apt-get update
sudo apt-get install -y fuse

# Optional ??
# apt-get install -y --no-install-recommends openjdk-11-jre-headless

mkdir -p ${HOME}/AI
wget ${URL} -O ${HOME}/AI/LibreOffice-fresh.AppImage
chmod 0755 ${HOME}/AI/LibreOffice-fresh.AppImage
