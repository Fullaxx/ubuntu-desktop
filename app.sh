#!/bin/bash

VNCDIR="/root/.vnc"

chmod 0600 ${VNCDIR}/passwd

tigervncserver -geometry 1280x800 -depth 24 -xstartup ${VNCDIR}/xstartup && \
tail -F /root/.vnc/*.log

# tightvncserver
# USER="root" HOME="/root" vncserver :1 -geometry 1280x800 -depth 24 && tail -F /root/.vnc/*.log
