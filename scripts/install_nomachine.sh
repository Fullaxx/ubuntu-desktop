#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"
URL="https://download.nomachine.com/download/8.11/Linux/nomachine_8.11.3_4_amd64.deb"
DEB="/tmp/nomachine.deb"

wget ${URL} -O ${DEB}
dpkg -i ${DEB} || (set -e; apt-get update; apt-get install -f -y)
rm ${DEB}

