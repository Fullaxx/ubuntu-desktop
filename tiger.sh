#!/bin/bash

VNCDIR="/root/.vnc"
VNCAUTH="-SecurityTypes=None --I-KNOW-THIS-IS-INSECURE"
VNCRES="-geometry 1280x800"
VNCDEPTH="-depth 24"
VNCSTART="-xstartup ${VNCDIR}/xstartup"

# chmod 0600 ${VNCDIR}/passwd

tigervncserver -fg -localhost no ${VNCAUTH} ${VNCRES} ${VNCDEPTH} ${VNCSTART}
