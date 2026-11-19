#!/bin/bash
# This script runs as root
# Timezone, from TZ (Asia/Tokyo, Europe/London, ...). The variable alone already reaches the desktop
# session (sudo keeps it) and docker exec shells; /etc/localtime follows it too, for programs that
# read the file instead. Without TZ the container stays on UTC.
if [ -n "${TZ}" ]; then
  # glibc allows a leading colon (TZ=:Asia/Tokyo)
  TZFILE="/usr/share/zoneinfo/${TZ#:}"
  # a zone is a compiled TZif file; ".." would leave the zoneinfo tree
  if [ "${TZ#*..}" = "${TZ}" ] && [ "$(head -c 4 "${TZFILE}" 2>/dev/null)" = "TZif" ]; then
    ln -sf "${TZFILE}" /etc/localtime
    # Ubuntu 24.04 still has /etc/timezone, which some programs read instead (26.04's tzdata dropped it)
    if [ -f /etc/timezone ]; then echo "${TZ#:}" > /etc/timezone; fi
  else
    echo "TZ='${TZ}' is not a timezone in /usr/share/zoneinfo; /etc/localtime stays UTC" >&2
  fi
fi
