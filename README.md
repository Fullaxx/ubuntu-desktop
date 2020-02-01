# Ubuntu 18.04 (Bionic) Desktop running Openbox in VNC

## Base Docker Image
[Ubuntu](https://hub.docker.com/_/ubuntu) 18.04 (x64)

## Get the image from Docker Hub
```
docker pull fullaxx/ubuntu-desktop
```

## VNC Options
Optional: Set Depth 16 \
Default: 24
```
-e VNCDEPTH='16'
```
Optional: Set 1920x1080 Resolution \
Default: 1280x800
```
-e VNCRES='1920x1080'
```
Optional: Set Password Authentication \
Default: No Authentication
```
-e VNCPASS='vncpass'
```
Optional: Set Read-Write and Read-Only password \
Default: No Authentication
```
-e VNCPASS='vncpass' -e VNCPASSRO='readonly'
```
Optional: Run as a non-root user \
Default: root (UID: 0)
```
-e VNCUSER='guest' -e VNCUID='1000'
```
Optional: Set a custom group for non-root user \
Default: same as VNCUSER and VNCUID
```
-e VNCGROUP='guests' -e VNCGID='1001'
```
Optional: Set umask to define permission for new files \
Default: 0022
```
-e VNCUMASK='0002'
```

## TimeZone Configuration
Set the timezone to be used inside the container \
Default: UTC
```
-e TZ='Asia/Tokyo'
-e TZ='Europe/London'
-e TZ='America/Los_Angeles'
-e TZ='America/Denver'
-e TZ='America/Chicago'
-e TZ='America/New_York'
```

## Wallpaper Configuration
Set a background image for the openbox desktop \
Default: None \
Image Links:
[1](https://digitalblasphemy.com/graphics/HDfree/moonbeamsea1HDfree.jpg) /
[2](https://digitalblasphemy.com/graphics/HDfree/ringoffirenight2k153HDfree.jpg) /
[3](https://digitalblasphemy.com/graphics/HDfree/moonshadow1HDfree.jpg) /
[4](https://digitalblasphemy.com/graphics/HDfree/portals1HDfree.jpg) /
[5](https://digitalblasphemy.com/graphics/HDfree/acumen1HDfree.jpg) /
[6](https://digitalblasphemy.com/graphics/HDfree/threemoonbayday1HDfree.jpg) \
Layout Options: fill / extend / full / tile / cover / center \
Default Layout: center
```
-e WALLPAPER='1'
-e WALLPAPER='3'
-e WALLPAPER='4' -e WPLAYOUT='cover'
```

## FUSE Configuration (to support AppImages)
Set privileges to allow FUSE to work properly inside the container
```
--device /dev/fuse --cap-add SYS_ADMIN
```

## Shared Memory Modification (to support Web Browsers)
Increase the size of shared memory to prevent web browsers from crashing \
Thanks to [jlesage](https://hub.docker.com/r/jlesage/firefox/#increasing-shared-memory-size)
```
--shm-size 2g
```

## Run the image
Run the image on localhost port 5901 with default configuration
```
docker run -d -p 127.0.0.1:5901:5901 fullaxx/ubuntu-desktop
```
Run the image with Depth 16
```
docker run -d -p 127.0.0.1:5901:5901 -e VNCDEPTH='16' fullaxx/ubuntu-desktop
```
Run the image with 1920x1080 Resolution
```
docker run -d -p 127.0.0.1:5901:5901 -e VNCRES='1920x1080' fullaxx/ubuntu-desktop
```
Run the image with Password Authentication
```
docker run -d -p 127.0.0.1:5901:5901 -e VNCPASS='vncpass' fullaxx/ubuntu-desktop
```
Run the image with Read-Write and Read-Only password (Using R/O pass requires R/W pass)
```
docker run -d -p 127.0.0.1:5901:5901 -e VNCPASS='vncpass' -e VNCPASSRO='readonly' fullaxx/ubuntu-desktop
```
Run the image as a non-root user account
```
docker run -d -p 127.0.0.1:5901:5901 -e VNCUSER='guest' -e VNCUID='1000' fullaxx/ubuntu-desktop
```
Run the image as a non-root user account with custom group
```
docker run -d -p 127.0.0.1:5901:5901 -e VNCUSER='guest' -e VNCUID='1000' -e VNCGROUP='guests' -e VNCGID='1001' fullaxx/ubuntu-desktop
```
Run the image in Tokyo
```
docker run -d -p 127.0.0.1:5901:5901 -e TZ='Asia/Tokyo' fullaxx/ubuntu-desktop
```
Run the image with FUSE privileges
```
docker run --device /dev/fuse --cap-add SYS_ADMIN -d -p 127.0.0.1:5901:5901 fullaxx/ubuntu-desktop
```

## Connect using vncviewer
```
vncviewer 127.0.0.1:5901
```

## Using the Openbox Desktop Environment
Right-Click to activate the Openbox menu system. You will find a number of convenience scripts for running applications.

Terminals:
* [xterm](https://invisible-island.net/xterm/), uxterm, [terminology](https://www.enlightenment.org/about-terminology.md), terminator, [tilix](https://gnunn1.github.io/tilix-web/), [tilda](https://github.com/lanoxx/tilda), [archipelago (AI)](https://github.com/npezza93/archipelago), [hyper (AI)](https://github.com/zeit/hyper), [powershell](https://github.com/PowerShell/PowerShell)

Browsers:
* [chrome](https://www.google.com/chrome/), [chromium](https://www.chromium.org/), [firefox](https://www.mozilla.org/en-US/firefox/), [vivaldi](https://vivaldi.com/), [tor browser](https://www.torproject.org/), [ncsa mosiac (AI)](https://github.com/alandipert/ncsa-mosaic)

Office:
* [libreoffice](https://www.libreoffice.org/), [libreoffice fresh (AI)](https://www.libreoffice.org/download/appimage/)

Editors:
* [gedit](https://wiki.gnome.org/Apps/Gedit), gvim, [medit](http://mooedit.sourceforge.net/), [bluefish](http://bluefish.openoffice.nl/), [geany](https://www.geany.org/), [vscode](https://github.com/microsoft/vscode), [netbeans](https://netbeans.org/), [panwriter (AI)](https://github.com/mb21/panwriter), xfw

Torrenting:
* qbittorrent, ktorrent, deluge, transmission-gtk, bitstormlite, [electorrent (AI)](https://github.com/tympanix/Electorrent)

Chat:
* [empathy](https://wiki.gnome.org/action/show/Apps/Empathy), [hexchat](https://hexchat.github.io/), [loqui](https://launchpad.net/loqui), [konversation](https://konversation.kde.org/), [kopete](https://kde.org/applications/internet/org.kde.kopete), [pidgin](https://pidgin.im/), [polari](https://wiki.gnome.org/Apps/Polari), qchat, ring, [xchat](http://xchat.org/)

Music:
* [amarok](https://amarok.kde.org/), [audacious](https://audacious-media-player.org/), [banshee](http://banshee.fm/), [rhythmbox](https://wiki.gnome.org/Apps/Rhythmbox)

Graphics:
* [gimp](https://www.gimp.org/), [inkscape](https://inkscape.org/), [krita](https://krita.org/), [blender](https://www.blender.org/)

File Managers:
* [caja](https://github.com/mate-desktop/caja), [xfe](http://roland65.free.fr/xfe/)

Utilities:
* galculator, kcalc

Reverse Engineering:
* [cutter (AI)](https://github.com/radareorg/cutter), [packet sender (AI)](https://github.com/dannagle/PacketSender), [ngrev (AI)](https://github.com/mgechev/ngrev)

Misc:
* [dropbox](https://www.dropbox.com/), [slack](https://slack.com/), [gtkstresstesting](https://gitlab.com/leinardi/gst)

## Build it locally using the github repository
```
docker build -t="fullaxx/ubuntu-desktop" github.com/Fullaxx/ubuntu-desktop
```
