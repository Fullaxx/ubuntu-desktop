#!/bin/bash
# https://askubuntu.com/questions/26632/how-to-install-eclipse

set -e

bailmsg()
{
  xmessage "$1" &
  exit 1
}

# The different Eclipse Packages
# https://www.eclipse.org/downloads/packages/
ECLCPPPKG="https://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/2022-09/R/eclipse-cpp-2022-09-R-linux-gtk-x86_64.tar.gz"
ECLJAVAPKG="https://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/2022-09/R/eclipse-java-2022-09-R-linux-gtk-x86_64.tar.gz"
ECLPHPPKG="https://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/2022-09/R/eclipse-php-2022-09-R-linux-gtk-x86_64.tar.gz"

ECLJAVAVERS=${ECLJAVAVERS:-11}
ECLPKG=${ECLPKG:-CPP}
export DEBIAN_FRONTEND="noninteractive"

case "${ECLPKG}" in
   'CPP') ECLIPSEURL="${ECLCPPPKG}"+'&r=1'; EDIR="/opt/eclipse_cpp" ;;
  'JAVA') ECLIPSEURL="${ECLJAVAPKG}"+'&r=1'; EDIR="/opt/eclipse_java" ;;
   'PHP') ECLIPSEURL="${ECLPHPPKG}"+'&r=1'; EDIR="/opt/eclipse_php" ;;
       *) bailmsg "Eclipse ${ECLPKG} not supported!"
esac

# Install java
apt-get update
apt-get install -y openjdk-${ECLJAVAVERS}-jre-headless webkit2gtk-driver
if grep -q '^assistive_technologies' /etc/java-${ECLJAVAVERS}-openjdk/accessibility.properties; then
  sed -e 's/^assistive_technologies/#assistive_technologies/' -i /etc/java-${ECLJAVAVERS}-openjdk/accessibility.properties
fi

# Install Eclipse
cd /tmp/
wget ${ECLIPSEURL} -O - | tar xz
mv eclipse ${EDIR}
chown -R ${SUDO_UID}:${SUDO_GID} ${EDIR}
cp ${EDIR}/icon.xpm /usr/share/pixmaps/eclipse.xpm

if [ "${ECLPKG}" == "CPP" ]; then
ln -s ${EDIR}/eclipse /usr/local/bin/eclipse_cpp
echo '
[Desktop Entry]
Name=Eclipse CPP
Type=Application
Exec=env UBUNTU_MENUPROXY=0 eclipse_cpp
Terminal=false
Icon=eclipse
Comment=Integrated Development Environment
NoDisplay=false
Categories=Development;IDE;
Name[en]=Eclipse CPP
' | tee /usr/share/applications/eclipse_cpp.desktop
fi

if [ "${ECLPKG}" == "JAVA" ]; then
ln -s ${EDIR}/eclipse /usr/local/bin/eclipse_java
echo '
[Desktop Entry]
Name=Eclipse JAVA
Type=Application
Exec=env UBUNTU_MENUPROXY=0 eclipse_java
Terminal=false
Icon=eclipse
Comment=Integrated Development Environment
NoDisplay=false
Categories=Development;IDE;
Name[en]=Eclipse JAVA
' | tee /usr/share/applications/eclipse_java.desktop
fi

if [ "${ECLPKG}" == "PHP" ]; then
ln -s ${EDIR}/eclipse /usr/local/bin/eclipse_php
echo '
[Desktop Entry]
Name=Eclipse PHP
Type=Application
Exec=env UBUNTU_MENUPROXY=0 eclipse_php
Terminal=false
Icon=eclipse
Comment=Integrated Development Environment
NoDisplay=false
Categories=Development;IDE;
Name[en]=Eclipse PHP
' | tee /usr/share/applications/eclipse_php.desktop
fi
