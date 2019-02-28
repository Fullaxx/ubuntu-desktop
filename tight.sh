#!/bin/bash

VNCDIR="/root/.vnc"
VNCRES="-geometry 1280x800"
VNCDEPTH="-depth 24"

chmod 0600 ${VNCDIR}/passwd

USER="root" HOME="/root" vncserver :1 ${VNCRES} ${VNCDEPTH} && \
tail -F /root/.vnc/*.log
