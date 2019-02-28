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

# 
# tightvncserver xfonts-base

# ------------------------------------------------------------------------------
# Install base and clean up
RUN apt-get update && apt-get install -y --no-install-recommends \
tigervnc-standalone-server tigervnc-common xfonts-base \
locales openbox fbpanel xterm wget curl ca-certificates && \
mkdir -p /root/.vnc /root/.config/{openbox,fbpanel} /root/scripts && \
echo vncpass | vncpasswd -f > /root/.vnc/passwd && \
sed -e 's/# en_US.UTF-8/en_US.UTF-8/' -i /etc/locale.gen && locale-gen && \
apt-get clean && rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

# ------------------------------------------------------------------------------
# Install scripts and configuration
COPY app.sh /root/
COPY conf/xstartup /root/.vnc/
COPY conf/autostart /root/.config/openbox/
COPY conf/menu.xml /root/.config/openbox/
COPY conf/fbpaneldefault /root/.config/fbpanel/default
COPY scripts/firefox.sh /root/scripts/
COPY scripts/seamonkey.sh /root/scripts/
COPY scripts/chromium.sh /root/scripts/
COPY scripts/chrome.sh /root/scripts/
COPY scripts/vivaldi.sh /root/scripts/

# ------------------------------------------------------------------------------
# Expose ports
EXPOSE 5901

# ------------------------------------------------------------------------------
# Define default command
CMD ["/root/app.sh"]
