#!/bin/bash

# sudo configuration for ubuntu-desktop
install -m 0440 /usr/share/ubuntu-desktop/sudo /etc/sudoers.d/ubuntudesktop

# Delete old temp files in case the images was restarted
rm -f /tmp/.X*-lock
rm -f /tmp/.X11-unix/*

# Necessary for many applications
# (i.e. Chrome, terminator, ktorrent, ...)
/etc/init.d/x11-common start
/etc/init.d/dbus start

if [ -n "${VNCUSER}" ] && [ -n "${VNCUID}" ]; then
  # Check if VNCGROUP and VNCGID are set or set to VNCUSER and VNCUID
  if [ -z "${VNCGROUP}" ]; then
    VNCGROUP=${VNCUSER}
  fi
  if [ -z "${VNCGID}" ]; then
    VNCGID=${VNCUID}
  fi
  groupadd -g ${VNCGID} ${VNCGROUP}
  useradd -u ${VNCUID} -g ${VNCGID} -G sudo -s /bin/bash -m -d /home/${VNCUSER} ${VNCUSER}

  if [ -n ${VNCUMASK} ]; then
    # add umask command to .bashrc
    echo "umask ${VNCUMASK}" >> /home/${VNCUSER}/.bashrc
    # add umask command at line 9 in autostart
    sed "9iumask ${VNCUMASK}" /usr/share/ubuntu-desktop/openbox/autostart > /tmp/autostart
    cp /tmp/autostart /usr/share/ubuntu-desktop/openbox/autostart
  fi
  export USER="${VNCUSER}"
  export GROUP="${VNCGROUP}"
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
