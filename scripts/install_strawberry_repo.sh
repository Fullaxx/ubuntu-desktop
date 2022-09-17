#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"

apt-get update
apt-get install -y gnupg2 software-properties-common

add-apt-repository -y ppa:jonaski/strawberry

apt-get update
apt-get install -y strawberry
