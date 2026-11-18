#!/bin/bash
# This script runs as root
#
# user.sh: set up the desktop user
# Sourced by app.sh after imagestart.sh (system services) and before tiger.sh (VNC server).
#
# Without VNCUSER/VNCUID the desktop runs as root (HOME=/root).
#
# With VNCUSER and VNCUID set, a non-root account is created:
#   VNCUSER   account name (required)
#   VNCUID    account UID (required)
#   VNCGROUP  primary group name (default: VNCUSER)
#   VNCGID    primary group GID (default: VNCUID)
#   ACCTPASS  optional password for the account (otherwise it stays locked)
# If VNCGROUP already exists its GID is used; if VNCGID already belongs to
# another group, that group is used. The account joins the sudo group
# (NOPASSWD rules in conf/sudo). USER, GROUP and HOME are exported for tiger.sh.
#
# For root or the account, VNCUMASK (optional) is appended once to ~/.bashrc.
#
# Known issue: this was written for ubuntu:22.04, which had no default user.
# Ubuntu 24.04+ images ship "ubuntu" (UID/GID 1000), so groupadd/useradd fail
# for it: VNCUSER=ubuntu silently reuses that account whatever VNCUID says,
# and another name with VNCUID=1000 can't be created (HOME ends up empty and
# the container exits). Also, the VNCGID check only finds groups without members.

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
# (only append it once: the container may be restarted and $HOME may persist)
if [ -n "${VNCUMASK}" ]; then
  if ! grep -qx "umask ${VNCUMASK}" ${HOME}/.bashrc 2>/dev/null; then
    echo >> ${HOME}/.bashrc
    echo "umask ${VNCUMASK}" >> ${HOME}/.bashrc
  fi
fi
