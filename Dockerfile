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

# Alternative to tigervnc-standalone-server tigervnc-common
# tightvncserver

# ------------------------------------------------------------------------------
# Install tigervnc and clean up
RUN apt-get update && apt-get install -y --no-install-recommends \
tigervnc-standalone-server tigervnc-common xfonts-base x11-utils \
locales openbox fbpanel xterm wget curl ca-certificates && \
sed -e 's/# en_US.UTF-8/en_US.UTF-8/' -i /etc/locale.gen && locale-gen && \
apt-get clean && rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

# ------------------------------------------------------------------------------
# Create directories and configure VNC
RUN mkdir -p /root/.vnc /root/.config/{openbox,fbpanel} /root/scripts && \
echo vncpass | vncpasswd -f > /root/.vnc/passwd

# ------------------------------------------------------------------------------
# Install scripts and configuration files
COPY tiger.sh tight.sh /root/
COPY conf/xstartup /root/.vnc/
COPY conf/autostart conf/menu.xml /root/.config/openbox/
COPY conf/fbpaneldefault /root/.config/fbpanel/default
COPY scripts/*.sh /root/scripts/

# ------------------------------------------------------------------------------
# Expose ports
EXPOSE 5901

# ------------------------------------------------------------------------------
# Define default command
CMD ["/root/tiger.sh"]
