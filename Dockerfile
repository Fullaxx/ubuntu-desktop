# ------------------------------------------------------------------------------
# https://www.cyberciti.biz/faq/install-and-configure-tigervnc-server-on-ubuntu-18-04/
# ------------------------------------------------------------------------------
# Pull base image
FROM ubuntu:bionic
MAINTAINER Brett Kuskie <fullaxx@gmail.com>

# ------------------------------------------------------------------------------
# Set environment variables
ENV DEBIAN_FRONTEND noninteractive
ENV LANG C

# ------------------------------------------------------------------------------
# Install tigervnc and clean up
RUN apt-get update && apt-get install -y --no-install-recommends \
tigervnc-standalone-server tigervnc-common \
xfonts-base x11-utils x11-xserver-utils dbus-x11 \
locales openbox fbpanel xterm wget curl ca-certificates && \
sed -e 's/# en_US.UTF-8/en_US.UTF-8/' -i /etc/locale.gen && locale-gen && \
apt-get clean && rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

# ------------------------------------------------------------------------------
# Install scripts and configuration files
COPY tiger.sh tight.sh /app/
COPY scripts/*.sh /app/scripts/
COPY conf/xstartup /root/.vnc/
COPY conf/autostart conf/menu.xml /root/.config/openbox/
COPY conf/fbpaneldefault /root/.config/fbpanel/default

# ------------------------------------------------------------------------------
# Expose ports
EXPOSE 5901

# ------------------------------------------------------------------------------
# Define default command
CMD ["/app/tiger.sh"]
