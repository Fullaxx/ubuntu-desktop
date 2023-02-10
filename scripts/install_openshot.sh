#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"

apt-get update
apt-get install -y gnupg2 software-properties-common

apt-add-repository -y ppa:openshot.developers/libopenshot-daily

apt-get update
apt-get install -y openshot-qt
