#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"
export BBTINSTSCR="/tmp/BiglyBT_Installer.sh"

if [ "$1" == "NOQUIET" ]; then
  unset BBTAUTOINST
else
  export BBTAUTOINST="-q"
fi

apt-get update
apt-get install -y --no-install-recommends openjdk-11-jre-headless webkit2gtk-driver
if grep -q '^assistive_technologies' /etc/java-11-openjdk/accessibility.properties; then
  sed -e 's/^assistive_technologies/#assistive_technologies/' -i /etc/java-11-openjdk/accessibility.properties
fi

chown ${SUDO_UID}.${SUDO_GID} /opt
wget -q https://files.biglybt.com/installer/BiglyBT_Installer.sh -O ${BBTINSTSCR}
chmod +x ${BBTINSTSCR}
sudo -u ${SUDO_USER} app_java_home="/usr/lib/jvm/java-11-openjdk-amd64/" ${BBTINSTSCR} ${BBTAUTOINST} -dir /opt/biglybt
rm ${BBTINSTSCR}
chown -R ${SUDO_UID}.${SUDO_GID} /opt/biglybt
