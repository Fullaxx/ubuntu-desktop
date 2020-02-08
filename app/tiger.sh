#!/bin/bash

VNCDIR="${HOME}/.vnc"
VNCAUTH="-SecurityTypes=None --I-KNOW-THIS-IS-INSECURE"
VNCRES=${VNCRES:-1280x800}
VNCDEPTH=${VNCDEPTH:-24}
VNCSTART="${VNCDIR}/xstartup"
VNCPORT=${VNCPORT:-1}

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
  chown -R ${USER}.${GROUP} ${HOME}
  SUDOUSEROPT="-u ${USER}"
fi

# -fg will allow the openbox exit button to bring us down
# using sudo here will allow 'docker stop' to bring us down quickly
exec sudo ${SUDOUSEROPT} tigervncserver :${VNCPORT} -fg -localhost no \
${VNCAUTH} -geometry ${VNCRES} -depth ${VNCDEPTH} -xstartup ${VNCSTART}
