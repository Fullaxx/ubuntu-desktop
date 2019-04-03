#!/bin/bash

# sudo configuration for ubuntu-desktop
install -m 0440 /usr/share/ubuntu-desktop/sudo /etc/sudoers.d/ubuntudesktop

# Necessary for many applications
# (i.e. Chrome, terminator, ktorrent, ...)
/etc/init.d/x11-common start
/etc/init.d/dbus start

if [ -n "${VNCUSER}" ] && [ -n "${VNCUID}" ]; then
  useradd -u ${VNCUID} -G sudo -s /bin/bash -m -d /home/${VNCUSER} ${VNCUSER}
  export USER="${VNCUSER}"
  if [ -n "${ACCTPASS}" ]; then
    echo "${VNCUSER}:${ACCTPASS}" | chpasswd
    unset ACCTPASS
  fi
fi

if [ -n "${USER}" ]; then
  export HOME=`getent passwd ${USER} | cut -d: -f6`
fi

mkdir -p ${HOME}/.vnc ${HOME}/.config/{openbox,fbpanel}
install -m 0755 /usr/share/ubuntu-desktop/vnc/xstartup ${HOME}/.vnc/xstartup
install -m 0755 /usr/share/ubuntu-desktop/openbox/autostart ${HOME}/.config/openbox/autostart
install -m 0644 /usr/share/ubuntu-desktop/openbox/menu.xml ${HOME}/.config/openbox/menu.xml
install -m 0644 /usr/share/ubuntu-desktop/fbpanel/default ${HOME}/.config/fbpanel/default
