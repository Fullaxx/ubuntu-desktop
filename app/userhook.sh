#!/bin/bash
# This script runs as root
# User hook: an empty place for your own startup commands, in your copy of the image or container.
# app/app.sh sources it at every start (docker restart too), after the desktop user's account,
# HOME and the VNC server's files are ready, and just before app/tiger.sh starts the VNC server.
#
# To use it, put your commands in /app/userhook.sh:
#   - in your own image: a Dockerfile FROM this image, with COPY userhook.sh /app/userhook.sh
#   - in a container: edit /app/userhook.sh, then docker restart the container
#   - at docker run: -v /path/to/userhook.sh:/app/userhook.sh:ro
#
# It runs in app/app.sh's shell, as root:
#   - it sees the variables set before it: docker run's -e variables, VNCRES, VNCDEPTH, VNCPORT
#     and VNCDIR, and USER, GROUP and HOME for a non-root desktop user. app/tiger.sh starts the
#     VNC server with VNCRES, VNCDEPTH and VNCPORT as they are after this file
#   - exit here stops the container, and a command that doesn't return keeps the VNC server from
#     starting: start long-running programs in the background (&)
#   - HOME already belongs to the desktop user: files you create there as root stay root's unless
#     you chown them, or run the command as that user (sudo -u "${USER}" for a non-root user)
#   - its output goes to docker logs, and a command that fails doesn't stop the start
#   - it runs again at every start, so its commands should be safe to repeat
