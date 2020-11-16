#!/bin/bash

# sudo configuration for ubuntu-desktop
install -m 0440 /usr/share/ubuntu-desktop/sudo /etc/sudoers.d/ubuntudesktop

# Delete old temp files in case the images was restarted
# test case: docker restart ubuntu-desktop
rm -f /tmp/.X*-lock
rm -f /tmp/.X11-unix/*

# Necessary for many applications
# (i.e. Chrome, terminator, ktorrent, ...)
/etc/init.d/x11-common start
/etc/init.d/dbus start

if [ -n "${VNCUSER}" ] && [ -n "${VNCUID}" ]; then
# if VNCGROUP/VNCGID is unset, set it to VNCUSER/VNCUID
  VNCGROUP=${VNCGROUP:-$VNCUSER}
  VNCGID=${VNCGID:-$VNCUID}
# If the GROUP already exists, use the existing GID (Thanks to elisionducoeur)
  if grep -q "^${VNCGROUP}:x:" /etc/group; then
    VNCGID=`grep "^${VNCGROUP}:x:" /etc/group | cut -d: -f3`
  fi
# If the GID exists, but the GROUP is incorrect
  if grep -q ":x:${VNCGID}:$" /etc/group; then
    if ! grep -q "^${VNCGROUP}:x:${VNCGID}:$" /etc/group; then
      VNCGROUP=`grep ":x:${VNCGID}:$" /etc/group | cut -d: -f1`
    fi
  fi
  groupadd -g ${VNCGID} ${VNCGROUP}
  useradd -u ${VNCUID} -g ${VNCGID} -G sudo -s /bin/bash -m -d /home/${VNCUSER} ${VNCUSER}

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

# $HOME should always be set at this point
# Set umask in all future bash shell instances
if [ -n "${VNCUMASK}" ]; then
  echo >> ${HOME}/.bashrc
  echo "umask ${VNCUMASK}" >> ${HOME}/.bashrc
fi

mkdir -p ${HOME}/.vnc ${HOME}/.config/{openbox,fbpanel}
install -m 0755 /usr/share/ubuntu-desktop/vnc/xstartup ${HOME}/.vnc/xstartup
install -m 0755 /usr/share/ubuntu-desktop/openbox/autostart ${HOME}/.config/openbox/autostart
install -m 0644 /usr/share/ubuntu-desktop/openbox/menu.xml ${HOME}/.config/openbox/menu.xml
install -m 0644 /usr/share/ubuntu-desktop/openbox/rc.xml ${HOME}/.config/openbox/rc.xml
install -m 0644 /usr/share/ubuntu-desktop/fbpanel/default ${HOME}/.config/fbpanel/default
