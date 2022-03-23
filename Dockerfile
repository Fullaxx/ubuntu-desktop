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
      ca-certificates \
      curl \
      dbus-x11 \
      fbpanel \
      hsetroot \
      locales \
      nano \
      openbox \
      sudo \
      tigervnc-common \
      tigervnc-standalone-server \
      tzdata \
      wget \
      x11-utils \
      x11-xserver-utils \
      xfonts-base \
      xterm && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

# ------------------------------------------------------------------------------
# Configure locale
RUN sed -e 's/# en_US.UTF-8/en_US.UTF-8/' -i /etc/locale.gen && \
    locale-gen

# ------------------------------------------------------------------------------
# Configure XTerm
RUN sed -e 's/saveLines: 1024/saveLines: 8192/' -i /etc/X11/app-defaults/XTerm

# ------------------------------------------------------------------------------
# Configure openbox
RUN mkdir -p /usr/share/ubuntu-desktop/openbox && \
    cat /etc/xdg/openbox/rc.xml \
      | sed -e 's@<number>4</number>@<number>8</number>@' \
      > /usr/share/ubuntu-desktop/openbox/rc.xml

# ------------------------------------------------------------------------------
# Install scripts and configuration files
COPY app/app.sh app/imagestart.sh app/tiger.sh /app/
COPY bin/set_wallpaper.sh /usr/bin/
COPY conf/xstartup /usr/share/ubuntu-desktop/vnc/
COPY conf/autostart conf/menu.xml /usr/share/ubuntu-desktop/openbox/
COPY conf/fbpaneldefault /usr/share/ubuntu-desktop/fbpanel/default
COPY conf/sudo /usr/share/ubuntu-desktop/sudo
COPY scripts/*.sh /app/scripts/

# ------------------------------------------------------------------------------
# Expose ports
EXPOSE 5901

# ------------------------------------------------------------------------------
# Define default command
CMD ["/app/app.sh"]
