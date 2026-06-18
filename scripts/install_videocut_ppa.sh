#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"

apt-get update
apt-get install -y gnupg2 software-properties-common

add-apt-repository -y ppa:jentiger-moratai/mediatools

apt-get update
apt-get install -y videocut
