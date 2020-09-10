# ------------------------------------------------------------------------------
# https://www.cyberciti.biz/faq/install-and-configure-tigervnc-server-on-ubuntu-18-04/
# ------------------------------------------------------------------------------
# Pull base image
FROM ubuntu:focal
MAINTAINER Brett Kuskie <fullaxx@gmail.com>

# ------------------------------------------------------------------------------
# Set environment variables
ENV DEBIAN_FRONTEND noninteractive
ENV LANG C

# ------------------------------------------------------------------------------
# Install tigervnc,openbox and clean up
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      adwaita-icon-theme-full \
      ca-certificates \
      curl \
      dbus-x11 \
      fbpanel \
      hsetroot \
      locales \
      nano \
      sudo \
      tigervnc-common \
      tigervnc-standalone-server \
      tzdata \
      wget \
      x11-utils \
      x11-xserver-utils \
      xfce4 \
      xfce4-goodies \
      xfonts-base \
      xterm && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

# ------------------------------------------------------------------------------
# Configure the system
RUN sed -e 's/# en_US.UTF-8/en_US.UTF-8/' -i /etc/locale.gen && \
    locale-gen

# ------------------------------------------------------------------------------
# Install scripts and configuration files
COPY app/app.sh app/imagestart.sh app/tiger.sh /app/
COPY bin/set_wallpaper.sh /usr/bin/
COPY conf/xstartup /usr/share/ubuntu-desktop/vnc/
COPY conf/sudo /usr/share/ubuntu-desktop/sudo
COPY scripts/*.sh /app/scripts/

# ------------------------------------------------------------------------------
# Expose ports
EXPOSE 5901

# ------------------------------------------------------------------------------
# Define default command
CMD ["/app/app.sh"]
