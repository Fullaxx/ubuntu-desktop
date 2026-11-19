# ------------------------------------------------------------------------------
# Base Image : Ubuntu 24.04 LTS (Noble Numbat)
# Support    : Apr 2024 - May 2029
FROM ubuntu:24.04
LABEL author="Brett Kuskie <fullaxx@gmail.com>"

# ------------------------------------------------------------------------------
# Set environment variables
ENV DEBIAN_FRONTEND="noninteractive"
ENV WINDOWMANAGER="openbox"
ENV FBPANELDIST="noble"
ENV FBPANELVERS="8.5.2"

# ------------------------------------------------------------------------------
# Keep translations
# (the Ubuntu base image's dpkg excludes leave out every package's translations; without that line,
# the packages installed below and by the launcher scripts keep theirs, and their messages follow
# the desktop's locale)
RUN sed -e '\#^path-exclude=/usr/share/locale/#d' -i /etc/dpkg/dpkg.cfg.d/excludes

# ------------------------------------------------------------------------------
# Install tigervnc,openbox and clean up
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      bzip2 \
      ca-certificates \
      curl \
      dbus \
      dbus-x11 \
      gnome-icon-theme \
      hsetroot \
      less \
      libasound2t64 \
      libgtk2.0-0t64 \
      locales \
      nano \
      obconf \
      openbox \
      python3-xdg \
      sudo \
      tigervnc-common \
      tigervnc-standalone-server \
      tigervnc-tools \
      tzdata \
      wget \
      x11-utils \
      x11-xserver-utils \
      xfonts-base \
      xterm \
      xz-utils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

# ------------------------------------------------------------------------------
# Install fbpanel and clean up
RUN wget https://github.com/Fullaxx/fbpanel/releases/download/v${FBPANELVERS}/fbpanel_${FBPANELVERS}_amd64_${FBPANELDIST}.deb -O /tmp/fbpanel.deb && \
    dpkg -i /tmp/fbpanel.deb && \
    rm /tmp/fbpanel.deb

# ------------------------------------------------------------------------------
# Configure locale
# (en_US is the image's default: at startup, app/locale.sh switches to docker run's -e LOCALE, or else -e LANG)
RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment && \
    echo "LANG=en_US.UTF-8" > /etc/locale.conf && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
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
COPY app/*.sh /app/
COPY bin/set_wallpaper.sh /usr/bin/
COPY conf/xstartup /usr/share/ubuntu-desktop/vnc/
COPY conf/autostart conf/menu.xml /usr/share/ubuntu-desktop/openbox/
COPY conf/sudo /usr/share/ubuntu-desktop/sudo
COPY conf/bash.colors conf/color_prompt.sh /opt/bash/
COPY scripts/*.sh /app/scripts/

# ------------------------------------------------------------------------------
# Expose ports
EXPOSE 5901

# ------------------------------------------------------------------------------
# Define default command
CMD ["/app/app.sh"]
