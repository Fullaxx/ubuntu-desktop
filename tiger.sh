#!/bin/bash

# sudo configuration for ubuntu-desktop
install -m 0440 /usr/share/ubuntu-desktop/sudo /etc/sudoers.d/ubuntudesktop

# Necessary for many applications
# (i.e. Chrome, terminator, ktorrent, ...)
/etc/init.d/x11-common start
/etc/init.d/dbus start

if [ -n "${VNCUSER}" ] && [ -n "${VNCUID}" ]; then
  useradd -u ${VNCUID} -G sudo -s /bin/bash -m -d /home/${VNCUSER} ${VNCUSER}
  USER="${VNCUSER}"
  if [ -n "${ACCTPASS}" ]; then
    echo "${VNCUSER}:${ACCTPASS}" | chpasswd
    unset ACCTPASS
  fi
fi

if [ -n "${USER}" ]; then
  HOME=`getent passwd ${USER} | cut -d: -f6`
fi

mkdir -p ${HOME}/.vnc ${HOME}/.config/{openbox,fbpanel}
install -m 0755 /usr/share/ubuntu-desktop/vnc/xstartup ${HOME}/.vnc/xstartup
install -m 0755 /usr/share/ubuntu-desktop/openbox/autostart ${HOME}/.config/openbox/autostart
install -m 0644 /usr/share/ubuntu-desktop/openbox/menu.xml ${HOME}/.config/openbox/menu.xml
install -m 0644 /usr/share/ubuntu-desktop/fbpanel/default ${HOME}/.config/fbpanel/default

VNCDIR="${HOME}/.vnc"
VNCAUTH="-SecurityTypes=None --I-KNOW-THIS-IS-INSECURE"
VNCRES=${VNCRES:-1280x800}
VNCDEPTH=${VNCDEPTH:-24}
VNCSTART="${VNCDIR}/xstartup"

# If a password was specified on the command line
if [ -n "${VNCPASS}" ]; then
  echo "${VNCPASS}" | vncpasswd -f > ${VNCDIR}/passwd
  if [ -n "${VNCPASSRO}" ]; then
    echo -e "${VNCPASS}\n${VNCPASS}\ny\n${VNCPASSRO}\n${VNCPASSRO}\n" | vncpasswd
  fi
  chmod 0600 ${VNCDIR}/passwd
  VNCAUTH=""
fi

if [ -n "${USER}" ]; then
  chown -R ${USER}.${USER} ${HOME}
  SUDOUSEROPTION="-u ${USER}"
fi

# -fg will allow the openbox exit button to bring us down
# using sudo here will allow 'docker stop' to bring us down quickly
exec sudo ${SUDOUSEROPTION} tigervncserver -fg -localhost no \
${VNCAUTH} -geometry ${VNCRES} -depth ${VNCDEPTH} -xstartup ${VNCSTART}
