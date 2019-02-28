#!/bin/bash

VNCDIR="/root/.vnc"
VNCRES="-geometry 1280x800"
VNCDEPTH="-depth 24"

chmod 0600 ${VNCDIR}/passwd

tigervncserver -fg ${VNCRES} ${VNCDEPTH} -xstartup ${VNCDIR}/xstartup

# tightvncserver
# USER="root" HOME="/root" vncserver :1 -geometry 1280x800 -depth 24 && tail -F /root/.vnc/*.log
