#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"

apt-get update
apt-get install -y gnupg2 software-properties-common apt-transport-https wget

# apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B44B85E3E1A6386BFC79D4119658E8044A3AA3D6
wget -q https://repo.vivaldi.com/stable/linux_signing_key.pub -O- | apt-key --keyring /etc/apt/trusted.gpg.d/vivaldi.gpg add -

# add-apt-repository "deb http://repo.vivaldi.com/stable/deb/ stable main"
echo "deb http://repo.vivaldi.com/stable/deb/ stable main" > /etc/apt/sources.list.d/vivaldi.list

apt-get update
apt-get install -y vivaldi-stable

# Something is happening in the background ...
COUNT="0"
echo "Waiting for /var/opt/vivaldi to populate ..."
while [ ! -d /var/opt/vivaldi/media-codecs-* ] && [ ${COUNT} -lt 70 ]; do
  echo -n "."; sleep 0.1; COUNT=$(( COUNT + 1 ))
done

# WTF, really?
echo
echo "Waiting just a little longer ..."
echo -n "."
sleep 1
echo -n "."
sleep 1
echo -n "."
sleep 1
rm /opt/vivaldi/lib/libffmpeg.so
