#!/bin/bash

if [ -n "${USER}" ]; then
  chown -R ${USER}.${GROUP} ${HOME}
fi

# Start xrdp sesman service
rm -f /var/run/xrdp/xrdp-sesman.pid
/usr/sbin/xrdp-sesman

exec /usr/sbin/xrdp --nodaemon

################################################################################
# https://github.com/scottyhardy/docker-remote-desktop/blob/master/entrypoint.sh

# Create the user account
# groupadd --gid 1020 ubuntu
# useradd --shell /bin/bash --uid 1020 --gid 1020 --password $(openssl passwd ubuntu) --create-home --home-dir /home/ubuntu ubuntu

# Run xrdp in foreground if no commands specified
#if [ -z "$1" ]; then
#  /usr/sbin/xrdp --nodaemon
#else
#  /usr/sbin/xrdp
#  exec "$@"
#fi
