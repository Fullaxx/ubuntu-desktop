#!/bin/bash

set -e

NBVERS="16"
NBFILE="netbeans-${NBVERS}-bin.zip"
NBJAVAVERS=${NBJAVAVERS:-11}
DEBIAN_FRONTEND="noninteractive"
URL="https://dlcdn.apache.org/netbeans/netbeans/${NBVERS}/${NBFILE}"

# Install java,unzip
apt-get update
apt-get install -y --no-install-recommends openjdk-${NBJAVAVERS}-jre unzip
if grep -q '^assistive_technologies' /etc/java-${NBJAVAVERS}-openjdk/accessibility.properties; then
  sed -e 's/^assistive_technologies/#assistive_technologies/' -i /etc/java-${NBJAVAVERS}-openjdk/accessibility.properties
fi

# Download NetBeans
cd /tmp/
wget ${URL}
wget ${URL}.sha512
cat ${NBFILE}.sha512 | sha512sum -c
rm ${NBFILE}.sha512

# Install NetBeans
cd /opt/
unzip /tmp/${NBFILE}
rm /tmp/${NBFILE}
