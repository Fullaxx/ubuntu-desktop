#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"
URL="https://update.code.visualstudio.com/1.80.2/linux-deb-x64/stable"
DEB="/tmp/vscode.deb"

wget ${URL} -O ${DEB}
dpkg -i ${DEB} || (set -e; apt-get update; apt-get install -f -y; apt-get install -y libgbm1 libasound2t64)
rm ${DEB}
