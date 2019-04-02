#!/bin/bash
# https://sourceforge.net/p/ubuntuzilla/wiki/Main_Page/

export DEBIAN_FRONTEND="noninteractive"
BINARY="seamonkey"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  set -e

  xterm -T AptGetUpdate -g 100x30 -e apt-get update
  xterm -T AptGetInstall -g 100x30 -e apt-get install -y gnupg2

#  https://askubuntu.com/questions/1081382/how-can-i-install-seamonkey-on-ubuntu-18-04-lts
#  echo "deb http://downloads.sourceforge.net/project/ubuntuzilla/mozilla/apt all main" > /etc/apt/sources.list.d/mozilla.list
#  apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 2667CA5C

# http://linuxg.net/how-to-install-seamonkey-2-49-4-on-ubuntu-18-10-ubuntu-18-04-and-derivative-systems/
  echo >> /etc/apt/sources.list
  echo "deb http://downloads.sourceforge.net/project/ubuntuzilla/mozilla/apt all main" >> /etc/apt/sources.list
  apt-key adv --recv-keys --keyserver keyserver.ubuntu.com C1289A29

  xterm -T AptGetUpdate -g 100x30 -e apt-get update
  xterm -T AptGetInstall -g 100x30 -e apt-get install seamonkey-mozilla-build
fi

${BINARY}
