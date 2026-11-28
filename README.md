# Ubuntu Desktop running Openbox in VNC/RDP

## Base Docker Image
[Ubuntu](https://hub.docker.com/_/ubuntu) 26.04 (x64), and older releases on their own branches

## Branches and tags
Each branch publishes its own tags of `ghcr.io/fullaxx/ubuntu-desktop`, rebuilt at every push:

| Tag | Branch | Ubuntu |
| --- | --- | --- |
| `:latest`, `:26.04`, `:resolute` | [`master`](https://github.com/Fullaxx/ubuntu-desktop/tree/master) | 26.04 (resolute) |
| `:24.04`, `:noble` | [`24.04`](https://github.com/Fullaxx/ubuntu-desktop/tree/24.04) | 24.04 (noble) |
| `:jammy` | [`jammy`](https://github.com/Fullaxx/ubuntu-desktop/tree/jammy) | 22.04 (jammy) |
| `:focal` | [`focal`](https://github.com/Fullaxx/ubuntu-desktop/tree/focal) | 20.04 (focal) |

- `:latest` tracks 26.04: every push to `master` publishes the same image as `:latest`, `:26.04` and `:resolute`, and so does the monthly rebuild.
- `24.04` gets fixes only, no new features or breaking changes. Its README uses `:24.04` in every example.
- Every push to `master` or `24.04` is also tagged `<branch>-<short commit>`, such as `:master-5246e30`. These tags don't move to later commits (a manual CI run of the same commit pushes its tag again).
- The examples below use `:latest`. Everything in this README works the same with `:26.04`.

## Get the image
```
docker pull ghcr.io/fullaxx/ubuntu-desktop
docker pull ghcr.io/fullaxx/ubuntu-desktop:26.04
docker pull ghcr.io/fullaxx/ubuntu-desktop:24.04
docker pull ghcr.io/fullaxx/ubuntu-desktop:jammy
docker pull ghcr.io/fullaxx/ubuntu-desktop:focal
```
Older releases, from 2025, are on Docker Hub
```
docker pull fullaxx/ubuntu-desktop:bionic
docker pull fullaxx/ubuntu-desktop:rdp
```

## Build it locally using the github repository
```
docker build -t="ghcr.io/fullaxx/ubuntu-desktop"        https://github.com/Fullaxx/ubuntu-desktop.git
docker build -t="ghcr.io/fullaxx/ubuntu-desktop:24.04"  https://github.com/Fullaxx/ubuntu-desktop.git#24.04
docker build -t="ghcr.io/fullaxx/ubuntu-desktop:jammy"  https://github.com/Fullaxx/ubuntu-desktop.git#jammy
docker build -t="ghcr.io/fullaxx/ubuntu-desktop:focal"  https://github.com/Fullaxx/ubuntu-desktop.git#focal
docker build -t="ghcr.io/fullaxx/ubuntu-desktop:bionic" https://github.com/Fullaxx/ubuntu-desktop.git#bionic
docker build -t="ghcr.io/fullaxx/ubuntu-desktop:rdp"    https://github.com/Fullaxx/ubuntu-desktop.git#rdp
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
Optional: Keep the desktop at its size: VNC clients (noVNC's remote resizing, a viewer's) can't resize it \
Default: clients can resize the desktop
```
-e VNCRESIZE='0'
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
Optional: Run as a non-root user (see [Non-root users](#non-root-users)) \
Default: root (UID: 0)
```
-e VNCUSERMAP='guest/1001'
```
Optional: Set the primary group of a new non-root user \
Default: same name and number as VNCUSERMAP \
Pre-Req: VNCUSERMAP must be set; the group is created, its GID must be free and greater than 1000
```
-e VNCGROUPMAP='guests/1002'
```
Optional: Set a password for the non-root user \
Default: none and the account is locked \
Pre-Req: VNCUSERMAP must be set
```
-e ACCTPASS='mysecretpassword'
```
Optional: Set umask to define permission for new files \
Default: 0022 for root, 0002 for a non-root user whose group has the same name
```
-e VNCUMASK='0002'
```

## Non-root users
Ubuntu 24.04 and later images (this one is 26.04) already contain a user named `ubuntu` with UID and GID 1000.
The startup scripts were written for Ubuntu 22.04, which had no such user, so the old example
`-e VNCUSER='guest' -e VNCUID='1000'` collided with it and the container exited.
There are now two distinct ways to run as a non-root user, each set with `VNCUSERMAP=name/uid`
(and optionally `VNCGROUPMAP=name/gid` for the primary group).

Use the built-in `ubuntu` account as is \
The maps must match it (VNCGROUPMAP, if set, must be ubuntu/1000)
```
-e VNCUSERMAP='ubuntu/1000'
```
Create your own account with any other name \
Its UID and GID must be free and greater than 1000, and its group is created too \
It joins the sudo, audio and video groups, like the built-in account
```
-e VNCUSERMAP='guest/1001'
-e VNCUSERMAP='guest/1001' -e VNCGROUPMAP='guests/1002'
```
Anything else, such as `-e VNCUSERMAP='guest/1000'`, stops the container, and `docker logs` explains why.

`VNCUSER`, `VNCUID`, `VNCGROUP` and `VNCGID` were replaced by `VNCUSERMAP` and `VNCGROUPMAP`. \
A container started with only the old variables runs as root and shows a notice in the desktop and in `docker logs`.

## TimeZone Configuration
Set the timezone to be used inside the container (it also sets /etc/localtime) \
Default: UTC \
A name that isn't in /usr/share/zoneinfo is reported in `docker logs`; all the details: [LOCALE.md](LOCALE.md#time-zone-tz)
```
-e TZ='Asia/Tokyo'
-e TZ='Europe/London'
-e TZ='America/Los_Angeles'
-e TZ='America/Denver'
-e TZ='America/Chicago'
-e TZ='America/New_York'
```

## Locale Configuration
Set the language of programs that have a translation, and how dates, times and numbers are written \
Openbox's right-click menu stays English: [what gets translated](LOCALE.md#what-gets-translated) \
All the details, more examples and how it works: [LOCALE.md](LOCALE.md)

Optional: Set the locale \
Default: en_US (English, 11/19/2026, 03:12:31 PM, 1,234,567.89) \
Chinese, Japanese, Korean, Hindi, Thai, Hebrew, Arabic, Vietnamese and some other languages need a font first: [LOCALE.md](LOCALE.md#fonts) \
This image leaves those fonts out to stay small; an [input method](#input-method-configuration) for the language brings its font, and [ubuntu-desktop-xfce](https://github.com/Fullaxx/ubuntu-desktop-xfce) has them built in
```
-e LOCALE='en_GB'
-e LOCALE='de_DE'
-e LOCALE='fr_FR'
-e LOCALE='es_MX'
-e LOCALE='pt_BR'
-e LOCALE='ru_RU'
```
Optional: Set the locale with LANG instead, so that `docker exec` shells use it too \
Default: en_US.UTF-8 in the desktop, none (ASCII only) in `docker exec` shells \
Write it with .UTF-8; if LOCALE is set too, LOCALE wins
```
-e LANG='de_DE.UTF-8'
-e LANG='fr_FR.UTF-8'
```
Optional: Set only the language of programs that have a translation, and keep the locale's dates and numbers \
Default: the locale's language
```
-e LOCALE='de_DE' -e LANGUAGE='en'
-e LANGUAGE='de'
```
Use these instead of LC_ALL, LC_TIME and the other LC_ variables, which don't work here: [LOCALE.md](LOCALE.md#dont)

## Input Method Configuration
Type Chinese, Japanese, Korean, Vietnamese, the Indian scripts and more: Ctrl+Space switches between plain letters and the input method \
All the details, the names for each language and how it works: [INPUT_METHODS.md](INPUT_METHODS.md)

Optional: The input methods, by fcitx5's names, separated by commas \
Default: None (with it, the container's first start installs fcitx5, those input methods and the fonts they type in: about 15 seconds, and 165 to 360 MB)
```
-e INPUT_METHOD='pinyin'
-e INPUT_METHOD='anthy'
-e INPUT_METHOD='hangul'
-e INPUT_METHOD='unikey'
-e INPUT_METHOD='pinyin,anthy,hangul'
```
Mozc (Japanese) needs a non-root desktop user, and is left out on a root desktop: [INPUT_METHODS.md](INPUT_METHODS.md#mozc-and-root)
```
-e INPUT_METHOD='mozc' -e VNCUSERMAP='ubuntu/1000'
```

## Wallpaper Configuration
Set a background image for the openbox desktop \
Default: None \
Image Links:
[1](https://images.rapidlinux.org/udwp/metallurgy1HDfree.jpg) /
[2](https://images.rapidlinux.org/udwp/portals1HDfree.jpg) /
[3](https://images.rapidlinux.org/udwp/cronusrising2k141HDfree.jpg) /
[4](https://images.rapidlinux.org/udwp/harbinger2k91HDfree.jpg) /
[5](https://images.rapidlinux.org/udwp/arcana2HDfree.jpg) /
[6](https://images.rapidlinux.org/udwp/rivenHDfree.jpg) /
[7](https://images.rapidlinux.org/udwp/circularlogicHDfree.jpg) /
[8](https://images.rapidlinux.org/udwp/gardener2k121HDfree.jpg) /
[9](https://images.rapidlinux.org/udwp/overseer2k141_single_1920x1080.jpg) \
Layout Options: fill / extend / full / tile / cover / center \
Default Layout: center
```
-e WALLPAPER='1'
-e WALLPAPER='3'
-e WALLPAPER='5' -e WPLAYOUT='cover'
```

## Extra privileges
Sound, FUSE (sshfs), FlatPak and VeraCrypt need extra docker run options, each with its own cost: [PRIVILEGES.md](PRIVILEGES.md)

## Troubleshooting
Known problems and their fixes, such as browser tabs crashing: [troubleshooting/](troubleshooting/)

## Run the image
Run the image on localhost port 5901 with default configuration
```
docker run -d -p 127.0.0.1:5901:5901 ghcr.io/fullaxx/ubuntu-desktop
```
Run the image with Depth 16
```
docker run -d -p 127.0.0.1:5901:5901 -e VNCDEPTH='16' ghcr.io/fullaxx/ubuntu-desktop
```
Run the image with 1920x1080 Resolution
```
docker run -d -p 127.0.0.1:5901:5901 -e VNCRES='1920x1080' ghcr.io/fullaxx/ubuntu-desktop
```
Run the image with a desktop clients can't resize
```
docker run -d -p 127.0.0.1:5901:5901 -e VNCRESIZE='0' ghcr.io/fullaxx/ubuntu-desktop
```
Run the image with Password Authentication
```
docker run -d -p 127.0.0.1:5901:5901 -e VNCPASS='vncpass' ghcr.io/fullaxx/ubuntu-desktop
```
Run the image with Read-Write and Read-Only password (Using R/O pass requires R/W pass)
```
docker run -d -p 127.0.0.1:5901:5901 -e VNCPASS='vncpass' -e VNCPASSRO='readonly' ghcr.io/fullaxx/ubuntu-desktop
```
Run the image as the built-in ubuntu user account
```
docker run -d -p 127.0.0.1:5901:5901 -e VNCUSERMAP='ubuntu/1000' ghcr.io/fullaxx/ubuntu-desktop
```
Run the image as a new non-root user account
```
docker run -d -p 127.0.0.1:5901:5901 -e VNCUSERMAP='guest/1001' ghcr.io/fullaxx/ubuntu-desktop
```
Run the image as a new non-root user account with custom group
```
docker run -d -p 127.0.0.1:5901:5901 -e VNCUSERMAP='guest/1001' -e VNCGROUPMAP='guests/1002' ghcr.io/fullaxx/ubuntu-desktop
```
Run the image in Tokyo
```
docker run -d -p 127.0.0.1:5901:5901 -e TZ='Asia/Tokyo' ghcr.io/fullaxx/ubuntu-desktop
```
Run the image in Berlin, with German dates and numbers
```
docker run -d -p 127.0.0.1:5901:5901 -e TZ='Europe/Berlin' -e LOCALE='de_DE' ghcr.io/fullaxx/ubuntu-desktop
```
Run the image using host networking binding tigervncserver to port 5909
```
docker run -d --network=host -e VNCPORT='9' ghcr.io/fullaxx/ubuntu-desktop
```
Run the image on localhost port 5901 with a decent hostname
```
docker run -d -h mycagedbuntu -p 127.0.0.1:5901:5901 ghcr.io/fullaxx/ubuntu-desktop
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
* [xterm](https://invisible-island.net/xterm/), uxterm, [Eterm](https://sourceforge.net/projects/eterm/), [kitty](https://github.com/kovidgoyal/kitty), [sakura](http://www.pleyades.net/david/projects/sakura), [terminology](https://www.enlightenment.org/about-terminology.md), [terminator](https://gnome-terminator.org/), [tilix](https://gnunn1.github.io/tilix-web/), [tilda](https://github.com/lanoxx/tilda), [guake](https://github.com/Guake/guake), [powershell](https://github.com/PowerShell/PowerShell)

Office:
* [libreoffice](https://www.libreoffice.org/)

Editors:
* [gedit](https://wiki.gnome.org/Apps/Gedit), gvim, [medit](http://mooedit.sourceforge.net/), [bluefish](http://bluefish.openoffice.nl/), [geany](https://www.geany.org/), [thonny](https://thonny.org/), [SublimeText](https://www.sublimetext.com/), [vscode](https://github.com/microsoft/vscode), [netbeans](https://netbeans.org/), [CherryTree](https://www.giuspen.com/cherrytree/), xfw

Browsers:
* [firefox](https://www.mozilla.org/en-US/firefox/), [chromium](https://www.chromium.org/), [chrome](https://www.google.com/chrome/), [edge](https://www.microsoft.com/en-us/edge/download), [vivaldi](https://vivaldi.com/), [brave](https://brave.com/), [opera](https://www.opera.com/), [tor browser](https://www.torproject.org/), [zen browser](https://zen-browser.app/), [Pale Moon](https://www.palemoon.org/)

BitTorrent:
* [BiglyBT](https://www.biglybt.com/), [deluge](https://deluge-torrent.org/), [qbittorrent](https://www.qbittorrent.org/), [ktorrent](https://apps.kde.org/ktorrent/), transmission-gtk, [bitstormlite](https://sourceforge.net/projects/bbom/)

Chat:
* [discord](https://discord.com/), [empathy](https://wiki.gnome.org/action/show/Apps/Empathy), [hexchat](https://hexchat.github.io/), [loqui](https://launchpad.net/loqui), [konversation](https://konversation.kde.org/), [kopete](https://kde.org/applications/internet/org.kde.kopete), [kvirc](https://www.kvirc.net/), [pidgin](https://pidgin.im/), [polari](https://wiki.gnome.org/Apps/Polari), qchat, [quassel](https://quassel-irc.org/), ring, [signal](https://signal.org/), [slack](https://slack.com/), [srain](https://srain.silverrainz.me/), [xchat](http://xchat.org/)

Mail:
* [claws-mail](https://www.claws-mail.org/), [sylpheed](https://sylpheed.sraoss.jp/en/), [thunderbird](https://www.thunderbird.net/)

Cloud Storage:
* [dropbox](https://www.dropbox.com/), [mega](https://mega.io/desktop), [nextcloud](https://nextcloud.com/), [owncloud](https://owncloud.com/), [rclone browser](https://github.com/kapitainsky/RcloneBrowser), [seafile](https://www.seafile.com/)

Network Tools:
* [filezilla](https://filezilla-project.org/), [gftp](https://github.com/masneyb/gftp), [zenmap](https://nmap.org/zenmap/)

File Managers:
* [4pane](http://www.4pane.co.uk/), [caja](https://github.com/mate-desktop/caja), [doublecommander](https://doublecmd.sourceforge.io/), [krusader](https://krusader.org/), [nemo](https://github.com/linuxmint/nemo), [pcmanfm](https://wiki.lxde.org/en/PCManFM), [spacefm](https://ignorantguru.github.io/spacefm/), [thunar](https://docs.xfce.org/xfce/thunar/start), [xfe](http://roland65.free.fr/xfe/), [worker](http://www.boomerangsworld.de/cms/worker/)

Games:
* [Steam](https://store.steampowered.com/)

Music:
* [amarok](https://amarok.kde.org/), [audacious](https://audacious-media-player.org/), [banshee](http://banshee.fm/), [clementine](https://www.clementine-player.org/), [deadbeef](https://deadbeef.sourceforge.io/), [gmusicbrowser](https://gmusicbrowser.org/), [gpodder](https://gpodder.github.io/), [pragha](https://pragha-music-player.github.io/), [quodlibet](https://quodlibet.readthedocs.io/en/latest/), [rhythmbox](https://wiki.gnome.org/Apps/Rhythmbox), [smplayer](https://www.smplayer.info/), [strawberry](https://www.strawberrymusicplayer.org/)

Graphics:
* [gimp](https://www.gimp.org/), [inkscape](https://inkscape.org/), [krita](https://krita.org/), [blender](https://www.blender.org/)

AV:
* [guvcview](https://guvcview.sourceforge.net/), [kdenlive](https://kdenlive.org/), [winff](https://github.com/WinFF/winff), [flowblade](https://jliljebl.github.io/flowblade/), [lives](http://www.lives-video.com/), [shotcut](https://www.shotcut.org/), [olive](https://www.olivevideoeditor.org/), [gopchop](https://gopchop.org/), [openshot](https://www.openshot.org/), [vidcutter](https://github.com/ozmartian/vidcutter), [videocut](https://github.com/kanehekili/VideoCut)

Calculators:
* [galculator](http://galculator.mnim.org/), [gnome-calculator](https://apps.gnome.org/Calculator/), [kcalc](https://apps.kde.org/kcalc/), [mate-calc](https://github.com/mate-desktop/mate-calc), [qalculate](https://qalculate.github.io/), [speedcrunch](https://speedcrunch.org/)

Passwords:
* [keepassxc](https://keepassxc.org/)

Archive Managers:
* [engrampa](https://github.com/mate-desktop/engrampa)

Misc:
* [veracrypt](https://veracrypt.fr/), [gtkstresstesting (FP)](https://gitlab.com/leinardi/gst)
