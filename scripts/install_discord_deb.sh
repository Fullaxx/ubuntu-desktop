#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"
URL="https://discord.com/api/download?platform=linux&format=deb"
DEB="/tmp/discord.deb"

wget ${URL} -O ${DEB}
# apt-get (not dpkg -i) resolves the package's dependencies before installing, and fails if it can't
# (dpkg -i || apt-get install -f removed an uninstallable package and still exited 0)
# (no libgbm1: Discord's package declares it, and libasound2, itself)
# libpulse0: Discord's voice module (discord_voice.node) links PulseAudio's client library and doesn't
# load without it; Discord downloads the module at first start, so its package doesn't list it.
# Voice also needs a PulseAudio server to connect to, which the image doesn't run
apt-get update
apt-get install -y ${DEB} libpulse0
rm ${DEB}
