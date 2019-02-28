#!/bin/bash

VNCDIR="/root/.vnc"
VNCRES="-geometry 1280x800"
VNCDEPTH="-depth 24"

chmod 0600 ${VNCDIR}/passwd

tigervncserver -fg ${VNCRES} ${VNCDEPTH} -xstartup ${VNCDIR}/xstartup
