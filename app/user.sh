#!/bin/bash
# This script runs as root
#
# user.sh: set up the desktop user
# Sourced by app.sh after imagestart.sh (system services) and before tiger.sh (VNC server).
#
# Without VNCUSERMAP the desktop runs as root (HOME=/root).
#
# Variables:
#   VNCUSERMAP   the account as name/uid, e.g. guest/1001 (enables the non-root desktop)
#   VNCGROUPMAP  its primary group as name/gid, e.g. guests/1002 (default: same as VNCUSERMAP)
#   ACCTPASS     optional password for the account (otherwise it stays locked)
#   VNCUMASK     optional umask, appended once to ~/.bashrc (root or the account)
# These replace VNCUSER/VNCUID/VNCGROUP/VNCGID. An old setup without VNCUSERMAP
# runs as root, and a notice explains what to change: in docker logs, and in the
# desktop (xstartup shows /tmp/ubuntu-desktop-notice.txt with xmessage).
# With VNCUSERMAP set, the old variables are ignored.
#
# Why there are two paths:
# These scripts were written for ubuntu:22.04, which had no default user.
# Ubuntu 24.04 and later images ship a user named "ubuntu" (UID/GID 1000),
# and the old example VNCUSER=guest VNCUID=1000 collided with it.
# Users and groups are never renamed or deleted; each one either exists or is created:
#
# 1) The user already exists: the built-in "ubuntu", or the account that a
#    previous start of this container created (docker restart).
#    It is used as is: its UID and primary group must match the maps,
#    e.g. VNCUSERMAP=ubuntu/1000. A mismatch stops the container.
#
# 2) Any other name: a new account and a new primary group are created,
#    e.g. VNCUSERMAP=guest/1001 (group guest/1001) or with VNCGROUPMAP=guests/1002.
#    The UID and the GID must both be free and above 1000, and the group
#    name must not exist yet.
#    The account joins sudo (NOPASSWD rules in conf/sudo), audio (--device /dev/snd)
#    and video (/dev/dri), like the built-in "ubuntu" account.
#
# Errors print the reason (see docker logs) and stop the container (exit 1).
#
# For a non-root account, USER, GROUP and HOME are exported for the later stages
# (wm.sh, prepare.sh, tiger.sh).

# Startup notice for the desktop: xstartup shows this file with xmessage
NOTICE=/tmp/ubuntu-desktop-notice.txt
rm -f "${NOTICE}"
# The old variables were replaced by VNCUSERMAP/VNCGROUPMAP
if [ -n "${VNCUSER}${VNCUID}${VNCGROUP}${VNCGID}" ]; then
  if [ -z "${VNCUSERMAP}" ]; then
    cat > "${NOTICE}" <<'EOF'
This container was started with VNCUSER/VNCUID (VNCGROUP/VNCGID),
which were replaced by VNCUSERMAP=name/uid and VNCGROUPMAP=name/gid.
The desktop is running as root instead.
Recreate the container with:
-e VNCUSERMAP=guest/1001 (see README.md).
EOF
    cat "${NOTICE}" >&2
  else
    echo "NOTE: VNCUSER/VNCUID/VNCGROUP/VNCGID are ignored, VNCUSERMAP/VNCGROUPMAP are used" >&2
  fi
fi

if [ -n "${VNCUSERMAP}" ]; then
  VNCGROUPMAP=${VNCGROUPMAP:-$VNCUSERMAP}
# Both maps are name/number
  for MAP in "${VNCUSERMAP}" "${VNCGROUPMAP}"; do
    if ! [[ "${MAP}" =~ ^[^/]+/[0-9]+$ ]]; then
      echo "ERROR: ${MAP} is not name/number (e.g. guest/1001)" >&2
      exit 1
    fi
  done
  VNCUSER=${VNCUSERMAP%/*};   VNCUID=${VNCUSERMAP#*/}
  VNCGROUP=${VNCGROUPMAP%/*}; VNCGID=${VNCGROUPMAP#*/}

  if getent passwd "${VNCUSER}" >/dev/null; then
# 1) Use the existing account as is: the maps must match it
    if [ "$(id -u "${VNCUSER}")" != "${VNCUID}" ] || [ "$(id -gn "${VNCUSER}")" != "${VNCGROUP}" ] || [ "$(id -g "${VNCUSER}")" != "${VNCGID}" ]; then
      echo "ERROR: ${VNCUSER} already exists as ${VNCUSER}/$(id -u "${VNCUSER}") with group $(id -gn "${VNCUSER}")/$(id -g "${VNCUSER}")," >&2
      echo "ERROR: but VNCUSERMAP/VNCGROUPMAP ask for ${VNCUSERMAP} with group ${VNCGROUPMAP}" >&2
      exit 1
    fi
  else
# 2) Create a new account and group: free IDs above 1000, an unused group name
    if [ "${VNCUID}" -le 1000 ] || getent passwd "${VNCUID}" >/dev/null; then
      echo "ERROR: UID ${VNCUID} can't be used for a new account (${VNCUSER})," >&2
      echo "ERROR: choose a free UID above 1000, or use VNCUSERMAP=ubuntu/1000" >&2
      exit 1
    fi
    if [ "${VNCGID}" -le 1000 ] || getent group "${VNCGID}" >/dev/null || getent group "${VNCGROUP}" >/dev/null; then
      echo "ERROR: group ${VNCGROUPMAP} can't be created for ${VNCUSER}," >&2
      echo "ERROR: choose an unused group name with a free GID above 1000" >&2
      exit 1
    fi
    groupadd -g "${VNCGID}" "${VNCGROUP}" || exit 1
    useradd -u "${VNCUID}" -g "${VNCGID}" -G sudo,audio,video -s /bin/bash -m -d "/home/${VNCUSER}" "${VNCUSER}" || exit 1
  fi

  export USER="${VNCUSER}"
  export GROUP="${VNCGROUP}"
  if [ -n "${ACCTPASS}" ]; then
    echo "${VNCUSER}:${ACCTPASS}" | chpasswd
    unset ACCTPASS
  fi
fi

if [ -n "${USER}" ]; then
  HOME=$(getent passwd "${USER}" | cut -d: -f6)
  export HOME
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
