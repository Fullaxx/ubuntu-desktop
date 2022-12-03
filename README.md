# Ubuntu Desktop running Openbox/Xfce4/i3 in VNC/RDP

## Base Docker Image
[Ubuntu](https://hub.docker.com/_/ubuntu) (x64)

## Get the image from Docker Hub
```
docker pull fullaxx/ubuntu-desktop
docker pull fullaxx/ubuntu-desktop:focal
docker pull fullaxx/ubuntu-desktop:bionic
docker pull fullaxx/ubuntu-desktop:xfce4
docker pull fullaxx/ubuntu-desktop:i3
docker pull fullaxx/ubuntu-desktop:rdp
```

## Build it locally using the github repository
```
docker build -t="fullaxx/ubuntu-desktop"        github.com/Fullaxx/ubuntu-desktop
docker build -t="fullaxx/ubuntu-desktop:focal"  github.com/Fullaxx/ubuntu-desktop#focal
docker build -t="fullaxx/ubuntu-desktop:bionic" github.com/Fullaxx/ubuntu-desktop#bionic
docker build -t="fullaxx/ubuntu-desktop:xfce4"  github.com/Fullaxx/ubuntu-desktop#xfce4
docker build -t="fullaxx/ubuntu-desktop:i3"     github.com/Fullaxx/ubuntu-desktop#i3
docker build -t="fullaxx/ubuntu-desktop:rdp"    github.com/Fullaxx/ubuntu-desktop#rdp
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
Optional: Bind to Port 5909 \
Default: port 5901
```
-e VNCPORT='9'
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
Optional: Run as a new non-root user \
Default: root (UID: 0)
```
-e VNCUSER='guest' -e VNCUID='1000'
```
Optional: If you want your non-root user to be part of the users group \
Default: same as VNCUSER and VNCUID \
Pre-Req: VNCUSER and VNCUID must be set
```
-e VNCGROUP='users'
```
Optional: Define a new group for non-root user \
Default: same as VNCUSER and VNCUID \
Pre-Req: VNCUSER and VNCUID must be set
```
-e VNCGROUP='guests' -e VNCGID='1001'
```
Optional: Set a password for the VNCUSER account \
Default: none and the account is locked \
Pre-Req: VNCUSER and VNCUID must be set
```
-e ACCTPASS='mysecretpassword'
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
[1](http://digitalblasphemy.com/graphics/HDfree/metallurgy1HDfree.jpg) /
[2](http://digitalblasphemy.com/graphics/HDfree/portals1HDfree.jpg) /
[3](http://digitalblasphemy.com/graphics/HDfree/cronusrising2k141HDfree.jpg) /
[4](http://digitalblasphemy.com/graphics/HDfree/harbinger2k91HDfree.jpg) /
[5](http://digitalblasphemy.com/graphics/HDfree/arcana2HDfree.jpg) /
[6](http://digitalblasphemy.com/graphics/HDfree/rivenHDfree.jpg) /
[7](http://digitalblasphemy.com/graphics/HDfree/circularlogicHDfree.jpg) /
[8](http://digitalblasphemy.com/graphics/HDfree/gardener2k121HDfree.jpg) \
Layout Options: fill / extend / full / tile / cover / center \
Default Layout: center
```
-e WALLPAPER='1'
-e WALLPAPER='3'
-e WALLPAPER='5' -e WPLAYOUT='cover'
```

## Sound Configuration (to support audio)
Passthrough for audio devices inside the container
```
--device /dev/snd
or
--privileged
```

## FUSE Configuration (to support AppImages)
Set privileges to allow FUSE to work properly inside the container
```
--device /dev/fuse --cap-add SYS_ADMIN
```

## Privileged Mode (to support FlatPak)
Set privileged mode to allow FlatPaks to work properly inside the container
```
--privileged
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
Run the image using host networking binding tigervncserver to port 5909
```
docker run -d --network=host -e VNCPORT='9' fullaxx/ubuntu-desktop
```
Run the image on localhost port 5901 with a decent hostname
```
docker run -d -h mycagedbuntu -p 127.0.0.1:5901:5901 fullaxx/ubuntu-desktop
```

## Connect using vncviewer or a web browser
Use any standard VNC client to connect directly. \
For web access, check out [noVNC](https://hub.docker.com/r/fullaxx/novnc) to access your ubuntu-desktop with a web browser.
```
vncviewer 127.0.0.1:5901
```

## Using the Openbox Desktop Environment
Right-Click to activate the Openbox menu system. \
You will find a number of convenience scripts for running applications.

Terminals:
* [xterm](https://invisible-island.net/xterm/), uxterm, [Eterm](https://sourceforge.net/projects/eterm/), [sakura](http://www.pleyades.net/david/projects/sakura), [terminology](https://www.enlightenment.org/about-terminology.md), [terminator](https://gnome-terminator.org/), [tilix](https://gnunn1.github.io/tilix-web/), [tilda](https://github.com/lanoxx/tilda), [archipelago (AI)](https://github.com/npezza93/archipelago), [hyper (AI)](https://github.com/zeit/hyper), [powershell](https://github.com/PowerShell/PowerShell)

Browsers:
* [chrome](https://www.google.com/chrome/), [chromium](https://www.chromium.org/), [firefox](https://www.mozilla.org/en-US/firefox/), [vivaldi](https://vivaldi.com/), [tor browser](https://www.torproject.org/), [ncsa mosiac (AI)](https://github.com/alandipert/ncsa-mosaic), [edge](https://www.microsoftedgeinsider.com/en-us/download/), [Pale Moon](https://www.palemoon.org/)

Office:
* [libreoffice](https://www.libreoffice.org/), [libreoffice fresh (AI)](https://www.libreoffice.org/download/appimage/)

Editors:
* [gedit](https://wiki.gnome.org/Apps/Gedit), gvim, [medit](http://mooedit.sourceforge.net/), [bluefish](http://bluefish.openoffice.nl/), [geany](https://www.geany.org/), [SublimeText](https://www.sublimetext.com/), [vscode](https://github.com/microsoft/vscode), [netbeans](https://netbeans.org/), [CherryTree](https://www.giuspen.com/cherrytree/), [panwriter (AI)](https://github.com/mb21/panwriter), xfw

Torrenting:
* [BiglyBT](https://www.biglybt.com/), [qbittorrent](https://www.qbittorrent.org/), [ktorrent](https://apps.kde.org/ktorrent/), [deluge](https://deluge-torrent.org/), transmission-gtk, [bitstormlite](https://sourceforge.net/projects/bbom/), [electorrent (AI)](https://github.com/tympanix/Electorrent)

Chat:
* [empathy](https://wiki.gnome.org/action/show/Apps/Empathy), [hexchat](https://hexchat.github.io/), [loqui](https://launchpad.net/loqui), [konversation](https://konversation.kde.org/), [kopete](https://kde.org/applications/internet/org.kde.kopete), [pidgin](https://pidgin.im/), [polari](https://wiki.gnome.org/Apps/Polari), qchat, ring, [xchat](http://xchat.org/)

Games:
* [Steam](https://store.steampowered.com/)

Music:
* [amarok](https://amarok.kde.org/), [audacious](https://audacious-media-player.org/), [banshee](http://banshee.fm/), [clementine](https://www.clementine-player.org/), [deadbeef](https://deadbeef.sourceforge.io/), [gmusicbrowser](https://gmusicbrowser.org/), [gpodder](https://gpodder.github.io/), [pragha](https://pragha-music-player.github.io/), [quodlibet](https://quodlibet.readthedocs.io/en/latest/), [rhythmbox](https://wiki.gnome.org/Apps/Rhythmbox), [smplayer](https://www.smplayer.info/), [strawberry](https://www.strawberrymusicplayer.org/)

Graphics:
* [gimp](https://www.gimp.org/), [inkscape](https://inkscape.org/), [krita](https://krita.org/), [blender](https://www.blender.org/)

File Managers:
* [4pane](http://www.4pane.co.uk/), [caja](https://github.com/mate-desktop/caja), [doublecommander](https://doublecmd.sourceforge.io/), [krusader](https://krusader.org/), [nemo](https://github.com/linuxmint/nemo), [pcmanfm](https://wiki.lxde.org/en/PCManFM), [spacefm](https://ignorantguru.github.io/spacefm/), [thunar](https://docs.xfce.org/xfce/thunar/start), [xfe](http://roland65.free.fr/xfe/), [worker](http://www.boomerangsworld.de/cms/worker/)

Utilities:
* [galculator](http://galculator.mnim.org/), [kcalc](https://apps.kde.org/kcalc/)

Reverse Engineering:
* [cutter (AI)](https://github.com/radareorg/cutter), [packet sender (AI)](https://github.com/dannagle/PacketSender), [ngrev (AI)](https://github.com/mgechev/ngrev)

Misc:
* [veracrypt](https://veracrypt.fr/), [dropbox](https://www.dropbox.com/), [slack](https://slack.com/), [gtkstresstesting (FP)](https://gitlab.com/leinardi/gst)
