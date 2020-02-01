#!/bin/bash

set -e

sudo apt-get update
sudo apt-get install -y flatpak

flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak --user -y install flathub com.leinardi.gst
